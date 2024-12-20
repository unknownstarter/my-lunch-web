const fetch = require('node-fetch');

exports.handler = async function(event, context) {
  const { foodTypes, location, distance, price } = event.queryStringParameters;
  
  try {
    const searchQuery = `${location} ${foodTypes} 맛집`;
    
    const response = await fetch(
      `https://openapi.naver.com/v1/search/local.json?query=${encodeURIComponent(searchQuery)}&display=15&sort=random`,
      {
        headers: {
          'X-Naver-Client-Id': process.env.NAVER_CLIENT_ID,
          'X-Naver-Client-Secret': process.env.NAVER_CLIENT_SECRET,
          'Accept': 'application/json'
        }
      }
    );
    
    if (!response.ok) {
      throw new Error(`API 요청 실패: ${response.status}`);
    }
    
    const data = await response.json();
    
    if (data.items) {
      data.items = data.items
        .filter(item => {
          const category = item.category.toLowerCase();
          return foodTypes.split(',').some(type => 
            category.includes(type.toLowerCase()) || 
            category.includes('음식점')
          );
        })
        .map(item => ({
          name: item.title.replace(/<[^>]*>/g, ''),
          type: item.category.split('>').pop().trim(),
          address: item.roadAddress || item.address,
          rating: parseFloat(item.rating || '0'),
          link: item.link.replace(/\?.*$/, ''),
          distance: parseFloat(item.distance || '0'),
        }));
    }
    
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    };
  } catch (error) {
    console.error('API 에러:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ 
        error: error.message,
        timestamp: new Date().toISOString()
      })
    };
  }
}; 