const path = require('path')  
const port = 3000;
const express = require('express')  
// npm install express-handlebars
const exphbs = require('express-handlebars')

const app = express();

app.engine('.hbs', exphbs({  
  defaultLayout: 'main',
  extname: '.hbs',
  layoutsDir: path.join(__dirname, 'views/layouts')
}))
app.set('view engine', '.hbs')  
app.set('views', path.join(__dirname, 'views'));

app.get('/', (request, response) => {  
/*
The first one is the name of the view,
and the second is the data you want to render.
*/	
  response.render('home', {
    name: 'John'
  })
});  
// Jerry 2017-05-31 12:10PM - start in debugging mode: DEBUG=express* node index.js
// install this tool: npm install -g node-inspector
app.listen(port, (err) => {  
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${port}`)
});
