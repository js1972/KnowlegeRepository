FUNCTION zcrm_orderadm_h_select_s_db .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_GUID) TYPE  CRMT_OBJECT_GUID OPTIONAL
*"  EXPORTING
*"     REFERENCE(ES_ORDERADM_H_DB) TYPE  CRMD_ORDERADM_H
*"  EXCEPTIONS
*"      PARAMETER_ERROR
*"      RECORD_NOT_FOUND
*"      EVENT_HANDLER_REG_FAILED
*"----------------------------------------------------------------------

  DATA: lv_dummy_message(1)   TYPE   c,
        ls_btx_h              TYPE zcrms4d_btx,
        lv_acronym            TYPE zcrmc_subob_cat-acronym,
        lr_dbtab              TYPE REF TO data,
        lt_objects            TYPE TABLE OF crmc_object_assi-name,
        lv_type               TYPE zcrmc_objects-type,
        lv_kind               TYPE zcrmc_objects-kind,
        lv_wrk_structure_name TYPE string,
        lr_wrk_structure      TYPE REF TO data,
        lo_convertor          TYPE REF TO zif_crms4_btx_data_model,
        lv_conv_class         TYPE seoclass-clsname.

  FIELD-SYMBOLS: <ls_dbtab>         TYPE any,
                 <ls_wrk_structure> TYPE any,
                 <lv_object>        TYPE crmc_object_assi-name.

  CLEAR es_orderadm_h_db.

  IF iv_guid IS INITIAL.
    MESSAGE i202(crm_order_misc) RAISING parameter_error.
  ENDIF.

*  SELECT SINGLE * INTO  es_orderadm_h_db FROM  crmd_orderadm_h WHERE guid = iv_guid.
*
*  IF sy-subrc NE 0.
*      MESSAGE i203(crm_order_misc) RAISING record_not_found.
*  ENDIF.

  SELECT SINGLE * INTO ls_btx_h FROM zcrms4d_btx WHERE order_guid = iv_guid.
  IF sy-subrc NE 0.
    MESSAGE i203(crm_order_misc) RAISING record_not_found.
  ENDIF.

  SELECT SINGLE acronym FROM zcrmc_subob_cat INTO lv_acronym
       WHERE subobj_category = ls_btx_h-object_type.

  DATA(lv_dbtab_name) = 'ZCRMS4D_' && lv_acronym && '_H'.

  CREATE DATA lr_dbtab TYPE (lv_dbtab_name).
  ASSIGN lr_dbtab->* TO <ls_dbtab>.

  SELECT SINGLE * FROM (lv_dbtab_name)
    INTO <ls_dbtab>
    WHERE guid = iv_guid.

  IF sy-subrc <> 0.
    MESSAGE i203(crm_order_misc) RAISING record_not_found.
  ENDIF.

* Get all possible components for the given header object type
  SELECT name FROM zcrmc_object_ass INTO TABLE lt_objects WHERE subobj_category = ls_btx_h-object_type.

  LOOP AT lt_objects ASSIGNING <lv_object>.
    CLEAR lv_conv_class.
    SELECT SINGLE type kind conv_class FROM zcrmc_objects
      INTO (lv_type, lv_kind, lv_conv_class)
      WHERE name = <lv_object>.
    CHECK lv_conv_class IS NOT INITIAL.
    CREATE OBJECT lo_convertor TYPE (lv_conv_class).
    CALL METHOD lo_convertor->get_wrk_structure_name
      RECEIVING
        rv_wrk_structure_name = lv_wrk_structure_name.
    CREATE DATA lr_wrk_structure TYPE (lv_wrk_structure_name).
    ASSIGN lr_wrk_structure->* TO <ls_wrk_structure>.
    CALL METHOD lo_convertor->convert_s4_to_1o
      EXPORTING
        is_workarea = <ls_dbtab>
      IMPORTING
        es_workarea = <ls_wrk_structure>.
    CALL METHOD lo_convertor->put_to_db_buffer
      EXPORTING
        is_wrk_structure = <ls_wrk_structure>.

  ENDLOOP.

ENDFUNCTION.