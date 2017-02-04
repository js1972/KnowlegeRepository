 /*许多的 JS 框架类库都选择使用 $ 符号作为函数或变量名，jQuery 是其中最为典型的一个。在 jQuery 中，$ 符号只是 window.jQuery 对象的一个引用，因此即使 $ 被删除，window.jQuery 依然是保证整个类库完整性的坚强后盾。jQuery 的 API 设计充分考虑了多框架之间的引用冲突，我们可以使用 jQuery.noConflict 方法来轻松实现控制权的移交。
   jQuery.noConflict 方法包含一个可选的布尔参数[1]，用以决定移交 $ 引用的同时是否移交 jQuery 对象本身：
jQuery.noConflict([removeAll])
   缺省情况下，执行 noConflict 会将变量 $ 的控制权移交给第一个产生 $ 的库；当 removeAll 设置为 true 时，执行 noConflict 则会将 $ 和 jQuery 对象本身的控制权全部移交给第一个产生他们的库。
   例如在 KISSY 和 jQuery 混用，并且惯用 $ = KISSY 来简化 API 操作的时候，就能够通过这个方法解决命名冲突的问题。
   那么这个机制是如何实现的呢？阅读 jQuery 源码开头[2]，首先做的一件事情是这样的：*/
        // Map over jQuery in case of overwrite
        _jQuery = window.jQuery,

        // Map over the $ in case of overwrite
        _$ = window.$,
   //容易理解的是，jQuery 通过两个私有变量映射了 window 环境下的 jQuery 和 $ 两个对象，以防止变量被强行覆盖。一旦 noConflict 方法被调用，则通过 _jQuery, _$, jQuery, $ 四者之间的差异，来决定控制权的移交方式，具体的代码如下：
noConflict: function( deep ) {
                if ( window.$ === jQuery ) {
                        window.$ = _$;
                }

                if ( deep && window.jQuery === jQuery ) {
                        window.jQuery = _jQuery;
                }

                return jQuery;
        }
   /*再来看上面所说的参数设定问题，如果 deep 没有设置，_$ 覆盖 window.$，此时 jQuery 别名 $ 失效，但 jQuery 本身完好无损。如果有其他类库或代码重新定义了 $ 变量，它的控制权就完全交接出去了。反之如果 deep 设置为 true 的话，_jQuery 覆盖 window.jQuery，此时 $ 和 jQuery 都将失效。
   这种操作的好处是，不管是框架混用还是 jQuery 多版本共存这种高度冲突的执行环境，由于 noConflict 方法提供的移交机制，以及本身返回未被覆盖的 jQuery 对象，完全能够通过变量映射的方式解决冲突。
   但无法避免的事实是可能导致的插件失效等问题，当然通过简单修改上下文参数即可恢复 $ 别名：*/
var query = jQuery.noConflict(true);
(function ($) {

     // 插件或其他形式的代码，也可以将参数设为 jQuery

})(query);
