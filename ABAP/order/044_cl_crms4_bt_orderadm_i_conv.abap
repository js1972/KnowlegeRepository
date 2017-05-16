CLASS cl_crms4_bt_orderadm_i_conv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_crms4_btx_data_model_conv .
  PROTECTED SECTION.
private section.

  methods POPULATE_CHANGED_TIMESTAMP
    changing
      !CS_ITEM type CRMT_ORDERADM_I_WRK .
ENDCLASS.



CLASS CL_CRMS4_BT_ORDERADM_I_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND
* | [<-->] CS_WORKAREA                    TYPE        ANY(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~convert_1o_to_s4.
    DATA: lt_item_guid TYPE crmt_object_guid_tab,
          lv_mode      TYPE crmt_mode,
          lt_item_db   TYPE crmt_orderadm_i_db_wrkt,
          ls_item_ob   TYPE crmt_orderadm_i_wrk.

    CALL FUNCTION 'CRM_ORDERADM_I_READ_OB'
      EXPORTING
        iv_guid                  = iv_ref_guid
        iv_include_deleted_items = 'X'
      IMPORTING
        es_orderadm_i_wrk        = ls_item_ob.

    populate_changed_timestamp( CHANGING cs_item = ls_item_ob ).

* Jerry 2017-05-12 6:54PM - below logic may also be moved outside this convert class
    DATA(tool) = cl_crms4_bt_data_model_tool=>get_instance( ).
    lv_mode = tool->mv_current_item_mode.
* Jerry 2017-05-09 6:34PM - framework cannot differentiate between A and B
* since as long as an item will be changed, it will publish event, and the mode will then
* be changed to B, so we have to identify this manually.
    IF lv_mode <> 'D'.
      APPEND iv_ref_guid TO lt_item_guid.
      CALL FUNCTION 'CRM_ORDERADM_I_GET_MULTI_DB'
        EXPORTING
          it_guids_to_get    = lt_item_guid
        IMPORTING
          et_database_buffer = lt_item_db.

      READ TABLE lt_item_db ASSIGNING FIELD-SYMBOL(<item_db>) INDEX 1.
      ASSERT sy-subrc = 0.
      IF <item_db>-norec_flag = 'X'.
        lv_mode = 'A'.
      ELSE.
        lv_mode = 'B'.
      ENDIF.
      tool->set_current_item_mode( lv_mode ).
    ENDIF.
    cs_workarea = CORRESPONDING #( ls_item_ob ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~convert_s4_to_1o.

* for ORDERADM_H move corresponding is enough
    MOVE-CORRESPONDING is_workarea TO es_workarea.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~get_wrk_structure_name.
    rv_wrk_structure_name = 'CRMT_ORDERADM_I_WRK'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID(optional)
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~put_to_db_buffer.
    DATA: lt_orderadm_i_db_buffer TYPE crmt_orderadm_i_du_tab,
          ls_db_buffer LIKE LINE OF lt_orderadm_i_db_buffer.

    ls_db_buffer = CORRESPONDING #( is_wrk_structure ).
    APPEND ls_db_buffer TO lt_orderadm_i_db_buffer.

    CALL FUNCTION 'CRM_ORDERADM_I_PUT_DB'
      EXPORTING
        it_orderadm_i_db = lt_orderadm_i_db_buffer.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_ORDERADM_I_CONV->POPULATE_CHANGED_TIMESTAMP
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CS_ITEM                        TYPE        CRMT_ORDERADM_I_WRK
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD populate_changed_timestamp.
    DATA: ls_orderadm_h_wrk TYPE crmt_orderadm_h_wrk.

    CALL FUNCTION 'CRM_ORDERADM_H_READ_OW'
      EXPORTING
        iv_orderadm_h_guid = cs_item-header
      IMPORTING
        es_orderadm_h_wrk  = ls_orderadm_h_wrk
      EXCEPTIONS
        OTHERS             = 2.

    CALL FUNCTION 'CRM_ORDER_GET_TIMESTAMP'
      EXPORTING
        iv_guid      = cs_item-header
      IMPORTING
        ev_timestamp = cs_item-changed_at.

    cs_item-changed_by = ls_orderadm_h_wrk-changed_by.

    IF cs_item-created_at IS INITIAL.
      cs_item-created_at = cs_item-changed_at.
    ENDIF.

    IF cs_item-created_by IS INITIAL.
      cs_item-created_by = cs_item-changed_by.
    ENDIF.

    IF cs_item-order_date IS INITIAL.
      cs_item-order_date = cs_item-created_at.
    ENDIF.

  ENDMETHOD.
ENDCLASS.