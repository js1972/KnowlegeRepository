
REPORT  zunassign_ip.

PARAMETERS:
            order TYPE crmd_orderadm_h-object_id OBLIGATORY DEFAULT '5600000010'.

DATA: lo_core                TYPE REF TO cl_crm_bol_core,
      lo_collection          TYPE REF TO if_bol_entity_col,
      lv_query_name          TYPE crmt_ext_obj_name,
      lt_selection_parameter TYPE genilt_selection_parameter_tab,
      ls_selection_parameter TYPE genilt_selection_parameter,
      lv_item_guid type crmt_object_guid,
      lr_del_handler type ref to cl_crm_ipm_item_delete_handler,
      lv_delete    type crmt_boolean,
      lv_count     type i value 0,
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

  IF ip_instance->lock( ) = abap_false.
     ip_instance = ips->get_next( ).
     CONTINUE.
  ENDIF.

  ip_instance->GET_PROPERTY_AS_VALUE( EXPORTING iv_attr_name = 'GUID' IMPORTING ev_result = lv_item_guid ).

  CALL FUNCTION 'CRM_IPM_ITEM_IP_DELETE_CHK'
      EXPORTING
        IV_OBJECT_GUID = lv_item_guid
        IV_HEADER_GUID = lv_item_guid
      IMPORTING
        EV_DELETE      = lv_delete.

  IF lv_delete = abap_false.
     ip_instance = ips->get_next( ).
     CONTINUE.
  ENDIf.

  DATA(ip_handler) = cl_crm_ipm_item_handler_provid=>get_instance( ip_instance ).

  create object lr_del_handler
        exporting
          ir_item_handler = ip_handler.
  data lr_col type ref to if_bol_bo_col.
  create object lr_col type cl_crm_bol_bo_col.
  lr_col->add( ip_instance ).

  lr_del_handler->delete_ips( lr_col ).

  ADD 1 TO lv_count.

  ip_instance = ips->get_next( ).
ENDWHILE.

lo_core->modify( ).

DATA(lo_transaction) = lo_core->get_transaction( ).
CHECK lo_transaction->check_save_possible( ) = abap_true.

CHECK lo_transaction->save( ) = abap_true.

lo_transaction->commit( ).

WRITE: / 'Successfully Unassigned IP number: ', lv_count.