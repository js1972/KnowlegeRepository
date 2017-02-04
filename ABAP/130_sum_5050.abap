itab = VALUE #( FOR j = 1 WHILE j <= 100 ( j ) ).
* Reduce 后面跟类型
* A constructor expression with the reduction operator 
* REDUCE creates a result of a data type specified using type 
* from one or more iteration expressions.
* At least one variable or one field symbol must be specified. The variables or field symbols declared after 
* INIT can only be used after NEXT. 
* At least one iteration expression must then be specified using FOR and it is also possible to specify multiple 
* consecutive iteration expressions.
DATA(sum) = REDUCE i( INIT x = 0 FOR wa IN itab NEXT x = x + wa ).
WRITE: / sum.