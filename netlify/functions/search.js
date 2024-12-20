const fetch = require('node-fetch');

exports.handler = async function(event, context) {
  const { query, location, maxDistance, priceRange } = event.queryStringParameters;

  try {
    const searchQuery = `${location} ${query}`;
    const response = await fetch(
      `https://openapi.naver.com/v1/search/local.json?query=${encodeURIComponent(searchQuery)}`,
      {
        headers: {
          'X-Naver-Client-Id': process.env.NAVER_CLIENT_ID,
          'X-Naver-Client-Secret': process.env.NAVER_CLIENT_SECRET
        }
      }
    );
    
    const data = await response.json();
    
    if (data.items) {
      data.items = data.items.filter(item => {
        return true;
      });
    }
    
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify(data)
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
}; 