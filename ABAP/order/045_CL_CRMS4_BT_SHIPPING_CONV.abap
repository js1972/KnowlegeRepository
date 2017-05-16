class CL_CRMS4_BT_SHIPPING_CONV definition
  public
  final
  create public .

public section.

  interfaces IF_CRMS4_BTX_DATA_MODEL_CONV .
protected section.
private section.
ENDCLASS.



CLASS CL_CRMS4_BT_SHIPPING_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_SHIPPING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND
* | [<-->] CS_WORKAREA                    TYPE        ANY(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~convert_1o_to_s4.
    DATA: ls_shipping TYPE crmt_shipping_wrk.

    DATA(lo_tool) = cl_crms4_bt_data_model_tool=>get_instance( ).
* Jerry 2017-05-08 7:07PM - always header guid passed into this method
* Jerry 2017-05-10 8:33PM - if item is in deletion mode, do nothing since item deletion
* is triggered by ORDERADM_I convert class

    IF iv_ref_kind = 'B' and lo_tool->mv_current_item_mode = 'D'.
       RETURN.
    ENDIF.

    CALL FUNCTION 'CRM_SHIPPING_READ_OB'
      EXPORTING
        iv_ref_guid     = iv_ref_guid
        iv_ref_kind     = iv_ref_kind
      IMPORTING
        es_shipping_wrk = ls_shipping.

    IF ls_shipping IS INITIAL.
       RETURN.
    ENDIF.
    ls_shipping-guid = iv_ref_guid.
    cl_crms4_bt_data_model_tool=>merge_uninitial_fields(
       EXPORTING is_segment = ls_shipping
       CHANGING  cs_current = cs_workarea ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_SHIPPING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O.
    "MOVE-CORRESPONDING IS_WORKAREA TO ES_WORKAREA.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_SHIPPING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_OB
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~get_ob.
    DATA: lt_guid   TYPE crmt_object_guid_tab,
          lt_buffer TYPE crmt_shipping_wrkt.

    APPEND iv_guid TO lt_guid.

    CALL FUNCTION 'CRM_SHIPPING_GET_MULTI_OB'
      EXPORTING
        it_guids_to_get  = lt_guid
      IMPORTING
        et_object_buffer = lt_buffer.

    READ TABLE lt_buffer ASSIGNING FIELD-SYMBOL(<buffer>) INDEX 1.
    CHECK sy-subrc = 0.

    MOVE-CORRESPONDING <buffer> TO es_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_SHIPPING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME.
    rv_wrk_structure_name = 'CRMT_SHIPPING_WRK'.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_SHIPPING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID(optional)
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~put_to_db_buffer.
    DATA: lt_db       TYPE crmt_shipping_du_tab,
          ls_db       LIKE LINE OF lt_db,
          lt_link_com TYPE crmt_link_comt,
          lv_hi_name  TYPE crmt_object_name,
          ls_link_com LIKE LINE OF lt_link_com.

    MOVE-CORRESPONDING is_wrk_structure TO ls_db.
    APPEND ls_db TO lt_db.

    CALL FUNCTION 'CRM_SHIPPING_PUT_DB'
      EXPORTING
        it_shipping_db = lt_db.

    CLEAR ls_link_com.
    CLEAR lt_link_com.
    ls_link_com-guid_hi     = ls_db-guid.
    ls_link_com-guid_set    = ls_db-guid.
    ls_link_com-objname_set = 'SHIPPING'.
    ls_link_com-objtype_set = '12'.
    IF iv_ref_kind = 'A'.
      ls_link_com-objname_hi  = lv_hi_name = 'ORDERADM_H'.
      ls_link_com-objtype_hi  = '05'.
    ELSE.
      ls_link_com-objname_hi  = lv_hi_name = 'ORDERADM_I'.
      ls_link_com-objtype_hi  = '06'.
    ENDIF.
    INSERT ls_link_com INTO TABLE lt_link_com.
    CALL FUNCTION 'CRM_LINK_CREATE_OW'
      EXPORTING
        iv_guid_hi    = ls_db-guid
        iv_objname_hi = lv_hi_name
        it_link       = lt_link_com
      EXCEPTIONS
        OTHERS        = 0.

  ENDMETHOD.
ENDCLASS.