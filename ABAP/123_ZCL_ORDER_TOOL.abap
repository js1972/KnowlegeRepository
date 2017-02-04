class ZCL_ORDER_TOOL definition
  public
  final
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_OPPT_ITEM_PROD_CAT_ID
    importing
      !IV_OPPT_ID type CRMT_OBJECT_ID default '2036'
      !IV_PROCESS_TYPE type CRMT_PROCESS_TYPE_DB default 'OPPT'
    returning
      value(EV_PROD_CAT_ID) type CRMT_PROD_HIERARCHY .
  class-methods GET_OPPT_ITEM_PROD_CAT_ID2
    importing
      !IV_OPPT_ID type CRMT_OBJECT_ID default '2036'
      !IV_PROCESS_TYPE type CRMT_PROCESS_TYPE_DB default 'OPPT'
    returning
      value(EV_PROD_CAT_ID) type CRMT_PROD_HIERARCHY .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA so_core TYPE REF TO cl_crm_bol_core .
ENDCLASS.



CLASS ZCL_ORDER_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_ORDER_TOOL=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_constructor.

    so_core = cl_crm_bol_core=>get_instance( ).
    so_core->load_component_set( 'BT' ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_ORDER_TOOL=>GET_OPPT_ITEM_PROD_CAT_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OPPT_ID                     TYPE        CRMT_OBJECT_ID (default ='2036')
* | [--->] IV_PROCESS_TYPE                TYPE        CRMT_PROCESS_TYPE_DB (default ='OPPT')
* | [<-()] EV_PROD_CAT_ID                 TYPE        CRMT_PROD_HIERARCHY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_oppt_item_prod_cat_id.
    DATA:
      lo_collection      TYPE REF TO if_bol_entity_col,
      lv_view_name       TYPE crmt_view_name,
      lv_query_name      TYPE crmt_ext_obj_name,
      ls_parameter       TYPE genilt_query_parameters,
      lt_query_parameter TYPE genilt_selection_parameter_tab,
      ls_query_parameter LIKE LINE OF lt_query_parameter.

    ls_query_parameter-attr_name = 'OBJECT_ID'.
    ls_query_parameter-low = iv_oppt_id.
    ls_query_parameter-option = 'EQ'.
    ls_query_parameter-sign = 'I'.
    APPEND ls_query_parameter TO lt_query_parameter.

    ls_query_parameter-attr_name = 'PROCESS_TYPE'.
    ls_query_parameter-low = iv_process_type.
    ls_query_parameter-option = 'EQ'.
    ls_query_parameter-sign = 'I'.
    APPEND ls_query_parameter TO lt_query_parameter.

    so_core = cl_crm_bol_core=>get_instance( ).
    so_core->load_component_set( 'BT' ).
    lv_query_name = 'BTQ1Order'.

    DATA(lo_result) = so_core->dquery(
        iv_query_name               = lv_query_name
        is_query_parameters         = ls_parameter
        it_selection_parameters             = lt_query_parameter
        iv_view_name                = lv_view_name ).

    CHECK lo_result->size( ) = 1.
    DATA(lo_order_result) = lo_result->get_first( ).

    DATA(lo_bt_order) = lo_order_result->get_related_entity( 'BTADVS1Ord' ).
    CHECK lo_bt_order IS NOT INITIAL.

    DATA(lo_header) = lo_bt_order->get_related_entity( 'BTOrderHeader' ).

    CHECK lo_header IS NOT INITIAL.

    DATA(lo_items) = lo_header->get_related_entities( iv_relation_name = 'BTHeaderItemsExt' ).
    CHECK lo_items->size( ) = 1.

    DATA(lo_item) = lo_items->get_first( ).

    DATA(lo_admini) = lo_item->get_related_entity( 'BTItemsFirstLevel' ).
    CHECK lo_admini IS NOT INITIAL.

    DATA(lo_product) = lo_admini->get_related_entity( 'BTItemProductExt' ).

    CHECK lo_product IS NOT INITIAL.
    EV_PROD_CAT_ID = lo_product->get_property_as_string( 'PROD_HIERARCHY' ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_ORDER_TOOL=>GET_OPPT_ITEM_PROD_CAT_ID2
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OPPT_ID                     TYPE        CRMT_OBJECT_ID (default ='2036')
* | [--->] IV_PROCESS_TYPE                TYPE        CRMT_PROCESS_TYPE_DB (default ='OPPT')
* | [<-()] EV_PROD_CAT_ID                 TYPE        CRMT_PROD_HIERARCHY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD GET_OPPT_ITEM_PROD_CAT_ID2.
    select single prod_hierarchy into EV_PROD_CAT_ID FROM crmd_product_i as prod
        INNER JOIN crmd_orderadm_i as item ON prod~guid = item~guid
        INNER JOIN crmd_orderadm_h as order ON item~header = order~guid
        WHERE order~object_id = iv_oppt_id and order~process_type = IV_PROCESS_TYPE.
  ENDMETHOD.
ENDCLASS.