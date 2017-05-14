class ZCL_STATUS_CALC_TOOL definition
  public
  final
  create public .

public section.

  types:
    begin of ty_status_result,
          obtyp TYPE crm_jsto-obtyp,
          stsma TYPE crm_jsto-stsma,
          count TYPE int4,
       END OF ty_status_result .
  types:
    tt_status_result TYPE STANDARD TABLE OF ty_status_result WITH KEY obtyp stsma .

  methods GET_RESULT
    returning
      value(RT_RESULT) type TT_STATUS_RESULT .
  methods ADD_RESULT
    importing
      !IS_RESULT type TY_STATUS_RESULT
    returning
      value(RO_THIS) type ref to ZCL_STATUS_CALC_TOOL .
protected section.
private section.

  data MT_RESULT type TT_STATUS_RESULT .
ENDCLASS.



CLASS ZCL_STATUS_CALC_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_STATUS_CALC_TOOL->ADD_RESULT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_RESULT                      TYPE        TY_STATUS_RESULT
* | [<-()] RO_THIS                        TYPE REF TO ZCL_STATUS_CALC_TOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ADD_RESULT.
     APPEND is_result TO me->mt_result.
     ro_this = me.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_STATUS_CALC_TOOL->GET_RESULT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_RESULT                      TYPE        TT_STATUS_RESULT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_RESULT.
    SORT me->mt_result BY count DESCENDING.
    rt_result = me->mt_result.
  endmethod.
ENDCLASS.