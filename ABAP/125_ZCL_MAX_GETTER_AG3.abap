class ZCL_MAX_GETTER definition
  public
  final
  create public .

public section.

  types:
    TT_INT type STANDARD TABLE OF int4 .

  methods GET_MAX
    importing
      !IT_TAB type TT_INT
    returning
      value(RV_RESULT) type INT4 .
  methods TEST .
protected section.
private section.

  methods MAX
    importing
      !IV_1 type INT4
      !IV_2 type INT4
    returning
      value(RV_RESULT) type INT4 .
ENDCLASS.



CLASS ZCL_MAX_GETTER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAX_GETTER->GET_MAX
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TAB                         TYPE        TT_INT
* | [<-()] RV_RESULT                      TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_MAX.
    DATA(lv_size) = lines( it_tab ).
    CASE lv_size.
       WHEN 0.
         rv_result = 0.
       WHEN 1.
         READ TABLE it_Tab ASSIGNING FIELD-SYMBOL(<max>) INDEX 1.
         rv_result = <max>.
       WHEN OTHERS.
         READ TABLE it_Tab ASSIGNING FIELD-SYMBOL(<max2>) INDEX 1.
         data(lt_temp) = it_Tab.
         DELETE lt_temp INDEX 1.
         rv_result = max( iv_1 = <max2> iv_2 = get_max( lt_temp ) ).
    ENDCASE.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAX_GETTER->MAX
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_1                           TYPE        INT4
* | [--->] IV_2                           TYPE        INT4
* | [<-()] RV_RESULT                      TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method MAX.

    if iv_1 >= iv_2.
       rv_result = iv_1.
    ELSE.
       rv_result = iv_2.
    ENDIF.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAX_GETTER->TEST
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method TEST.
    data: lt_test type tt_int.

    APPEND 1 to lt_test.
    APPEND 2 TO lt_test.
    APPEND 5 to lt_test.
    APPEND 3 to lt_test.
    APPEND 10 TO lt_test.

    data(lv_result) = GET_MAX( lt_test ).
  endmethod.
ENDCLASS.
