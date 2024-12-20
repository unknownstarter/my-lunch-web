const express = require('express')
const cors = require('cors')
const axios = require('axios')

const app = express()
app.use(cors())

app.get('/api/search', async (req, res) => {
  try {
    const response = await axios.get(
      'https://openapi.naver.com/v1/search/local.json' + req._parsedUrl.search,
      {
        headers: {
          'X-Naver-Client-Id': process.env.NAVER_CLIENT_ID,
          'X-Naver-Client-Secret': process.env.NAVER_CLIENT_SECRET
        }
      }
    )
    res.json(response.data)
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
})

module.exports = app 