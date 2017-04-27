CLASS zcl_crms4_btx_orderadm_h_conv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_crms4_btx_data_model .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CRMS4_BTX_ORDERADM_H_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_ORDERADM_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~CONVERT_1O_TO_S4
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND
* | [<-->] CT_TO_INSERT                   TYPE        ANY TABLE
* | [<-->] CT_TO_UPDATE                   TYPE        ANY TABLE
* | [<-->] CT_TO_DELETE                   TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_crms4_btx_data_model~convert_1o_to_s4.
    DATA: lt_insert  TYPE crmt_orderadm_h_du_tab,
          lt_update  TYPE crmt_orderadm_h_du_tab,
          lt_delete  TYPE crmt_orderadm_h_du_tab,
          lt_to_save TYPE crmt_object_guid_tab.

    FIELD-SYMBOLS:<srvo_h_update> TYPE zcrms4d_srvo_h_t.
    CHECK iv_ref_kind = 'A'.
    APPEND iv_ref_guid TO lt_to_save.

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

* Jerry 2017-04-26 12:11PM only support update currently
    READ TABLE lt_update ASSIGNING FIELD-SYMBOL(<update>) INDEX 1.
    CHECK sy-subrc = 0.
    DATA(lr_to_update) = REF #( ct_to_update ).
    ASSIGN lr_to_update->* TO <srvo_h_update>.

    READ TABLE <srvo_h_update> ASSIGNING FIELD-SYMBOL(<to_be_merge>) WITH KEY
        guid = iv_ref_guid.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING <update> TO <to_be_merge>.
    ELSE.
      APPEND INITIAL LINE TO <srvo_h_update> ASSIGNING FIELD-SYMBOL(<to_fill>).
      MOVE-CORRESPONDING <update> TO <to_fill>.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_ORDERADM_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY(optional)
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_crms4_btx_data_model~convert_s4_to_1o.

* for ORDERADM_H move corresponding is enough
    MOVE-CORRESPONDING is_workarea TO es_workarea.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_ORDERADM_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_crms4_btx_data_model~get_wrk_structure_name.
    rv_wrk_structure_name = 'CRMT_ORDERADM_H_WRK'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_ORDERADM_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_crms4_btx_data_model~put_to_db_buffer.

    DATA: lt_orderadm_h_db TYPE crmt_orderadm_h_du_tab.

    APPEND is_wrk_structure TO lt_orderadm_h_db.

    CALL FUNCTION 'ZCRM_ORDERADM_H_PUT_DB'
      EXPORTING
        it_orderadm_h_db = lt_orderadm_h_db.
  ENDMETHOD.
ENDCLASS.