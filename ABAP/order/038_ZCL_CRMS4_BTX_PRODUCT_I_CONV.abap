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
* | [--->] IV_CURRENT_GUID                TYPE        CRMT_OBJECT_GUID
* | [<-->] CT_TO_INSERT                   TYPE        ANY TABLE
* | [<-->] CT_TO_UPDATE                   TYPE        ANY TABLE
* | [<-->] CT_TO_DELETE                   TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~convert_1o_to_s4.

    DATA: lt_insert   TYPE CRMT_PRODUCT_I_DU_TAB,
          lt_update   TYPE CRMT_PRODUCT_I_DU_TAB,
          lt_delete   TYPE CRMT_PRODUCT_I_DU_TAB,
          lt_to_save  TYPE crmt_object_guid_tab,
          lt_header   LIKE lt_to_save,
          lr_new_line TYPE REF TO data.

    FIELD-SYMBOLS:<i_update>      TYPE ANY TABLE,
                  <i_insert>      TYPE ANY TABLE,
                  <new_line_item> TYPE any.
    CHECK iv_ref_kind = 'A'.
    APPEND iv_current_guid TO lt_to_save.
    APPEND iv_ref_guid TO lt_header.

    CALL FUNCTION 'CRM_ORDER_UPDATE_TABLES_DETERM'
      EXPORTING
        iv_object_name       = 'PRODUCT_I'
        iv_field_name_key    = 'GUID'
        it_guids_to_process  = lt_to_save
        iv_header_to_save    = iv_ref_guid
      IMPORTING
        et_records_to_insert = lt_insert
        et_records_to_update = lt_update
        et_records_to_delete = lt_delete.

* ct_* can have different table type like CRMS4D_SALE_I_T, CRMS4D_SVPR_I_T
* Jerry 2017-04-26 12:11PM only support update currently

    READ TABLE lt_update ASSIGNING FIELD-SYMBOL(<update>) INDEX 1.
    IF sy-subrc = 0.
      DATA(lr_to_update) = REF #( ct_to_update ).
      ASSIGN lr_to_update->* TO <i_update>.

      LOOP AT <i_update> ASSIGNING FIELD-SYMBOL(<update_queue>).
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <update_queue> TO
           FIELD-SYMBOL(<update_record_in_queue>).
        CHECK sy-subrc = 0.
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <update> TO
           FIELD-SYMBOL(<currently_determined_update>).
        CHECK sy-subrc = 0.
        IF <update_record_in_queue> = <currently_determined_update>.
          MOVE-CORRESPONDING <update> TO <update_queue>.
        ENDIF.
      ENDLOOP.
      IF <i_update> IS INITIAL.
        CREATE DATA lr_new_line LIKE LINE OF ct_to_update.
        ASSIGN lr_new_line->* TO <new_line_item>.
        MOVE-CORRESPONDING <update> TO <new_line_item>.
        INSERT <new_line_item> INTO TABLE <i_update>.
      ENDIF.
    ENDIF.

    READ TABLE lt_insert ASSIGNING FIELD-SYMBOL(<insert>) INDEX 1.
    IF sy-subrc = 0.
      DATA(lr_to_insert) = REF #( ct_to_insert ).
      ASSIGN lr_to_insert->* TO <i_insert>.

      LOOP AT <i_insert> ASSIGNING FIELD-SYMBOL(<insert_queue>).
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <insert_queue> TO
           FIELD-SYMBOL(<insert_record_in_queue>).
        CHECK sy-subrc = 0.
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <insert> TO
           FIELD-SYMBOL(<currently_determined_insert>).
        CHECK sy-subrc = 0.
        IF <insert_record_in_queue> = <currently_determined_insert>.
          MOVE-CORRESPONDING <insert> TO <insert_queue>.
        ENDIF.
      ENDLOOP.
      IF <i_insert> IS INITIAL.
* Jerry 2017-05-04 10:56AM - reason for this code:
* https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/36
        CREATE DATA lr_new_line LIKE LINE OF ct_to_insert.
        ASSIGN lr_new_line->* TO <new_line_item>.
        MOVE-CORRESPONDING <insert> TO <new_line_item>.
        INSERT <new_line_item> INTO TABLE <i_insert>.
      ENDIF.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRODUCT_I_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY(optional)
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_conv~CONVERT_S4_TO_1O.
    MOVE-CORRESPONDING is_workarea to es_workarea.
  endmethod.


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
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD IF_CRMS4_BTX_DATA_MODEL_conv~put_to_db_buffer.
    DATA: lt_product_i_db_buffer TYPE crmt_product_i_du_tab.

    APPEND is_wrk_structure TO lt_product_i_db_buffer.

    CALL FUNCTION 'CRM_PRODUCT_I_PUT_DB'
      EXPORTING
        it_product_i_db = lt_product_i_db_buffer.
  ENDMETHOD.
ENDCLASS.