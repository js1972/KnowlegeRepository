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

## Strong Type Vs Weak Type

* Strong Type: Once the type of variable is determined, it could not be changed any more. No assignment and initialization is allowed among variables with different type. This is only possible via implicitly / explicipt conversion. 

![java_type_conversion_compile_error](https://cloud.githubusercontent.com/assets/5669954/24578002/6f01916c-170a-11e7-95d7-f91a73b506f2.png)

![clipboard2](https://cloud.githubusercontent.com/assets/5669954/23824111/bddc06ba-06ab-11e7-844e-5b7aed948b57.png)

* Weak Type: Type of variable can be changed in the runtime. Assignment and initialization is allowed among variables with different type is allowed. 

![image](https://cloud.githubusercontent.com/assets/5669954/23824144/21345b86-06ac-11e7-9b0b-410a25b3015b.png)

## Summary

The comparison of Static / dynamic programming language mainly focus on the fact that whether data structure of variable could be adapted in the runtime, while Strong / Weak Type focus on the possibility of variable assignment among different types.

 