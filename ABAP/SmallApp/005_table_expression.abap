*&---------------------------------------------------------------------*
*& Report ZTABLE_EXPRESSION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTABLE_EXPRESSION.

*Table expressions itab[ ...] cannot support sy-subrc. Up to now,
* an exception was raised anytime if a table line specified in the
*square brackets could not be found. Not everybody liked this
*behavior.
*
*As a workaround, you can place a table expression inside a VALUE
*or REF expression, that contains a OPTIONAL or DEFAULT addition.
*If a line is not found, the OPTIONAL addition returns an initiial
*line while the DEFAULT addition returns a given value, that can be
* specified as an expression, especially another table expression.

TYPES:
  BEGIN OF line,
    id    TYPE i,
    value TYPE string,
  END OF line,
  itab TYPE SORTED TABLE OF line WITH UNIQUE KEY id.

DATA(def) = VALUE line( id = 0 value = `not found` ).

DATA: lt TYPE itab.

TRY.
   WRITE: / lt[ id = 1 ]-id.
CATCH cx_root INTO data(cx_root).
   DATA(lv_error) = cx_root->get_text( ).
   WRITE: / lv_error.
ENDTRY.



DATA(result) = VALUE #( lt[ id = 3 ] DEFAULT def ).

WRITE: / 'result: ' , result-value.