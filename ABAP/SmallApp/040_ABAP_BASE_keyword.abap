*&---------------------------------------------------------------------*
*& Report ZMOVE_CORRESPONDING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBASE.

DATA:
  BEGIN OF struct1,
    col1 TYPE i VALUE 11,
    col2 TYPE i VALUE 12,
  END OF struct1.

DATA:
  BEGIN OF struct2,
    col2 TYPE i VALUE 22,
    col3 TYPE i VALUE 23,
  END OF struct2.

*This is not the same as
*MOVE-CORRESPONDING struct2 TO struct1.
*Since the RHS does not know anything of the LHS, component col3 of struct2 does not
*keep its former value but is initialized.

" struct2 = CORRESPONDING #( struct1 ).

*Of course, it is a common use case to add new values to existing values. Therefore,
*with Release 740, SP08 there is a new addition BASE for constructor expressions NEW, VALUE
*and CORRESPONDING that allows you to give the expressions a start value.  Very
*often, this means to make the LHS known to a RHS. For the examples shown above,
*  this simply will look as follows:
*
*The result of the expression is initialized with struct2 and then the evaluation takes place.
* Now it works like MOVE-CORRESPONDING, col3 of struct2 keeps its former value.

struct2 = CORRESPONDING #( BASE ( struct2 ) struct1 ).

BREAK-POINT.

DATA itab TYPE TABLE OF i.

itab = VALUE #( ( 1 ) ( 2 ) ( 3 ) ).
itab = VALUE #( BASE itab ( 4 ) ( 5 ) ( 6 ) ).

"You can als construct structures using BASE:

struct2 = VALUE #( BASE struct1  col3 = 33 ).

"First, all components are taken over from struct1, then the columns specified are overwritten.
BREAK-POINT.