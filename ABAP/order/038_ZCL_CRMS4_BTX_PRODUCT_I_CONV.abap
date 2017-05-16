class CL_CRMS4_BT_PRODUCT_I_CONV definition
  public
  final
  create public .

public section.

  interfaces IF_CRMS4_BTX_DATA_MODEL_conv .
protected section.
private section.
ENDCLASS.



CLASS CL_CRMS4_BT_PRODUCT_I_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRODUCT_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND
* | [<-->] CS_WORKAREA                    TYPE        ANY(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~convert_1o_to_s4.

    DATA: lt_buffer TYPE crmt_product_i_wrkt,
          lt_guid   TYPE crmt_object_guid_tab.
* Jerry 2017-05-09 5:46PM for PRODUCT_I, deletion does not make sense -
* if you set unit from EA to space, this is an update operation!

    DATA(tool) = cl_crms4_bt_data_model_tool=>get_instance( ).

    IF tool->mv_current_item_mode = 'D'.
       RETURN.
    ENDIF.

    APPEND iv_ref_guid TO lt_guid.
    CALL FUNCTION 'CRM_PRODUCT_I_GET_MULTI_OB'
      EXPORTING
        it_guids_to_get  = lt_guid
      IMPORTING
        et_object_buffer = lt_buffer.
    READ TABLE lt_buffer ASSIGNING FIELD-SYMBOL(<buffer>) INDEX 1.
    ASSERT sy-subrc = 0.

    cl_crms4_bt_data_model_tool=>merge_uninitial_fields(
       EXPORTING is_segment = <buffer>
       CHANGING  cs_current = cs_workarea ).
* See: https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/42
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRODUCT_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_conv~CONVERT_S4_TO_1O.
    "MOVE-CORRESPONDING is_workarea to es_workarea.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_PRODUCT_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_OB
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~get_ob.
    DATA: lt_buffer TYPE crmt_product_i_wrkt,
          lt_guid   TYPE crmt_object_guid_tab.

    APPEND iv_guid TO lt_guid.
    CALL FUNCTION 'CRM_PRODUCT_I_GET_MULTI_OB'
      EXPORTING
        it_guids_to_get  = lt_guid
      IMPORTING
        et_object_buffer = lt_buffer.
    READ TABLE lt_buffer ASSIGNING FIELD-SYMBOL(<buffer>) INDEX 1.
    IF sy-subrc = 0.
      es_data = <buffer>.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRODUCT_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_conv~GET_WRK_STRUCTURE_NAME.
    rv_wrk_structure_name = 'CRMT_PRODUCT_I_WRK'.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRODUCT_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID(optional)
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD IF_CRMS4_BTX_DATA_MODEL_conv~put_to_db_buffer.
    DATA: lt_product_i_db_buffer TYPE crmt_product_i_du_tab,
          ls_db_buffer LIKE LINE OF lt_product_i_db_buffer.

    ls_db_buffer = CORRESPONDING #( is_wrk_structure ).
    APPEND ls_db_buffer TO lt_product_i_db_buffer.

    CALL FUNCTION 'CRM_PRODUCT_I_PUT_DB'
      EXPORTING
        it_product_i_db = lt_product_i_db_buffer.
  ENDMETHOD.
ENDCLASS.