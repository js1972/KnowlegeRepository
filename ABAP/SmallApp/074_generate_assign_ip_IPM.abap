REPORT  zgenerate_assign_ip.


" this report create a series of product based on template product and assign them to a given contract
PARAMETERS: num type i,
            prod type comm_product-product_id OBLIGATORY DEFAULT 'MEETMYFRIENDTOM',
            order TYPE CRMD_ORDERADM_H-object_id OBLIGATORY DEFAULT '5600000010'.

DATA: lo_core                TYPE REF TO cl_crm_bol_core,
      lo_collection          TYPE REF TO if_bol_entity_col,
      lv_query_name          TYPE crmt_ext_obj_name,
      lt_reltype_filter      TYPE comt_il_reltype_tab,
      lv_product_id          TYPE comm_product-product_id,
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

DO num TIMES.
  CALL METHOD cl_crm_ipm_ip_copy=>set_mass_gen_mode( lt_reltype_filter ).
  DATA(lr_col) = lo_product->execute( iv_method_name = 'COPY_PRODUCT' ). "#EC NOTEXT

  ASSERT lr_col IS NOT INITIAL.

  DATA(lo_first) = lr_col->get_first( ).

  WHILE lo_first IS NOT INITIAL.
    lv_product_id = lo_first->get_property_as_string( 'PRODUCT_ID' ).
    WRITE: / 'Generated IP Product ID: ' , lv_product_id.
    DATA(lo_short_text) = lo_first->get_related_entity( 'ProductShortText' ).

    IF lo_short_text IS INITIAL.
      lo_short_text = lo_first->CREATE_RELATED_ENTITY( IV_RELATION_NAME = 'ProductShortText' ).
    ENDIF.

    lo_short_text->set_property( iv_attr_name = 'SHORT_TEXT' iv_value = lv_product_id ).
    lo_short_text->set_property( iv_attr_name   = 'LANGU'    iv_value = sy-langu ).
    lr_item_handler->create_ip( lo_first ).
    lo_first = lr_col->get_next( ).
  ENDWHILE.
ENDDO.

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