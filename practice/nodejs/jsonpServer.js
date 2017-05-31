const express = require('express');  
const app = express();  
const port = 3000;

app.use(function (req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    next();
});

app.get('/request', (request, response) => {  
  console.log(request.headers);
  response.json({
    chance: "Hello"
  })
});

app.get('/', (request, response) => {  
  response.end("Server is running");
});
app.listen(port, (err) => {  
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${port}`)
});
