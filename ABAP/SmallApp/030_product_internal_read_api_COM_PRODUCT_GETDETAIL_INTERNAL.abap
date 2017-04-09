REPORT zprod_internal_read_api.

DATA:
  ls_product          TYPE   comt_product,
  lt_read_settype_id  TYPE   comt_frgtype_id_tab,
  ls_product_old_data TYPE   comt_product_maintain_api,
  lt_set_old_data     TYPE   comt_product_maintain_api_sett,
  lt_org_type         TYPE   comt_pr_org_type_list_tab.

ls_product-product_guid = '00163EA720001EE28EA88D619832B285'.
ls_product-product_type = '01'.


APPEND 'CRMM_PR_SALESH' TO lt_read_settype_id.
APPEND 'CRMM_PR_SALESH' TO lt_read_settype_id.

APPEND '01' TO lt_org_type.
CALL FUNCTION 'COM_PRODUCT_GETDETAIL_INTERNAL'
  EXPORTING
    is_product        = ls_product
    iv_read_db_values = 'X'
    it_req_settypes   = lt_read_settype_id
    it_org_types      = lt_org_type
  IMPORTING
    es_product        = ls_product_old_data
    et_set            = lt_set_old_data.

READ TABLE lt_set_old_data ASSIGNING FIELD-SYMBOL(<result1>) INDEX 1.
READ TABLE lt_set_old_data ASSIGNING FIELD-SYMBOL(<result2>) INDEX 2.

BREAK-POINT.