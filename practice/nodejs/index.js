/*
The http module is very low-level - creating a complex web application using the 
snippet above is very time-consuming. This is the reason why we usually pick a 
framework to work with for our projects. There are a lot you can pick from, 
but these are the most popular ones:
Express
Jerry 2017-05-31 11:42AM - good document: https://blog.risingstack.com/your-first-node-js-http-server/

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

/*
app.get('/', (request, response) => {  
  response.send('Hello from Express!')
});

app.get('/Jerry', (request, response) => {  
  response.send('Hello Jerry!');
  console.log(request.headers);
});
*/

// Jerry 2017-05-31 11:57AM:
/* app.use: this is how you can define middlewares - 
it takes a function with three parameters, the first being the request, 
the second the response and the third one is the next callback. 
Calling next signals Express that it can jump to the next middleware or route handler.*/

app.use((request, response, next) => {  
  console.log(request.headers)
  next()
})

app.use((request, response, next) => {  
  request.chance = Math.random()
  next()
})

app.get('/', (request, response) => {  
  response.json({
    chance: request.chance
  })
});

app.get('/error', (request, response) => {  
  throw new Error('Jerry oops')
});
/*
The error handler function should be the last function added with app.use.
The error handler has a next callback - it can be used to chain multiple error handlers.
*/ 
app.use((err, request, response, next) => {  
  // log the error, for now just console.log
  console.log(err)
  response.status(500).send('Something broke!')
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

/*Jerry 2017-05-31 4:20PM - useful code to read file content
var http = require('http');
var fs = require('fs');
var index = fs.readFileSync('index.html');

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end(index);
}).listen(9615);
*/