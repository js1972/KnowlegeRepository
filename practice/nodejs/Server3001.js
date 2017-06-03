const express = require('express');  
const app = express();  
const port = 3001;

var path = require('path');
var repo = {
	"I042416": "Jerry",
	"I042417": "Tom",
	"I042418": "Jim"
}
app.use(express.static(path.join(__dirname, 'public')));

app.get('/request', (request, response) => {  
  // console.log(request.headers);
  console.log(request.query.id);
  response.json({
    UserName: repo[request.query.id] + " ( handled in port 3001 )"
  });
});

app.get('/request_jsonp', (request, response) => {  
  // console.log(request.headers);
  console.log(request.query.id);
  var data = "{" + "UserName:'" + repo[request.query.id] + " ( handled in port 3001 )'"
  + "}";
  var callback = request.query.callback;
  var jsonp = callback + '(' + data + ')';
  console.log(jsonp);
  response.send(jsonp);
  response.end();
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