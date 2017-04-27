class ZCL_CRMS4_BTX_CUMULAT_H_CONV definition
  public
  final
  create public .

public section.

  interfaces ZIF_CRMS4_BTX_DATA_MODEL .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CRMS4_BTX_CUMULAT_H_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_CUMULAT_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~CONVERT_1O_TO_S4
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND
* | [<-->] CT_TO_INSERT                   TYPE        ANY TABLE
* | [<-->] CT_TO_UPDATE                   TYPE        ANY TABLE
* | [<-->] CT_TO_DELETE                   TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_crms4_btx_data_model~convert_1o_to_s4.
    DATA: lt_insert  TYPE CRMT_CUMULAT_H_DU_TAB,
          lt_update  TYPE CRMT_CUMULAT_H_DU_TAB,
          lt_delete  TYPE CRMT_CUMULAT_H_DU_TAB,
          lt_to_save TYPE crmt_object_guid_tab.

    FIELD-SYMBOLS:<srvo_h_update> TYPE zcrms4d_srvo_h_t.
    CHECK iv_ref_kind = 'A'.
    APPEND iv_ref_guid TO lt_to_save.

    CALL FUNCTION 'CRM_ORDER_UPDATE_TABLES_DETERM'
      EXPORTING
        iv_object_name       = 'CUMULAT_H'
        iv_field_name_key    = 'GUID'
        it_guids_to_process  = lt_to_save
        iv_header_to_save    = iv_ref_guid
      IMPORTING
        et_records_to_insert = lt_insert
        et_records_to_update = lt_update
        et_records_to_delete = lt_delete.

* Jerry 2017-04-26 12:11PM only support update currently
* Jerry 2017-04-27 9:19AM - How to support different transaction type in the future??
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
* | Instance Public Method ZCL_CRMS4_BTX_CUMULAT_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY(optional)
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRMS4_BTX_DATA_MODEL~CONVERT_S4_TO_1O.
    MOVE-CORRESPONDING is_workarea to es_workarea.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_CUMULAT_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRMS4_BTX_DATA_MODEL~GET_WRK_STRUCTURE_NAME.

    RV_WRK_STRUCTURE_NAME = 'CRMT_CUMULAT_H_WRK'.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_CUMULAT_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_crms4_btx_data_model~put_to_db_buffer.

    DATA: lt_cumulat_h_db TYPE  crmt_cumulat_h_du_tab.

    APPEND is_wrk_structure TO lt_cumulat_h_db.
    CALL FUNCTION 'ZCRM_CUMULAT_H_PUT_DB'
      EXPORTING
        it_cumulat_h_db = lt_cumulat_h_db.

  ENDMETHOD.
ENDCLASS.