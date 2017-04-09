*&---------------------------------------------------------------------*
*& Report  ZHANA_PRODUCT_SEARCH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zgenerate_ip.

" this report create a series of product based on template product
PARAMETERS: prod TYPE comm_product-product_id OBLIGATORY DEFAULT 'MEETMYFRIENDTOM',
            num  TYPE i.

DATA: lo_core                TYPE REF TO cl_crm_bol_core,
      lo_collection          TYPE REF TO if_bol_entity_col,
      lv_query_name          TYPE crmt_ext_obj_name,
      lt_reltype_filter      TYPE comt_il_reltype_tab,
      lv_product_id          TYPE comm_product-product_id,
      lt_selection_parameter TYPE genilt_selection_parameter_tab,
      ls_selection_parameter TYPE genilt_selection_parameter,
      ls_query_parameters    TYPE genilt_query_parameters.

lv_query_name = 'ProdAdvSearchRgProducts'.
CLEAR: lt_selection_parameter.
ls_selection_parameter-attr_name = 'PRODUCT_ID'.
ls_selection_parameter-option =  'EQ'.
ls_selection_parameter-sign = 'I'.
ls_selection_parameter-low =  prod.
APPEND ls_selection_parameter TO lt_selection_parameter.
lo_core = cl_crm_bol_core=>get_instance( ).
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
  WRITE:/ 'IP Generated Successfully'.
ELSE.
  lo_transaction->rollback( ).
  WRITE: / 'IP Generated failed'.
ENDIF.