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

## Static programming language Vs Dynamic programming language
* Static programming language: Data structure & class attribute could not be changed in the runtime.

* Dynamic programming language: variable data structure ( attribute and method of a function -consider JavaScript function object ) could be changed in the runtime. 
Example: JavaScript, Ruby, Python