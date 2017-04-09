*&---------------------------------------------------------------------*
*& Report  ZREMOVE_PRICE_DATA
*&
*&---------------------------------------------------------------------*
* Jerry 2016-12-5 10：42AM - delayed for one hour!! now 10:42AM 
*&
*&---------------------------------------------------------------------*
REPORT zremove_price_data.

PARAMETERS: id TYPE crmd_orderadm_h-object_id OBLIGATORY.

START-OF-SELECTION.
  DATA: lt_guid TYPE STANDARD TABLE OF crmd_orderadm_h-guid,
        lv_guid LIKE LINE OF lt_guid,
        lt_link TYPE STANDARD TABLE OF crmd_link.

  SELECT guid INTO TABLE lt_guid FROM crmd_orderadm_h WHERE object_id = id.

  IF sy-subrc <> 0.
    WRITE: / 'the id you have specified is not valid' , id.
    RETURN.
  ENDIF.

  SELECT * INTO TABLE lt_link FROM crmd_link FOR ALL ENTRIES IN lt_guid
     WHERE objtype_hi = '05' AND objtype_set = '18' AND guid_hi = lt_guid-table_line.

  IF sy-subrc <> 0.
     WRITE: / 'no pricing document link for this order.'.
     RETURN.
  ENDIF.

  LOOP AT lt_guid INTO lv_guid.
    DELETE FROM crmd_link WHERE objtype_hi = '05' AND objtype_set = '18'
     AND guid_hi = lv_guid.
    IF sy-subrc = 0.
      WRITE: / 'pricing link for document:' , lv_guid,  ' deleted successfully.'.
    ELSE.
      WRITE: / 'pricing link for document:' , lv_guid,  ' deleted failed.'.
    ENDIF.
  ENDLOOP.