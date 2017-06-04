const express = require('express');  
const app = express();  
const port = 3000;

var path = require('path');
var repo = {
	"I042416": "Jerry",
	"I042417": "Tom",
	"I042418": "Jim"
}
app.use(express.static(path.join(__dirname, 'public')));

app.get('/request', (request, response) => {  
  console.log("The employee ID sent from Client:" + request.query.id);
  response.json({
    UserName: repo[request.query.id] + " ( handled in port 3000 )"
  });
});

app.get('/', (request, response) => {  
  response.end("Server 3000 is running");
});
app.listen(port, (err) => {  
  if (err) {
    return console.log('something bad happened', err)
  }
  console.log(`server is listening on ${port}`)
});