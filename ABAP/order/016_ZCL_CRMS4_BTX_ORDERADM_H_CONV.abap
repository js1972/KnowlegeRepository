CLASS cl_crms4_bt_orderadm_h_conv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_crms4_btx_data_model_CONV .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_CRMS4_BT_ORDERADM_H_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND
* | [--->] IV_CURRENT_GUID                TYPE        CRMT_OBJECT_GUID
* | [<-->] CT_TO_INSERT                   TYPE        ANY TABLE
* | [<-->] CT_TO_UPDATE                   TYPE        ANY TABLE
* | [<-->] CT_TO_DELETE                   TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~convert_1o_to_s4.
    DATA: lt_insert  TYPE crmt_orderadm_h_du_tab,
          lt_update  TYPE crmt_orderadm_h_du_tab,
          lt_delete  TYPE crmt_orderadm_h_du_tab,
          lt_to_save TYPE crmt_object_guid_tab.

    CHECK iv_ref_kind = 'A'.
    APPEND iv_ref_guid TO lt_to_save.
* Jerry 2017-05-02 8:40PM - in order to generate changed timestamp

    CALL FUNCTION 'CRM_ORDERADM_H_SAVE_OB'
      EXPORTING
        it_orderadm_h_to_save       = lt_to_save
      EXCEPTIONS
        saving_admin_headers_error  = 1
        admin_header_does_not_exist = 2
        OTHERS                      = 3.
    IF sy-subrc <> 0.
    ENDIF.

    CALL FUNCTION 'CRM_ORDER_UPDATE_TABLES_DETERM'
      EXPORTING
        iv_object_name       = 'ORDERADM_H'
        iv_field_name_key    = 'GUID'
        it_guids_to_process  = lt_to_save
        iv_header_to_save    = iv_ref_guid
      IMPORTING
        et_records_to_insert = lt_insert
        et_records_to_update = lt_update
        et_records_to_delete = lt_delete.

    DATA(tool) = cl_crms4_bt_data_model_tool=>get_instance( ).

    CALL METHOD tool->merge_change_2_global_buffer
      EXPORTING
        it_current_insert = lt_insert
        it_current_update = lt_update
        it_current_delete = lt_delete
      CHANGING
        ct_global_insert  = ct_to_insert
        ct_global_update  = ct_to_update
        ct_global_delete  = ct_to_delete.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY(optional)
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_CONV~convert_s4_to_1o.

* for ORDERADM_H move corresponding is enough
    MOVE-CORRESPONDING is_workarea TO es_workarea.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_OB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GUID                        TYPE        CRMT_OBJECT_GUID
* | [<---] ES_DATA                        TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_CONV~GET_OB.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_CONV~get_wrk_structure_name.
    rv_wrk_structure_name = 'CRMT_ORDERADM_H_WRK'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID(optional)
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_CONV~put_to_db_buffer.

    DATA: lt_orderadm_h_db TYPE crmt_orderadm_h_du_tab.

    APPEND is_wrk_structure TO lt_orderadm_h_db.

    CALL FUNCTION 'CRM_ORDERADM_H_PUT_DB'
      EXPORTING
        it_orderadm_h_db = lt_orderadm_h_db.
  ENDMETHOD.
ENDCLASS.