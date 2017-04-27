# 2017-04-24 in Walldorf

原生函数（native function）是 JavaScript语言的一部分，这些函数有别于开发者编写的自定义函数。当我们在 profiler 中查看代码的调用栈时，这些函数是被过滤掉的。我们在 profiler 中看到的只有自己写的代码。
当我们捕获调用栈时，Chrome 并不会捕获 C++ 写的函数。不过，在 V8 引擎中很多 javascript 原生函数都是使用 javascript 语言编写的（使用 javascript 语言编写的）。
V8 使用 JavaScript 本身实现了 JavaScript 语言的大部分内置对象和函数。 例如，promise 功能就是通过 JavaScript 编写的。我们把这样的内置函数称为自主托管（self-hosted）。

# 2017-04-26
不要使用 for…in 来遍历数组，虽然可以遍历，但是如果为 Object.prototype 设置了可枚举属性后，也会把这些属性遍历到，因为数组也是一种对象。

* Object.keys(obj)：返回一个数组，包括对象自身的（不含继承的）所有可枚举属性（不含 Symbol 类型的属性

* Object.getOwnPropertyNames(obj)：返回一个数组，包含对象自身的所有属性（不含 Symbol 类型的属性，不包含继承属性，但是包括不可枚举属性）

* Object.getOwnPropertySymbols(console)：返回一个数组，包含对象自身的所有 Symbol 类型的属性（不包括继承的属性）