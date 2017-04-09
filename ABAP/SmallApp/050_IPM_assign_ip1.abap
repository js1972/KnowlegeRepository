
REPORT  zassign_ip1.

PARAMETERS:
            order TYPE crmd_orderadm_h-object_id OBLIGATORY DEFAULT '5600000010'.

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
lo_core->load_component_set( 'IPMRM' ).
lo_collection = lo_core->dquery(
        iv_query_name               = lv_query_name
        it_selection_parameters     = lt_selection_parameter
        is_query_parameters         = ls_query_parameters ).


DATA(lo_contract) = lo_collection->get_current( ).
CHECK lo_contract IS NOT INITIAL.
DATA: lr_item_handler TYPE REF TO cl_crm_ipm_item_handler.
CREATE OBJECT lr_item_handler EXPORTING iv_header_bol_entity = lo_contract.

DATA(ips) = lr_item_handler->get_all_ips( ).

DATA(second_ip) = ips->find( iv_index = 2 ).
CHECK second_ip IS NOT INITIAL.
DATA(item_handler) = cl_crm_ipm_item_handler_provid=>get_instance( second_ip ).

DATA(wrapped_ip) = cl_crm_ipm_order_item_entity=>get_instance( io_original = second_ip iv_ipm_admini_type = 'IP' ).

DATA(new_scope) = item_handler->create_rights_scope( io_admini_entity = wrapped_ip
               iv_item_group = cl_crm_ipm_contr_scenario_cb=>gc_item_group_rights ).

CHECK new_scope IS NOT INITIAL.
lo_core->modify( ).

DATA(char_scope) = cl_crm_ipm_rights_ui_tools=>create_rights_scope( ir_entity = new_scope
                                                            iv_relation = 'BTItemIPMRcharSet' ).

CHECK char_scope IS NOT INITIAL.
char_scope->switch_to_change_mode( ).

char_scope->set_property( iv_attr_name = 'SCOPE_DSC' iv_value = 'fill by code' ).

DATA(scope_detail) = char_scope->get_related_entity( 'BTIPMRightGroupAll' ).

CHECK scope_detail IS NOT INITIAL.

scope_detail->switch_to_change_mode( ).
scope_detail->set_property( iv_attr_name = 'RGHTDIM01' iv_value = 'BOOKS' ).
scope_detail->set_property( iv_attr_name = 'RGHTDIM01_DSC' iv_value = 'BOOKs' ).
scope_detail->set_property( iv_attr_name = 'RGHTDIM02' iv_value = 'NAM' ).
scope_detail->set_property( iv_attr_name = 'RGHTDIM02_DSC' iv_value = 'North America' ).
scope_detail->set_property( iv_attr_name = 'RGHTDIM03' iv_value = 'DE' ).
scope_detail->set_property( iv_attr_name = 'RGHTDIM03_DSC' iv_value = 'German' ).

lo_core->modify( ).

DATA(lo_transaction) = lo_core->get_transaction( ).

CHECK lo_transaction->check_save_possible( ) = abap_true.

CHECK lo_transaction->save( ) = abap_true.

lo_transaction->commit( ).