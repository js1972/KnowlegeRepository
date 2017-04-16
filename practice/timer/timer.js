var JerryTimer = (function(){
	var startTime;
	function start(){
		startTime  = new Date().getTime();
	}

	function end(){
		return new Date().getTime() - startTime;
	}
	return {
		start: start,
		end: end
	}
})();