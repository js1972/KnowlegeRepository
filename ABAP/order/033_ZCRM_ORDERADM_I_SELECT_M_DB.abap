FUNCTION zcrm_orderadm_i_select_m_db.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_ITEMS_TO_READ) TYPE  CRMT_OBJECT_GUID_TAB OPTIONAL
*"     REFERENCE(IV_HEADER_GUID) TYPE  CRMT_OBJECT_GUID OPTIONAL
*"     REFERENCE(IT_HEADER_GUID) TYPE  CRMT_OBJECT_GUID_TAB OPTIONAL
*"  EXPORTING
*"     REFERENCE(ET_ORDERADM_I_DB) TYPE  CRMT_ORDERADM_I_DU_TAB
*"  EXCEPTIONS
*"      ITEMS_DO_NOT_EXIST
*"----------------------------------------------------------------------

  DATA:
    lv_mode        TYPE crmt_boolean VALUE false,
    lt_guid        TYPE crmt_object_guid_tab,
    lt_item_guid   TYPE crmt_object_guid_tab,
    lt_item_by_header TYPE CRMT_ORDERADM_I_DU_TAB,
    ls_result_line TYPE crmd_orderadm_i,
    lv_header      TYPE crmt_boolean VALUE false,
    lv_lines       TYPE i,
    lv_guid        TYPE crmt_object_guid,
    lt_btx_i       TYPE TABLE OF ZCRMS4D_BTX_I.

  FIELD-SYMBOLS:
    <ls_header_guid> LIKE LINE OF it_header_guid.

* SELECT by item

  DATA(lo_tool) = zcl_crms4_btx_data_model_tool=>get_instance( ).
  lo_tool->get_item( EXPORTING it_item_guid = it_items_to_read
                     IMPORTING et_orderadm_i_db = et_orderadm_i_db ).
* SELECT by header
  IF NOT iv_header_guid IS INITIAL.
    lv_header = true.
    CALL FUNCTION 'ZCRM_ORDERADM_H_ON_DATABASE_OW'
      EXPORTING
        iv_orderadm_h_guid  = iv_header_guid
      IMPORTING
        ev_on_database_flag = lv_mode.
*   Do not select, when header is in create-mode
    IF lv_mode = true.
      INSERT iv_header_guid INTO TABLE lt_guid.
    ENDIF.

  ENDIF.

  LOOP AT it_header_guid ASSIGNING <ls_header_guid>.
    lv_header = true.
    CALL FUNCTION 'ZCRM_ORDERADM_H_ON_DATABASE_OW'
      EXPORTING
        iv_orderadm_h_guid  = <ls_header_guid>
      IMPORTING
        ev_on_database_flag = lv_mode.

*   Do not select, when header is in create-mode
    CHECK lv_mode = true.

    INSERT <ls_header_guid> INTO TABLE lt_guid.

  ENDLOOP.

  IF lt_guid IS NOT INITIAL.

     SELECT * INTO TABLE lt_btx_i FROM ZCRMS4D_BTX_I FOR ALL ENTRIES IN lt_guid
        where header_guid = lt_guid-table_line.

     CHECK sy-subrc = 0.

     LOOP AT lt_btx_i ASSIGNING FIELD-SYMBOL(<btx_i>).
        APPEND <btx_i>-item_guid TO lt_item_guid.
     ENDLOOP.

     lo_tool->get_item( EXPORTING it_item_guid = lt_item_guid
                     IMPORTING et_orderadm_i_db = lt_item_by_header ).

     APPEND LINES OF lt_item_by_header TO et_orderadm_i_db.

* Jerry 2017-04-21 18:45PM - possible duplicate records?
  ELSE.
* in create mode set sy-subrc = 4 and raise items_do_not_exist
    IF lv_header = true AND lv_mode = false.
      MESSAGE i014 WITH iv_header_guid RAISING items_do_not_exist.
    ENDIF.
  ENDIF.

ENDFUNCTION.