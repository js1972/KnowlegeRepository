/*
The http module is very low-level - creating a complex web application using the 
snippet above is very time-consuming. This is the reason why we usually pick a 
framework to work with for our projects. There are a lot you can pick from, 
but these are the most popular ones:
Express

Fast, unopinionated, minimalist web framework for Node.js - http://expressjs.com/
*/
// const http = require('http')  
const express = require('express');  
const app = express();  
const port = 3000;

const requestHandler = (request, response) => {  
  console.log(request.url) // now output to CMD console, not browser any more
  response.end('Hello Node.js Server!')
}

app.get('/', (request, response) => {  
  response.send('Hello from Express!')
});

app.get('/Jerry', (request, response) => {  
  response.send('Hello Jerry!');
  console.log(request.headers);
});

app.listen(port, (err) => {  
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${port}`)
});


/*const server = http.createServer(requestHandler);

server.listen(port, (err) => {  
  if (err) {
    return console.log('something bad happened', err);
  }

// Jerry 2017-05-31 11:27AM - string template?
  console.log(`server is listening on ${port}`)
})*/