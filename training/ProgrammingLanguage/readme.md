
Topic     | Assignee|Page range|Number
-------- | ---  | --- | --- 
Motivation and General Overview| Orlando | 3~9 | 7
Importance of Type Checking and Evaluation | Jerry | 10~14 | 5
Mutation in Programming Languages | Orlando | 15~26| 12
Closures | Jerry | 27~39 | 12
Polymorphism | Orlando | 40~46 | 7
Object-Oriented Languages - Part1 | Jerry | 47~60 | 14
Object-Oriented Languages - Part2 | Orlando | 61~69 | 9

* Orlando: 7 + 12 + 7 + 9 = 35
* Jerry: 5 + 13 + 14 = 32 

# Static typed Vs Dynamic typed

* static typed language: variable data type is determined in compiler time.
Java, C, C++, C#, ABAP

* dynamic typed language: variable data type is determined and fixed in runtime.
```JavaScript
	function add(a,b){
		return a + b;
	}
	add(1,2);
	add('1',2);
```
JavaScript, Ruby, Python

# Static programming language Vs Dynamic programming language
* Static programming language: Data structure could not be changed in the runtime.

* Dynamic programming language: variable data structure ( attribute and method of a function -consider JavaScript function object ) could be changed in the runtime. 
JavaScript, Ruby, Python

# Strong Type Vs Weak Type

* Strong Type: Once the type of variable is determined, it could not be changed any more. No assignment and initialization is allowed among variables with different type. This is only possible via implicitly / explicipt conversion. 

![clipboard1](https://cloud.githubusercontent.com/assets/5669954/23824112/be05946c-06ab-11e7-9833-d82755d55244.png)

![clipboard2](https://cloud.githubusercontent.com/assets/5669954/23824111/bddc06ba-06ab-11e7-844e-5b7aed948b57.png)


* Weak Type: Type of variable can be changed in the runtime. Assignment and initialization is allowed among variables with different type is allowed. 

![image](https://cloud.githubusercontent.com/assets/5669954/23824144/21345b86-06ac-11e7-9b0b-410a25b3015b.png)







