... REDUCE type(
      INIT result = start_value
           ...
      FOR for_exp1
      FOR for_exp2
      ...
      NEXT ...
           result = iterated_value
           ... ) ...
 
While VALUE and NEW expressions can include FOR expressions, REDUCE must include at 
least one FOR expression. You can use all kinds of FOR expressions in REDUCE:
with IN for iterating internal tables
with UNTIL or WHILE for conditional iterations.

REPORT ZREDUCE.

DATA itab TYPE STANDARD TABLE OF i WITH EMPTY KEY.

" will generate an internal table with value 1 ~ 100
itab = VALUE #( FOR j = 1 WHILE j <= 100 ( j ) ).

DATA(sum) = REDUCE i( INIT x = 0 FOR wa IN itab NEXT x = x + wa ).

CLEAR: itab.

itab = VALUE #( FOR j = 1 THEN j + 10 WHILE j <= 100 ( j ) ).
* 1,11,21,31 ... 91
* First, the table is filled with VALUE and FOR and then it is reduced with REDUCE
* to the sum of its contents. Note that there is no THEN used to construct the table.
* If THEN is not specified explicitly, implicitly THEN j = j + 1 is used. Be also
* aware, that you can place any expression behind THEN, including method calls.
* You only have to make sure that the end condition is reached within maximal
* program run time.

DATA(result) =
  REDUCE string( INIT text = `Count up:`
                 FOR n = 1 UNTIL n > 10
                 NEXT text = text && | { n }| ).

" Count up: 1 2 3 4 5 6 7 8 9 10
BREAK-POINT.

TYPES outref TYPE REF TO if_demo_output.

DATA(output) =
  REDUCE outref( INIT out11  = cl_demo_output=>new( )
                      text = `Count up:`
                 FOR n = 1 UNTIL n > 11
                 NEXT out11 = out11->write( text )
                      "text = |{ n }| ).
                      " text = n ). * can also work
                      text = | 'Jerry' { n } 'end' | ).

output->display( ).

