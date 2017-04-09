PARAMETERS: id type comm_product-product_id OBLIGATORY DEFAULT 'ZJERRY3'.


DATA: lv_guid TYPE comm_product-product_guid,
      lv_objnr TYPE ibin-objnr,
      lt_ibin TYPE STANDARD TABLE OF ibin.

START-OF-SELECTION.
  SELECT SINGLE product_guid INTO lv_guid FROM comm_product WHERE product_id = id.
  CHECK sy-subrc = 0.

  lv_objnr = cl_ibase_service=>cl_convert_guid_16_22( lv_guid ).
  SELECT * INTO TABLE lt_ibin FROM IBIN WHERE objnr = lv_objnr.

  LOOP AT lt_ibin ASSIGNING FIELD-SYMBOL(<ibin>).
     WRITE: / 'IBASE ID: ', <ibin>-ibase COLOR COL_NEGATIVE,
        'IBASE component ID: ', <ibin>-instance COLOR COL_TOTAL.
  ENDLOOP.