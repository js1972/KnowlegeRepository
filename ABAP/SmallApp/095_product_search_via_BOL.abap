*&---------------------------------------------------------------------*
*& Report  ZHANA_PRODUCT_SEARCH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  ZSAT_PRODUCT_SEARCH.

PARAMETERS: po_id type comm_product-product_id,
            maxhit type i.

DATA: lo_core               TYPE REF TO cl_crm_bol_core,
      lo_collection         TYPE REF TO if_bol_entity_col,
      lo_root_entity        TYPE REF TO cl_crm_bol_entity,
      lv_view_name          TYPE crmt_view_name,
      lv_query_name         TYPE crmt_ext_obj_name VALUE 'ProdAdvancedSearchProducts',
      lt_query_parameter    TYPE crmt_name_value_pair_tab.

START-OF-SELECTION.

  SHIFT po_id RIGHT DELETING TRAILING space.
  IF po_id NE space.
    DATA(ls_query_parameter) = VALUE crmt_name_value_pair( name = 'PRODUCT_ID' value = po_id ).
    APPEND ls_query_parameter TO lt_query_parameter.
  ENDIF.

  IF maxhit EQ space.
    maxhit = 100.
  ENDIF.

  ls_query_parameter = VALUE #( name = 'MAX_ROWS' value = maxhit ).
  APPEND ls_query_parameter TO lt_query_parameter.

  lo_core = cl_crm_bol_core=>get_instance( ).
  lo_core->load_component_set( 'PROD_ALL' ).

  lo_collection = lo_core->query(
      iv_query_name               = lv_query_name
      it_query_params             = lt_query_parameter
      iv_view_name                = lv_view_name ).

  DATA(lv_size) = lo_collection->IF_BOL_BO_COL~SIZE( ).

  WRITE:/ 'Number of ' , lv_size, ' Products has been found!'.