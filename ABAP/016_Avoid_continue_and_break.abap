情况1：下面这段代码里面有一个continue：
List<String> goodNames = new ArrayList<>();
for (String name: names) {
  if (name.contains("bad")) {
    continue;
  }
  goodNames.add(name);
  ...
}  
它说：“如果name含有'bad'这个词，跳过后面的循环代码……” 注意，这是一种“负面”的描述，
它不是在告诉你什么时候“做”一件事，而是在告诉你什么时候“不做”一件事。为了知道它到底在干什么，
你必须搞清楚continue会导致哪些语句被跳过了，然后脑子里把逻辑反个向，你才能知道它到底想做什么。
这就是为什么含有continue和break的循环不容易理解，它们依靠“控制流”来描述“不做什么”，“跳过什么”，
结果到最后你也没搞清楚它到底“要做什么”。

其实，我们只需要把continue的条件反向，这段代码就可以很容易的被转换成等价的，不含continue的代码：
List<String> goodNames = new ArrayList<>();
for (String name: names) {
  if (!name.contains("bad")) {
    goodNames.add(name);
    ...
  }
}  
goodNames.add(name);和它之后的代码全部被放到了if里面，多了一层缩进，然而continue却没有了。
你再读这段代码，就会发现更加清晰。因为它是一种更加“正面”地描述。它说：“在name不含有'bad'这个词的时候，
把它加到goodNames的链表里面……”

情况2：for和while头部都有一个循环的“终止条件”，那本来应该是这个循环唯一的退出条件。
如果你在循环中间有break，它其实给这个循环增加了一个退出条件。你往往只需要把这个条件合并到循环头部，
就可以去掉break。比如下面这段代码：
while (condition1) {
  ...
  if (condition2) {
    break;
  }
}

当condition成立的时候，break会退出循环。其实你只需要把condition2反转之后，放到while头部的终止条件，
就可以去掉这种break语句。改写后的代码如下：

while (condition1 && !condition2) {
  ...
}
这种情况表面上貌似只适用于break出现在循环开头或者末尾的时候，然而其实大部分时候，
break都可以通过某种方式，移动到循环的开头或者末尾。