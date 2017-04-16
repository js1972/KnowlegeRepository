var JerryTimer = (function(){
	var startTime;
	function start(){
		startTime  = new Date().getTime();
	}

	function end(){
		return new Date().getTime() - startTime;
	}

	function block(seconds){
		let blockTime = seconds * 1000;
		let start = new Date().getTime();
		while( new Date().getTime() - start < blockTime){

		}
	}
	return {
		start: start,
		end: end,
		block: block
	}
})();