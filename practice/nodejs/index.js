const http = require('http')  
const port = 3000


const requestHandler = (request, response) => {  
  console.log(request.url) // now output to CMD console, not browser any more
  response.end('Hello Node.js Server!')
}

const server = http.createServer(requestHandler);

server.listen(port, (err) => {  
  if (err) {
    return console.log('something bad happened', err);
  }

// Jerry 2017-05-31 11:27AM - string template?
  console.log(`server is listening on ${port}`)
})