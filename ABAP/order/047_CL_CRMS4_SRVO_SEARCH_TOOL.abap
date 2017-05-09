class CL_CRMS4_SRVO_SEARCH_TOOL definition
  public
  final
  create public .

public section.

  class-methods SEARCH
    importing
      !IT_SEARCH_PARAMETERS type GENILT_SELECTION_PARAMETER_TAB
    returning
      value(RT_RESULT_TABLE) type CRMST_QUERY_R_SRVO_BTIL_T .
protected section.
private section.
ENDCLASS.



CLASS CL_CRMS4_SRVO_SEARCH_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_CRMS4_SRVO_SEARCH_TOOL=>SEARCH
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_SEARCH_PARAMETERS           TYPE        GENILT_SELECTION_PARAMETER_TAB
* | [<-()] RT_RESULT_TABLE                TYPE        CRMST_QUERY_R_SRVO_BTIL_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD search.
    DATA: lt_srvo_h   TYPE TABLE OF crms4d_srvo_h,
          lt_id_range TYPE crms4t_product_id_range,
          ls_id_range LIKE LINE OF lt_id_range.
    IF it_search_parameters IS INITIAL.
      SELECT * INTO TABLE lt_srvo_h  FROM crms4d_srvo_h UP TO 100 ROWS.

* Jerry 2017-05-03 10:50 for POC only object_id search is supported
    ELSE.
      LOOP AT it_search_parameters ASSIGNING FIELD-SYMBOL(<id>) WHERE attr_name = 'OBJECT_ID'.
        ls_id_range = CORRESPONDING #( <id> ).
        APPEND ls_id_range TO lt_id_range.
      ENDLOOP.
      SELECT * INTO TABLE lt_srvo_h UP TO 100 ROWS FROM crms4d_srvo_h WHERE object_id IN lt_id_range.
    ENDIF.

    SORT lt_srvo_h BY created_at DESCENDING.
    rt_result_table = CORRESPONDING #( lt_srvo_h ).
    LOOP AT rt_result_table ASSIGNING FIELD-SYMBOL(<srvo>).
      <srvo>-object_key = <srvo>-guid.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.