* this report is written on 2014年02月24日 14:14, tested in AG3/001 on 2017-05-23 11:39AM in 
* Wiesloch, it works quite well.
REPORT zweb.

DATA: lo     TYPE REF TO zzco_prod_ws,
      input  TYPE zzcrmost__pro001prodadvsea01,
      output TYPE zzcrmost__pro001prodadvsea00.

CREATE OBJECT lo
  EXPORTING
    logical_port_name = 'LP_TEST1'.

input-input-searchforproducts-created_by-sign = 'I'.
input-input-searchforproducts-created_by-option = 'EQ'.
input-input-searchforproducts-created_by-low = 'WANGJER'.
TRY.
    lo->crmost__pro001prodadvsea001d(
      EXPORTING
        input                   = input
      IMPORTING
        output                  =  output ).

  CATCH cx_root INTO DATA(lv_text).
    DATA(ls) = lv_text->get_text( ).
    WRITE:/ ls.
ENDTRY.

DATA: ls_read_input  TYPE zzcrmost__prod_ws_read,
      ls_read_result TYPE zzcrmost__prod_ws_read_respo.
TRY.
    ls_read_input-input-prod_ws-product_id = 'ARNO_TEST004'.
    lo->crmost__prod_ws_read(
       EXPORTING
          input  = ls_read_input
       IMPORTING
          output = ls_read_result ).

  CATCH cx_root INTO lv_text.
    ls = lv_text->get_text( ).
    WRITE:/ ls.
ENDTRY.
BREAK-POINT.