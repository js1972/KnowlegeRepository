class ZCL_CURRY definition
  public
  final
  create public .

public section.

  class-methods CURRY .
protected section.
private section.
 TYPES: begin of ty_curried_argument,
           arg_name TYPE string,
           arg_value TYPE string,
       END OF ty_curried_argument.

 TYPES: tt_curried_argument TYPE TABLE OF ty_curried_argument WITH KEY arg_name.

  TYPES: BEGIN OF ty_curried_func,
           func_name TYPE RS38L_FNAM,
           curried_func TYPE RS38L_FNAM,
           curried_arg TYPE tt_curried_argument,
        END OF ty_curried_func.

  types: tt_curried_func TYPE TABLE OF ty_curried_func WITH KEY func_name curried_func.

   data: mt_curried_func TYPE tt_curried_func,
         mv_org_func TYPE RS38L_FNAM.
ENDCLASS.



CLASS ZCL_CURRY IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CURRY=>CURRY
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CURRY.
  endmethod.
ENDCLASS.