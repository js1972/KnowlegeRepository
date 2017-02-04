* 1. get CRM object related handlers
CRM_OBJECT_NAMES_DETERMINE

* 2. get sales area F4 value HELP
call method cl_crm_orgman_services=>order_sale_resp_org_f4
    exporting
      iv_sales_org    = lv_sales_org
      iv_sales_office = lv_sales_office
      iv_sales_group  = lv_sales_group
      iv_dis_channel  = lv_dis_channel
      iv_division     = lv_division
    importing
      et_f4_list      = lt_f4_list.
* 3. object name and return handling function module
 input is object name CRM_OBJECT_NAMES_DETERMINE
CRM_ORDER_UPDATE_TABLES_DETERM      

* field check handler assignment
CRMC_FIELDCHECK