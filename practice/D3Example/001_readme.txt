http://blog.csdn.net/ise_gaoyue1990/article/details/24431725
比例尺
比例尺基本内容
比例尺是一组把输入域映射为输出范围的函数。任意数据集中的值不可能恰好与图表中的像素尺度一一对应。比例尺就是把这些数据值映射为可视化图形中使用的新值的便捷手段。D3的比例尺就是那些你定义的带有参数的函数。定义好之后，就可以调用这些比例尺函数，传入值，它们就能返回按比例生成的输出值。
比例尺的输入值域（input domain）指可能的输入值的范围。
比例尺的输出范围（output range）指输出值可能的范围，一般以用于显示的像素为 单位。
其实比例尺就是归一化的概念。
D3有一个比例尺函数生成器，通过d3.scale来访问。要生成一个比例尺，在d3.scale后面加上要创建的比例尺类型即可。
[javascript] view plaincopy在CODE上查看代码片派生到我的代码片
var scale = d3.scale.linear();  
设置比例尺的值域需要调用domain()方法，并将值域以数组形式传给它。假设值域是100到500，那么就可以这样写代码： 
[javascript] view plaincopy在CODE上查看代码片派生到我的代码片
scale.domain([100, 500]);     
设定输出范围的方式类似，但要调用range()方法：
[javascript] view plaincopy在CODE上查看代码片派生到我的代码片
scale.range([10, 350]);  
如果不想给值域设置固定的值，那可以使用两个方便的数组函数：d3.min()和 d3.max()，让它们帮你动态分析数据集。
[javascript] view plaincopy在CODE上查看代码片派生到我的代码片
vardataset = [  
[5, 20], [480, 90], [250, 50], [100, 33], [330, 95],  
[410, 12], [475, 44], [25, 67], [85, 21], [220, 88]  
];  
d3.max(dataset, function(d) {  
return d[0];  
});  
这个存取器函数是一个匿名函数，max()会把数组中的每个元素（即这里的d）交给它。存取器函数的目的是指定比较哪个值。对我们的数据集而言，需要比较x值， 也就是嵌套数组的第一个值，位置为0。把我们刚刚介绍的知识综合起来，就可以创建一个动态映射x轴值的比例尺函数：
[javascript] view plaincopy在CODE上查看代码片派生到我的代码片
varxScale = d3.scale.linear()  
.domain([0, d3.max(dataset, function(d) { return d[0]; })]) .range([0, 300]);  
其它比例尺
除了线性（linear）比例尺，D3还内置了另外几个比例尺方法。
sqrt 
平方根比例尺。
pow 
幂比例尺，适合值以指数级变化的数据集。
log 
对数比例尺。
quantize 
输出范围为独立的值的线性比例尺，适合想把数据分类的情形。
quantile 
与quantize类似，但输入值域是独立的值，适合已经对数据分类的情形。
ordinal 
使用非定量值（如类名）作为输出的序数比例尺，非常适合比较苹果和桔子。
d3.scale.category10()  、d3.scale.category20()、d3.scale.category20b()和d3.scale.category20c()
能够输出10到20种类别颜色的预设序数比例尺，非常方便。
d3.time.scale() 
针对日期和时间值的一个比例尺方法，可以对日期刻度作特殊处理。 领略了比例尺的威力之后，该通过一些东西来表达它们了，通过什么呢？对， 数轴！

数轴
设定数轴
与比例尺相似，D3的数轴实际上也是由你来定义参数的函数。但与比例尺不同的是，调用数轴函数并不会返回值，而是会生成数轴相关的可见元素，包括轴线、标签和刻度。
使用d3.svg.axis()可以创建通用的数轴函数：
var xAxis = d3.svg.axis();
要使用数轴，最起码要告诉它基于什么比例尺工作。在此，我们把绘制散点图时定义的xScale传给它： 
xAxis.scale(xScale);
还可以继续设置标签相对数轴显示在什么地方。默认位置是底部，也就是标签会出现在轴线下方。水平数轴的位置可 以在顶部也可以在底部。而垂直数轴则要么在左要么在右： 
xAxis.orient("bottom");
把这些方法连缀在一行会更简洁：
[javascript] view plaincopy在CODE上查看代码片派生到我的代码片
var xAxis = d3.svg.axis()  
.scale(xScale)  
.orient("bottom");  
SVG中的其他元素都生成之后再生成数轴，这样数轴就可以出现在“上面了。想要生成数轴还要调用xAxis函数将其插入到svg元素中。
[javascript] view plaincopy在CODE上查看代码片派生到我的代码片
svg.append("g")  
.call(xAxis);  
 前面的代码首先引用了svg，即DOM中的SVG元素。然后，append()在 这个元素的末尾追加了一个新的g元素。在SVG标签内，g元素就是一个分组（group）元素。分组元素是不可见的，跟line、rect和circle不一样，但它有两大用途：一是可以用来包含（或“组织”）其他元素，好让代码看起来简洁整齐；二是可以对整个分组应用变换，从而影响到该组中所有元素（line、rect和 circle）的视觉表现。D3的call()函数会取得（比如刚才代码链中）传递过来的元素，然后再把它交给其他函数。对我们这例子而言，传递过来的元素就是新的分组元素g（虽然这个元素不是必需的，但鉴于数轴函数需要生成很多线条和数值，有了它就可以把所有元素都封装在一个分组对象内）。而call()接着把g交给了xAxis函数，也就是要 在g元素里面生成数轴。
就该用到SVG变换（transform）了。只要添加一行代码，就可以把整个数轴分组平移到图表下方： 
[javascript] view plaincopy在CODE上查看代码片派生到我的代码片
svg.append("g") .attr("class", "axis")   
.attr("transform", "translate(0," + (h - padding) + ")") .call(xAxis);   
新增的这行代码在attr()中设置了g元素的属性transform。SVG中的变换功 能非常强大，有多种不同的变换方式，包括缩放和旋转。但我们暂时只介绍平移 （translation）变换，它可以把整个g分组向下移动一定距离。平移变换的语法很简单，就是translate(x,y)，其中x和y的含义都非常明确， 就是要把元素移动到的新位置的x和y坐标。
优化刻度
数轴的刻度线（tick）是用来传达信息的，但也不是越多越好，多过某个数量，刻度线反而会让图表显得混乱。使用ticks()方法就可以粗略地指定刻 度线的数量： 
[javascript] view plaincopy在CODE上查看代码片派生到我的代码片
varxAxis = d3.svg.axis()  
.scale(xScale)  
.orient("bottom")  
.ticks(5); //粗略地设置刻度线的数量  