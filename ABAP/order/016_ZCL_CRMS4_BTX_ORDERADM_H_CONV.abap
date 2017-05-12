CLASS cl_crms4_bt_orderadm_h_conv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_crms4_btx_data_model_conv .

    CLASS-METHODS get_changed_at
      IMPORTING
        !iv_guid             TYPE crmt_object_guid
      RETURNING
        VALUE(rv_changed_at) TYPE comt_changed_at_usr .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_CRMS4_BT_ORDERADM_H_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_CRMS4_BT_ORDERADM_H_CONV=>GET_CHANGED_AT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GUID                        TYPE        CRMT_OBJECT_GUID
* | [<-()] RV_CHANGED_AT                  TYPE        COMT_CHANGED_AT_USR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_changed_at.
    DATA: lv_object_type TYPE crmt_subobject_category_db,
          lv_acronym     TYPE char4,
          lv_db_name     TYPE string.

    SELECT SINGLE object_type INTO lv_object_type FROM crms4d_btx
       WHERE order_guid = iv_guid.
    ASSERT sy-subrc = 0.

    SELECT SINGLE acronym INTO lv_acronym FROM crmc_subob_cat WHERE subobj_category = lv_object_type.

    ASSERT sy-subrc = 0.

    lv_db_name = 'CRMS4D_' && lv_acronym && '_H'.

    SELECT SINGLE changed_at FROM (lv_db_name) INTO rv_changed_at
       WHERE guid = iv_guid.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND
* | [<-->] CT_TO_INSERT                   TYPE        ANY TABLE
* | [<-->] CT_TO_UPDATE                   TYPE        ANY TABLE
* | [<-->] CT_TO_DELETE                   TYPE        ANY TABLE
* | [<-->] CS_WORKAREA                    TYPE        ANY(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~convert_1o_to_s4.
    DATA: lt_ob      TYPE crmt_orderadm_h_wrkt,
          ls_line    TYPE crmd_orderadm_h,
*          lt_insert  TYPE crmt_orderadm_h_du_tab,
*          lt_update  TYPE crmt_orderadm_h_du_tab,
*          lt_delete  TYPE crmt_orderadm_h_du_tab,
          lt_to_save TYPE crmt_object_guid_tab.

    APPEND iv_ref_guid TO lt_to_save.
* Jerry 2017-05-02 8:40PM - in order to generate changed timestamp
* In the productive implementation, we should extract the corresponding codes within this FM
* below and put them to a new FM and call that FM instead.
* Jerry 2017-05-12 12:00PM - there are some calculation logic inside this SAVE_OB
* so I just reuse it in POC - the update function module call in this SAVE_OB
* has already been disabled by Jerry
    CALL FUNCTION 'CRM_ORDERADM_H_SAVE_OB'
      EXPORTING
        it_orderadm_h_to_save       = lt_to_save
      EXCEPTIONS
        saving_admin_headers_error  = 1
        admin_header_does_not_exist = 2
        OTHERS                      = 3.
    ASSERT sy-subrc = 0.

*    DATA(tool) = cl_crms4_bt_data_model_tool=>get_instance( ).
** Jerry 2017-05-12 3:44PM in this way header change mode could only be determined once,
** and this mode could be reused by other header set like shipping and pricing
*    tool->determine_head_change_mode( iv_ref_guid ).

    CALL FUNCTION 'CRM_ORDERADM_H_GET_MULTI_OB'
      EXPORTING
        it_guids_to_get  = lt_to_save
      IMPORTING
        et_object_buffer = lt_ob.

    READ TABLE lt_ob ASSIGNING FIELD-SYMBOL(<ob>) INDEX 1.
    ls_line = CORRESPONDING #( <ob> ).
    cs_workarea = ls_line.
*    CASE tool->mv_current_head_mode.
*      WHEN 'A'.
*        INSERT ls_line INTO TABLE lt_insert.
*      WHEN 'B'.
*        INSERT ls_line INTO TABLE lt_update.
*    ENDCASE.
*    CALL METHOD tool->merge_change_2_global_buffer
*      EXPORTING
*        it_current_insert = lt_insert
*        it_current_update = lt_update
*        it_current_delete = lt_delete
*      CHANGING
*        ct_global_insert  = ct_to_insert
*        ct_global_update  = ct_to_update
*        ct_global_delete  = ct_to_delete.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY(optional)
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~convert_s4_to_1o.

* for ORDERADM_H move corresponding is enough
    MOVE-CORRESPONDING is_workarea TO es_workarea.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_OB
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~get_ob.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~get_wrk_structure_name.
    rv_wrk_structure_name = 'CRMT_ORDERADM_H_WRK'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_ORDERADM_H_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID(optional)
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~put_to_db_buffer.

    DATA: lt_orderadm_h_db TYPE crmt_orderadm_h_du_tab.

    APPEND is_wrk_structure TO lt_orderadm_h_db.

    CALL FUNCTION 'CRM_ORDERADM_H_PUT_DB'
      EXPORTING
        it_orderadm_h_db = lt_orderadm_h_db.

    CALL FUNCTION 'CRM_SRVO_H_PUT_DB'
      EXPORTING
        is_header_segment = is_wrk_structure.
  ENDMETHOD.
ENDCLASS.