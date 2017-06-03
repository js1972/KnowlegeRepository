const express = require('express');  
const app = express();  
const port = 3001;

var path = require('path');

app.use(express.static(path.join(__dirname, 'public')));

app.get('/request', (request, response) => {  
  console.log(request.headers);
  response.json({
    greeting: "Hello " + port
  })
});

app.get('/', (request, response) => {  
  response.end("Server 3001 is running");
});
app.listen(port, (err) => {  
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${port}`)
});