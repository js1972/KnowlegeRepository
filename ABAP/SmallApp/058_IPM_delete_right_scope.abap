
REPORT  zdelete_right_scope.

PARAMETERS:
            order TYPE crmd_orderadm_h-object_id OBLIGATORY DEFAULT '5600000010'.

DATA: lo_core                TYPE REF TO cl_crm_bol_core,
      lo_collection          TYPE REF TO if_bol_entity_col,
      lv_query_name          TYPE crmt_ext_obj_name,
      lt_selection_parameter TYPE genilt_selection_parameter_tab,
      ls_selection_parameter TYPE genilt_selection_parameter,
      lr_del_handler         TYPE REF TO cl_crm_ipm_item_delete_handler,
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
lo_core->load_component_set( 'IPMRM' ).
lo_collection = lo_core->dquery(
        iv_query_name               = lv_query_name
        it_selection_parameters     = lt_selection_parameter
        is_query_parameters         = ls_query_parameters ).


DATA(lo_contract) = lo_collection->get_current( ).
CHECK lo_contract IS NOT INITIAL.
DATA: lr_item_handler TYPE REF TO cl_crm_ipm_item_handler.
CREATE OBJECT lr_item_handler EXPORTING iv_header_bol_entity = lo_contract.

DATA(ips) = lr_item_handler->get_ips( ).

DATA(ip_instance) = ips->get_first( ).

WHILE ip_instance IS NOT INITIAL.
  DATA(ip_handler) = cl_crm_ipm_item_handler_provid=>get_instance( ip_instance ).

  DATA(scope_collection) = ip_handler->get_rights_scopes( ip_instance ).
  CHECK scope_collection IS NOT INITIAL.

  DATA(ip) = cl_crm_ipm_order_item_entity=>get_instance( io_original = ip_instance iv_ipm_admini_type = 'IP' ).
  DATA(scope) = scope_collection->get_first( ).
  WHILE scope IS NOT INITIAL.

    DATA(wrapped) = cl_crm_ipm_order_item_entity=>get_instance( io_original = scope iv_ipm_admini_type = 'RIGHTSCOPE' ).
    DATA(scope_handler) = cl_crm_ipm_item_handler_provid=>get_instance( wrapped ).

    CREATE OBJECT lr_del_handler
      EXPORTING
        ir_item_handler = scope_handler.

    lr_del_handler->delete_scope( ir_ip   =  ip
                                  ir_item = wrapped ).
    ip = cl_crm_ipm_order_item_entity=>get_instance( io_original = ip_instance iv_ipm_admini_type = 'IP' ).
    scope = scope_collection->get_next( ).
  ENDWHILE.

  ip_instance = ips->get_next( ).
ENDWHILE.

lo_core->modify( ).

DATA(lo_transaction) = lo_core->get_transaction( ).
CHECK lo_transaction->check_save_possible( ) = abap_true.

CHECK lo_transaction->save( ) = abap_true.

lo_transaction->commit( ).

WRITE: / 'IP Right scope deleted successfully!'.