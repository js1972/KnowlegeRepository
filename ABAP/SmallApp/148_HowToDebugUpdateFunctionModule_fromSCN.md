# 目的

在CRM里，当保存一个事务时(在事务代码CRMD_ORDER，或者在CRM WebUI上)，有些函数模块在更新模式下运行。有时这些更新模块里会产生些错误。典型例子就是SAPSQL_ARRAY_INSERT_DUPREC。这个错误会在 CRM_SERVICE_OS_UPD_SUB_DU这样的模块中产生。

这个问题的产生，多数时候是由于同一个事物模块被执行了两遍，并且试图向同一个数据库表里插入同样的数据记录。如果能知道这个事物模块是由谁调用的，我们就能得到清晰的运行逻辑，找出程序这样运行的原因从而进行分析。

通常，系统使用数据库表VBMOD和VBDATA来注册记录并执行更新模块。因此我们可以用事务代码SM13来得到更新模块的相关信息。但是在CRM的CRMD_ORDER和CRM WebUI中，我们在SM13里找不到相应的信息。这是因为CRMD_ORDER和CRM WebUI使用的是ABAP Memory的技术，而不是VBMOD和VBDATA。

我们也可以考虑在更新模块里设一个断点。但是当断点停的时候，已经是在这个模块里面了。我们仍然无法看出来是谁调用的它。
当然，我们也可以把断点设在命令'CALL FUNCTION'或者'CALL FUNCTION IN UPDATE TASK'上。但是这样的话，断点就会在每一个'CALL FUNCTION'语句中停一下。如果幸运，我们可以很快找到调用的那个地方。我是说，如果足够幸运的话。

那么，如果快速定位到某个更新模块是在哪里被调用的呢？在这篇文章里，我会用一个例子来解释我是怎么做的。

# 更新模块的信息是如何被存取的

如果用SE38看一下程序SAPMSSY0，我们就可以看到export to memory id的语句。它把包含了更新模块信息的%_vb_calls写到ABAP memory里。ID号为%%vbkey。
1 export statement.PNG
我们再来看一下程序SAPMSSY4。这里我们能看到import from memory的语句。这个语句把更新模块信息导出到%_vb_calls。
2 import statement.PNG

实例：
我想要找到更新模块CRM_SERVICE_OS_UPD_OST_DU是谁调用的。

事务代码CRMD_ORDER里的步骤：
在SAPMSSY0的第575行和SAPMSSY4的第31行设断点。
创建一个事务，输进必要数据。在保存前先在命令行中输/h，然后回车。
3 create a transaction to save.PNG
点击‘保存’按钮，就会进入DEBUG模式。由于SAPMSSY0和SAPMSSY4是系统程序，所以要察看一下菜单‘Settings’->‘Change Debugger Profiles/Settings’，确保系统DEBUG可行。
4 into debug mode.PNG
5 debug setting.PNG
点F8，断点会停在SAPMSSY0的575行。双击变量vb_func_name，现在它的值是CRM_ACTIVITY_H_UPDATE_DU。
6 stop at export.PNG
从callstack里，双击之前的程序，我们可以看到CRM_ORDER_TABLE_SAVE是如何调用CRM_ACTIVITY_H_UPDATE_DU的。
6-2 stop at export.PNG
如果点F8，察看所有的callstacks，我们可以注意到变量VB_FUNC_NAME实际上就是被调用的更新模块的名称。
7 update tasks calling.PNG
当然，我只想找到CRM_SERVICE_OS_UPD_OST_DU是在哪里被调用的。如果每次都点F8，断点要停很多次。有一个办法可以避免这样。在上面的第5步，我要为断点设一个条件：到'Break/Watchpoints'，点'new'来创建一个条件。
8-1 set condition.PNG
这个条件就是VB_FUNC_NAME='CRM_SERVICE_OS_UPD_OST_DU'。
8-2 set condition.PNG
回到‘standard’，点F8。这一次，断点直接停在'CRM_SERVICE_OS_UPD_OST_DU'被调用的地方。
8-3 back to bk.PNG
%_vb_calls里的内容每次都会变。此时它的内容是这样的：
8-4 vb tab exported.PNG
如果我们再点F8，最终会停到SAPMSSY4的第31行。
9-1 vb table.PNG
%_vb_calls里的内容是：
9-2 vb table.PNG
这之后，系统会循环%_vb_calls里的记录，一条一条地执行相应的更新模块。

# CRM WebUI里的步骤
在CRM webUI里的步骤也是类似的。举例说，创建一个interaction record的过程是：
在SAPMSSY0的第575行和SAPMSSY4的第31行设断点。注意，必须是外部断点（external breakpoint）。
在CL_ICCMP_BT_BUTTONBAR_IMPL->EH_ONSAVE设一个断点。
创建一个interaction record，点‘保存’按钮。
P-1 web save.PNG
断点会停在SAPMSSY0的575行。同样，确保系统DEBUG是设上的。设置断点条件VB_FUNC_NAME = 'CRM_SERVICE_OS_UPD_OST_DU'。然后点F8。
断点就会停在CRM_SERVICE_OS_UPD_OST_DU被调用的地方了。