*&---------------------------------------------------------------------*
*& Report  PROD_MULTIPLE_CHANGE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZPROD_MULTIPLE_CHANGE.


PARAMETERS: prd1 type comm_product-product_id OBLIGATORY DEFAULT 'ZJERRYTEST11241',
            prd2 type comm_product-product_id OBLIGATORY DEFAULT 'ZJERRYTEST1124'.

DATA:   lt_productm    TYPE  comt_product_maintain_api_extt,
        ls_productm    TYPE  comt_product_maintain_api_ext,
        lt_sale_data   TYPE CRMT_CRMM_PR_SALESH_MAINTAIN_T,
        lt_prod_data   TYPE COMT_PRODUCT_MAINTAIN_API_SETT,
        ls_prod_data   LIKE LINE OF lt_prod_data,
        et_bapireturnh TYPE bapiret2_tab,
        lt_product     TYPE comt_product_s_tab,
        lv_operation   TYPE char1 VALUE 'U',
        lt_prod_out    TYPE comt_product_tab_guid,
        lt_shorttext   TYPE comt_pr_shtext_maintain_tab,
        ls_shorttext   LIKE LINE OF lt_shorttext,
        lt_prod_id     TYPE STANDARD TABLE OF comm_product-product_id,
        lt_prod_db     TYPE STANDARD TABLE OF comm_product-product_guid.

START-OF-SELECTION.

  APPEND prd1 TO lt_prod_id.
  APPEND prd2 TO lt_prod_id.

  LOOP AT lt_prod_id ASSIGNING FIELD-SYMBOL(<id>).
    CALL FUNCTION 'CONVERSION_EXIT_PRID1_INPUT'
      EXPORTING
        input  = <id>
      IMPORTING
        output = <id>.
  ENDLOOP.

  SELECT product_guid INTO TABLE lt_prod_db FROM comm_product FOR ALL ENTRIES IN lt_prod_id
     WHERE product_id = lt_prod_id-table_line.

  ASSERT sy-subrc = 0.

  LOOP AT lt_prod_db ASSIGNING FIELD-SYMBOL(<guid>).
    DATA(ls_product) = VALUE comt_product_s( product_guid = <guid> ).
    APPEND ls_product TO lt_product.
  ENDLOOP.

  CALL FUNCTION 'COM_PRODUCT_READ_MULTIPLE'
    EXPORTING
      it_product = lt_product
    IMPORTING
      et_product = lt_prod_out.

  PERFORM fill_prod_data.

  PERFORM change_and_save using ABAP_FALSE.

  PERFORM prepare_for_second_insert CHANGING lt_productm.

  PERFORM change_and_save USING ABAP_TRUE.

  FORM fill_prod_data.
  LOOP AT lt_prod_out ASSIGNING FIELD-SYMBOL(<result>).
    MOVE-CORRESPONDING <result> TO ls_productm-header-com_product.
    ls_productm-header-pr_number = sy-tabix.

    PERFORM fill_sales_area USING ls_productm-header-com_product-product_guid lv_operation CHANGING lt_sale_data .
    ls_prod_data-settype_id = 'CRMM_PR_SALESH'.
    GET REFERENCE OF lt_sale_data INTO ls_prod_data-data.
    CLEAR: lt_prod_data.
    APPEND ls_prod_data TO lt_prod_data.
    ls_productm-data = lt_prod_data.

    APPEND ls_productm TO lt_productm.
  ENDLOOP.
  ENDFORM.

  FORM prepare_for_second_insert CHANGING ct_product TYPE comt_product_maintain_api_extt.
    CLEAR: ct_product.

    PERFORM fill_prod_data.
  ENDFORM.

  FORM fill_sales_area  USING guid TYPE comm_product-product_guid operation TYPE char1 CHANGING ct_sales TYPE CRMT_CRMM_PR_SALESH_MAINTAIN_T.
     CLEAR: ct_sales.
     FIELD-SYMBOLS: <line> LIKE LINE OF ct_sales.
     APPEND INITIAL LINE TO ct_sales ASSIGNING <line>.
     <line>-update_type = operation.
     <line>-relation-client = sy-mandt.
     <line>-relation-product_guid = guid.
     <line>-relation-fragment_guid = '380BDF7B502D63F7E10000009B38FA0B'.
     <line>-relation-sales_org = 'O 50003059'.
     <line>-relation-distr_chan = '01'.
     <line>-relation-logsys = 'AG3CLNT001'.

  ENDFORM.

  FORM change_and_save USING save type abap_bool.
   CLEAR: et_bapireturnh.

   CALL FUNCTION 'COM_PRODUCT_MAINTAIN_MULT_API'
    EXPORTING
      iv_check_only                 = ' '
      iv_suppress_inactive          = 'X'
      iv_activate_inactive_products = 'X'
    IMPORTING
      et_bapireturn                 = et_bapireturnh
    CHANGING
      ct_product                    = lt_productm
    EXCEPTIONS
      internal_error                = 1
      OTHERS                        = 2.

  LOOP AT et_bapireturnh ASSIGNING FIELD-SYMBOL(<error>).
    WRITE: / 'Error: ', <error>-message COLOR COL_NEGATIVE.
  ENDLOOP.

  CHECK et_bapireturnh IS INITIAL.

  IF save = 'X'.
   CALL FUNCTION 'CRM_PRODUCT_UI_SAVE'
     EXPORTING
       iv_update_task = abap_false.

   ASSERT sy-subrc = 0.

   COMMIT WORK AND WAIT.

   WRITE: / 'Mass change finished successfully' COLOR COL_POSITIVE.
 ENDIf.

ENDFORM.