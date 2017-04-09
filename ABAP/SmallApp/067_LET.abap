*&---------------------------------------------------------------------*
*& Report ZLET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLET.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
* another example
typeS: BEGIN OF ty_data,
                 index type int4,
                 value type int4,
                 name type string,
           end of ty_Data.
data: lt_data TYPE STANDARD TABLE OF ty_data.

LOOP AT itab ASSIGNING FIELD-SYMBOL(<fs>).
  data(value) = value ty_Data( LET x = <fs> y = x + 1  r = r && x && y in index = sy-index value = x + y  name = r ).
  APPEND value TO lt_data.
ENDLOOP.  

    TYPES text TYPE STANDARD TABLE OF string WITH EMPTY KEY.
* IN后面的才是重点，能产生输出的语句。
    cl_demo_output=>new( )->write(
     VALUE text( LET it = `Jerry` IN
                   ( |To { it } is to do|          )
                   ( |To { it }, or not to { it }| )
                   ( |To do is to { it }|          )
                   ( |Do { it } do { it } do|      ) )
    )->display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).
