var CL_JS_CORRESPONDING = function() { 
  
 function MappingExecutor(src, target, mapping){
 	this.src = src;
 	this.target = target;
 	this.mapping = mapping;
 	function _map(source, target, mapping){
 		for( var i = 0; i < source.length; i++){
 			_mapEach(source[i], target[i], mapping);
 		}
 	}
 	function _mapEach(source, target, mapping){
 		target[mapping.target] = source[mapping.source];
 		if( mapping.function){
 			target[mapping.target] = mapping.function.call(null, target[mapping.target]);
 		}
 	}
 	MappingExecutor.prototype.execute = function(){
 		for( var i = 0; i < this.mapping.length; i++){
 			_map(this.src, this.target, this.mapping[i]);
 		}
 		return this.target;
 	}
 };
 return { 
    CREATE:function(src,target,mapping){
   	  if( !Array.isArray(src) || !Array.isArray(target)){
   	  	return target;
   	  }
   	  if( src.length != target.length){
   	  	return target;
   	  }
   	  if( src.length == 0){
   	  	return target;
   	  }
   	  return new MappingExecutor(src, target, mapping);
  }
}}(); 