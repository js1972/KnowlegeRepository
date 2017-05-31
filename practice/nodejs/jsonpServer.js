const express = require('express');  
const app = express();  
const port = 3000;

var path = require('path');

// The skeleton for this applies an express.static method as 
// Express middleware via app.use, looking like this.
// app.use(express.static());
// app.use('/jerry', express.static(path.join(__dirname, 'webapp')));
app.use(express.static(path.join(__dirname, 'public')));
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

/* Jerry 2017-05-31 16:52PM 
Jerry alternative:
// Define the port to run on
app.set('port', 3000);
// Listen for requests
var server = app.listen(app.get('port'), function() {
  var port = server.address().port;
  console.log('Magic happens on port ' + port);
});

*/