*&---------------------------------------------------------------------*
*& Report  ZHANA_PRODUCT_SEARCH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zassign_ip.

PARAMETERS: prod  type comm_product-product_id OBLIGATORY DEFAULT '5600000010',
            order TYPE CRMD_ORDERADM_H-object_id.

DATA: lo_core                TYPE REF TO cl_crm_bol_core,
      lo_collection          TYPE REF TO if_bol_entity_col,
      lv_query_name          TYPE crmt_ext_obj_name,
      lt_selection_parameter TYPE genilt_selection_parameter_tab,
      ls_selection_parameter TYPE genilt_selection_parameter,
      ls_query_parameters    TYPE genilt_query_parameters.

ls_selection_parameter-attr_name = 'OBJECTID'.
ls_selection_parameter-option =  'EQ'.
ls_selection_parameter-sign = 'I'.
ls_selection_parameter-low =  order.
APPEND ls_selection_parameter TO lt_selection_parameter.

ls_query_parameters-max_hits = 1.
lv_query_name = 'BTAdvQueryAUI'.

lo_core = cl_crm_bol_core=>get_instance( ).
lo_core->load_component_set( 'BT' ).

lo_collection = lo_core->dquery(
        iv_query_name               = lv_query_name
        it_selection_parameters     = lt_selection_parameter
        is_query_parameters         = ls_query_parameters ).


DATA(lo_contract) = lo_collection->get_current( ).
CHECK lo_contract IS NOT INITIAL.
DATA(locked) = lo_contract->lock( ).

CHECK locked  = 'X'.

DATA(lr_item_handler)  = cl_crm_ipm_item_handler_provid=>get_instance( lo_contract ).
ASSERT lr_item_handler IS NOT INITIAL.


lv_query_name = 'ProdAdvSearchRgProducts'.
CLEAR: lt_selection_parameter.
ls_selection_parameter-attr_name = 'PRODUCT_ID'.
ls_selection_parameter-option =  'EQ'.
ls_selection_parameter-sign = 'I'.
ls_selection_parameter-low =  prod.
APPEND ls_selection_parameter TO lt_selection_parameter.
lo_core->load_component_set( 'PROD_ALL' ).

lo_collection = lo_core->dquery(
    iv_query_name               = lv_query_name
    it_selection_parameters     = lt_selection_parameter
    is_query_parameters         = ls_query_parameters ).


DATA(lo_product) = lo_collection->get_current( ).
ASSERT lo_product IS NOT INITIAL.
DATA(result) = lr_item_handler->create_ip( lo_product ).
ASSERT result IS NOT INITIAL.

DATA(lo_transaction) = lo_core->get_transaction( ).

lo_core->modify( ).
DATA(lv_changed) = lo_transaction->check_save_needed( ).

CHECK lv_changed EQ abap_true.
DATA(lv_success) = lo_transaction->save( ).
IF lv_success = abap_true.
  lo_transaction->commit( ).
  WRITE:/ 'IP Assigned Successfully'.
ELSE.
  lo_transaction->rollback( ).
  WRITE: / 'IP Assigned failed'.
ENDIF.