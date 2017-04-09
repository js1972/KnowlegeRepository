*&---------------------------------------------------------------------*
*& Report  ZHANA_PRODUCT_SEARCH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zsat_order_modify.

PARAMETERS: po_id  TYPE crmd_orderadm_h-object_id,
            text TYPE string,
            maxhit TYPE i.

DATA: lo_core                TYPE REF TO cl_crm_bol_core,
      lo_collection          TYPE REF TO if_bol_entity_col,
      lo_root_entity         TYPE REF TO cl_crm_bol_entity,
      lv_view_name           TYPE crmt_view_name,
      lv_query_name          TYPE crmt_ext_obj_name VALUE 'BTQSlsOrd',
      lt_selection_parameter TYPE genilt_selection_parameter_tab.

START-OF-SELECTION.

  SHIFT po_id RIGHT DELETING TRAILING space.
  IF po_id NE space.
    DATA(ls_selection_parameter) = VALUE genilt_selection_parameter( attr_name = 'OBJECT_ID' sign = 'I'
                                                                 option = 'EQ' low = po_id ).
    APPEND ls_selection_parameter TO lt_selection_parameter.
  ENDIF.

  IF maxhit EQ space.
    maxhit = 100.
  ENDIF.

  DATA(ls_query_parameter) = VALUE genilt_query_parameters( max_hits = maxhit ).

  lo_core = cl_crm_bol_core=>get_instance( ).
  lo_core->load_component_set( 'BT' ).
  DATA(lo_transaction) = lo_core->get_transaction( ).

  lo_collection = lo_core->dquery(
      iv_query_name               = lv_query_name
      is_query_parameters         = ls_query_parameter
      it_selection_parameters     = lt_selection_parameter
      iv_view_name                = lv_view_name ).

  DATA(lv_size) = lo_collection->if_bol_bo_col~size( ).

  WRITE:/ 'Number of ' , lv_size, ' Sales Order has been found!'.
  ASSERT lv_size = 1.
  DATA(lo_result) = lo_collection->get_first( ).
  DATA(lo_order) = lo_result->get_related_entity( 'BTADVSSlsOrd' ).
  DATA(lo_header) = lo_order->get_related_entity( 'BTOrderHeader' ).

  lo_header->set_property( iv_attr_name = 'DESCRIPTION' iv_value = text ).

  lo_core->modify( ).
  DATA(lv_changed) = lo_transaction->check_save_needed( ).

  ASSERT lv_changed EQ abap_true.
  DATA(lv_success) = lo_transaction->save( ).
  ASSERT lv_success = abap_true.
  lo_transaction->commit( ).
  WRITE:/ 'Sales Order changed Successfully'.