class CL_CRMS4_SRVO_SEARCH_TOOL definition
  public
  final
  create public .

public section.

  class-methods SEARCH_DB
    importing
      !IT_SEARCH_PARAMETERS type GENILT_SELECTION_PARAMETER_TAB
    returning
      value(RT_RESULT_TABLE) type CRMST_QUERY_R_SRVO_BTIL_T .
  class-methods SEARCH_CDS
    importing
      !IT_SEARCH_PARAMETERS type GENILT_SELECTION_PARAMETER_TAB
    returning
      value(RT_RESULT_TABLE) type CRMST_QUERY_R_SRVO_BTIL_T .
protected section.
private section.
ENDCLASS.



CLASS CL_CRMS4_SRVO_SEARCH_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_CRMS4_SRVO_SEARCH_TOOL=>SEARCH_CDS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_SEARCH_PARAMETERS           TYPE        GENILT_SELECTION_PARAMETER_TAB
* | [<-()] RT_RESULT_TABLE                TYPE        CRMST_QUERY_R_SRVO_BTIL_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD SEARCH_CDS.
    DATA: lt_object_id_range TYPE crms4t_product_id_range,
          lt_product_id_range TYPE crms4t_product_id_range,
          ls_range LIKE LINE OF lt_object_id_range,
          lt_item TYPE TABLE OF CRMS4V_SALE_I,
          lv_where TYPE string,
          lv_segment TYPE STRING.
    IF it_search_parameters IS INITIAL.
      SELECT * INTO TABLE @lt_item  FROM CRMS4V_SALE_I UP TO 100 ROWS.

    ELSE.
      LOOP AT it_search_parameters ASSIGNING FIELD-SYMBOL(<para>).
        ls_range = CORRESPONDING #( <para> ).
        CASE <para>-attr_name.
          WHEN 'OBJECT_ID'.
           lv_segment = |object_id in @lt_object_id_range|.
           APPEND ls_range TO lt_object_id_range.
          WHEN 'PRODUCT_ID'.
            lv_segment = |product_id in @lt_product_id_range|.
            APPEND ls_range TO lt_product_id_range.
          WHEN OTHERS.
            CONTINUE.
        ENDCASE.

        IF lv_where IS INITIAL.
           lv_where = lv_segment.
        ELSE.
           lv_where = lv_where && ` AND ` && lv_segment.
        ENDIF.
      ENDLOOP.
      SELECT * INTO TABLE @lt_item UP TO 100 ROWS FROM CRMS4V_SALE_I WHERE (lv_where).
    ENDIF.

    rt_result_table = CORRESPONDING #( lt_item ).
    LOOP AT rt_result_table ASSIGNING FIELD-SYMBOL(<srvo>).
      <srvo>-object_key = <srvo>-guid.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_CRMS4_SRVO_SEARCH_TOOL=>SEARCH_DB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_SEARCH_PARAMETERS           TYPE        GENILT_SELECTION_PARAMETER_TAB
* | [<-()] RT_RESULT_TABLE                TYPE        CRMST_QUERY_R_SRVO_BTIL_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD SEARCH_DB.
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