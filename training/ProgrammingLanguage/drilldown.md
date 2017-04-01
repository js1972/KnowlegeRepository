# Type Checking & Evaluation of Expressions

static type check vs dynamic runtime check - this is not enough.

## Static typed Vs Dynamic typed

* static typed language: variable data type is determined in compiler time.
Example: Java, C, C++, C#, ABAP

* dynamic typed language: variable data type is determined and fixed in runtime.
```JavaScript
	function add(a,b){
		return a + b;
	}
	add(1,2);
	add('1',2);
```
Example: JavaScript, Ruby, Python