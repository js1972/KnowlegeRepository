function getInstance(){
  var mask;
  return function() {
  	 return mask || ( mask = "Jerry Angular" );
  }
}