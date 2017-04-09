*&---------------------------------------------------------------------*
*& Report ZCAST1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCAST1.



CLASS c1 DEFINITION.
ENDCLASS.
CLASS c2 DEFINITION INHERITING FROM c1.
ENDCLASS.

DATA: oref1 TYPE REF TO c1,
      oref2 TYPE REF TO c2,
      OREF3 type ref to OBJECT,
      OREF4 type ref to c1.

CREATE OBJECT oref1 type C2.
creATE OBJECT OREF2.
TRY.
* Jerry: 这里的oref1的静态类型是C1，但是dynamic type是C2， is instance of 检查的是oref1的动态类型C2是否等于或者比C2更specific
IF oref1 IS INSTANCE OF c2.
* 向下转型成为强制类型转换 其意思是从父类转为子类 转了后你可以拥有更多的方法 因为子类通常有比父类更多的方法
*向上转型称为抽象
给你举个例子
比如说一个工程 最后的main方法里面调用了其他地方的一个方法 该方法有一个参数 
我假设方法的括号里为Person person 现在你要去调这个方法 你往里面传中国人 美国人 日本人 
该方法都能跑起来 并且会通过多态调用不同的子类实现方法 但你如果不这样做 假设你把参数定为英国人 
那你如果往里面传中国人 这个方法就跑不起来了 你就要去改代码 反之 你就不用改动任何代码
  oref2 ?= oref1.
  oref2 =  CAST #( oref1 ).
  OREF3 = cast c2( oref1 ).
  oref3 = cast c1( oref1 ).
  oref4 = cast c1( oref1 ).
ENDIF.
CATCH cx_root INTO DATA(cx_root).
   WRITE: / cx_root->get_text( ).
ENDTRY.
WRITE:/ 'OK'.