class ZCL_SORT_HELPER definition
  public
  final
  create public .

public section.

  class-methods PRINT
    importing
      !IV_TABLE type ABADR_TAB_INT4 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SORT_HELPER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_SORT_HELPER=>PRINT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TABLE                       TYPE        ABADR_TAB_INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method PRINT.
    DATA: lv_print TYPE string.
    LOOP AT iv_table ASSIGNING FIELD-SYMBOL(<element>).
      IF sy-tabix = 1.
         lv_print = <element>.
      ELSE.
         lv_print = lv_print && ',' && <element>.
      ENDIF.
    ENDLOOP.

    WRITE: / lv_print COLOR COL_NEGATIVE.
  endmethod.
ENDCLASS.