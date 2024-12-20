/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require('firebase-functions');
const express = require('express');
const cors = require('cors');
const axios = require('axios');
const admin = require('firebase-admin');

admin.initializeApp();

const app = express();
app.use(cors({ origin: true }));

app.get('/search', async (req, res) => {
  try {
    const response = await axios.get(
      `https://openapi.naver.com/v1/search/local.json${req._parsedUrl.search}`,
      {
        headers: {
          'X-Naver-Client-Id': functions.config().naver.client_id,
          'X-Naver-Client-Secret': functions.config().naver.client_secret,
        },
      }
    );
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

exports.searchRestaurants = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const { query, location, maxDistance, priceRange } = req.query;
      const cacheKey = `${query}_${location}_${maxDistance}_${priceRange}`;
      
      // 캐시된 결과 확인
      const cacheRef = admin.firestore().collection('cache').doc(cacheKey);
      const cache = await cacheRef.get();
      
      if (cache.exists) {
        const cacheData = cache.data();
        const cacheAge = (Date.now() - cacheData.timestamp._seconds * 1000) / 1000 / 60; // 분 단위
        
        if (cacheAge < 60) { // 1시간 이내 캐시 사용
          return res.json(cacheData.results);
        }
      }

      // 네이버 API 호출
      const response = await axios.get(
        'https://openapi.naver.com/v1/search/local.json',
        {
          params: { query, display: 5 },
          headers: {
            'X-Naver-Client-Id': functions.config().naver.client_id,
            'X-Naver-Client-Secret': functions.config().naver.client_secret,
          },
        }
      );

      const results = response.data.items.map(item => ({
        name: item.title.replace(/<[^>]*>/g, ''),
        type: item.category,
        address: item.roadAddress || item.address,
        rating: parseFloat(item.rating || '0'),
        link: item.link,
        distance: parseFloat(item.distance || '0'),
      }));

      // 결과 캐싱
      await cacheRef.set({
        results,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });

      res.json(results);
    } catch (error) {
      console.error('Search error:', error);
      res.status(500).json({
        error: '검색 중 오류가 발생했습니다',
        details: error.message
      });
    }
  });
});

exports.api = functions.https.onRequest(app);

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
