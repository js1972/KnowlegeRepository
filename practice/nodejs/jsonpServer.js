const express = require('express');  
const app = express();  
const port = 3000;

app.get('/request', (request, response) => {  
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
