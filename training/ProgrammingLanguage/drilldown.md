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

# Examples for Evaluation (in SML)

The print statements help us understand that the argument is evaluated first, followed by the actual function call to f.

The evaluation strategy in which function arguments are evaluated before the function call is made is known as an "eager" evaluation. Eager evaluation is used by most well-known modern programming languages, and it might seem so natural that we don't even consider the possibility of alternative evaluation strategies.

# There Is No Such Thing As A Perfect Check

# Jerry added: "Correct" program gets rejected by Compiler

```Java
public class ExceptionForQuiz<T extends Exception> {
	private void pleaseThrow(final Exception t) throws T {
		throw (T) t;
	}

	public static void main(final String[] args) {
		try {
			new ExceptionForQuiz<RuntimeException>()
					.pleaseThrow(new SQLException());
		} catch (final SQLException ex) {
			System.out.println("Jerry print, the exception class: " + ex.getClass().getSimpleName());			
			ex.printStackTrace();
		}
	}
}
```
ExceptionQuiz: Catch RuntimeException, no compile error, but cannot catch SQLException. I have to replace with catching Exception instead.

# Closure

## Lexical Scope vs. Dynamic Scope 

词法作用域 vs 动态作用域
* 1. 在词法作用域下，一个符号参照到语境中符号名字出现的地方(可以理解为参照到定义)
* 2. 变量的作用域是在定义时决定而不是执行时决定，也就是说词法作用域取决于源码，通过静态分析就能确定，因此词法作用域也叫做静态作用域。


