var CL_JS_CORRESPONDING = function() { 
  
 function MappingExecutor(src, target, mapping){
 	this.src = src;
 	this.target = target;
 	this.mapping = mapping;

 	MappingExecutor.prototype.execute = function(){
    var mapCurrentTarget = function(currentTarget, currentSource, mapping){
      mapping.map(function(currentMapping){
        this.currentTarget[currentMapping.target] = this.currentSource[currentMapping.source];
        if( currentMapping.function) {
           this.currentTarget[currentMapping.target] = currentMapping.function.call(null, this.currentTarget[currentMapping.target]);
        }
      }, {
           currentTarget: currentTarget,
           currentSource: currentSource
      });
      return currentTarget;
    }
    var mappingFunctor = function (currentTarget, index){ 
      return mapCurrentTarget(currentTarget, this.src[index], this.mapping);
    };
    return this.target.map(mappingFunctor, this);
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