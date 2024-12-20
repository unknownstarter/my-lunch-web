const express = require('express');
const cors = require('cors');
const axios = require('axios');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

// 정적 파일 서빙 (Flutter 웹 빌드 결과물)
app.use(express.static('public')); // Flutter 웹 빌드 파일을 public 폴더에 복사

// API 엔드포인트
app.get('/api/search', async (req, res) => {
  try {
    const { query, latitude, longitude, radius, price } = req.query;
    const searchQuery = `${query} ${price}`;
    
    const response = await axios.get(
      `https://openapi.naver.com/v1/search/local.json`,
      {
        params: {
          query: searchQuery,
          display: 5,
          sort: 'random',  // 네이버 API의 정렬 옵션
        },
        headers: {
          'X-Naver-Client-Id': process.env.NAVER_CLIENT_ID,
          'X-Naver-Client-Secret': process.env.NAVER_CLIENT_SECRET,
        },
      }
    );

    // 검색 결과에 거리 정보 추가
    const results = response.data.items.map(item => {
      const distance = calculateDistance(
        latitude, 
        longitude, 
        item.mapx, 
        item.mapy
      );
      return { ...item, distance };
    });

    res.json({ items: results });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 두 지점 간의 거리 계산 함수
function calculateDistance(lat1, lon1, lat2, lon2) {
  // Haversine 공식을 사용한 거리 계산 로직
  // ... 거리 계산 코드 ...
}

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
}); 