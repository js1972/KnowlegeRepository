class ZCL_CRM_OFFLINE_PRODUCT_TOOL definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_origin,
        orderadm_i TYPE crmt_orderadm_i_wrkt,
        product_i  TYPE crmt_product_i_wrkt,
        schedlin_i TYPE crmt_schedlin_i_wrkt,
        price_i    TYPE crmt_pricing_i_wrkt,
        price      TYPE crmt_pricing_wrkt,

      END OF ty_origin .
  types:
    BEGIN OF ty_opt_line,
             guid             TYPE crmd_orderadm_i-guid,
             header           TYPE crmd_orderadm_i-header,
             product          TYPE crmd_orderadm_i-product,
             ordered_prod     TYPE crmd_orderadm_i-ordered_prod,
             description      TYPE crmd_orderadm_i-description,
             process_qty_unit TYPE crmd_product_i-process_qty_unit,
             prod_hierarchy   TYPE crmd_product_i-prod_hierarchy,
             quantity         TYPE crmd_schedlin-quantity,
             net_value        TYPE crmd_pricing_i-net_value,
             net_value_man    TYPE crmd_pricing_i-net_value_man,
             currency         TYPE crmd_pricing-currency,
           END OF ty_opt_line .
  types:
    BEGIN OF ty_opt,
             data TYPE STANDARD TABLE OF ty_opt_line WITH KEY guid,
           END OF ty_opt .

  methods GET_ORDER_CURRENCY
    importing
      !IV_ORDER_GUID type CRMT_OBJECT_GUID
    returning
      value(RV_CURRENCY) type CRMD_PRICING-CURRENCY .
  methods COMPARE
    importing
      !IS_ORIGIN type TY_ORIGIN
      !IS_OPT type TY_OPT
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods CONSTRUCTOR
    importing
      !IV_TEST_NUMBER type I optional .
  methods GET_EXPAND_PROD_BY_GUID_ORIGIN
    importing
      !IV_GUID type CRMT_OBJECT_GUID
    returning
      value(RS_EXPANDED) type CRMT_ODATA_OPPT_HDR_EXPANDED .
  methods START .
  methods STOP
    importing
      !IV_MESSAGE type STRING optional .
  methods GET_ITEM_DATA_ORIGIN
    importing
      !IT_HEADER_GUID_TAB type CRMT_OBJECT_GUID_TAB optional
    returning
      value(ES_DATA) type TY_ORIGIN .
  methods GET_ITEM_DATA_OPT
    importing
      !IT_HEADER_GUID_TAB type CRMT_OBJECT_GUID_TAB optional
    returning
      value(ES_DATA) type TY_OPT .
  PROTECTED SECTION.
private section.

  data MV_START type INT4 .
  data MV_END type I .
  constants GC_ORDERADM_I type CRMT_OBJECT_NAME value 'ORDERADM_I' ##NO_TEXT.
  constants GC_PRICING type CRMT_OBJECT_NAME value 'PRICING' ##NO_TEXT.
  constants GC_PRICING_I type CRMT_OBJECT_NAME value 'PRICING_I' ##NO_TEXT.
  constants GC_PRODUCT_I type CRMT_OBJECT_NAME value 'PRODUCT_I' ##NO_TEXT.
  constants GC_SCHEDLIN_I type CRMT_OBJECT_NAME value 'SCHEDLIN_I' ##NO_TEXT.
  data MT_TEST_GUID_TAB type CRMT_OBJECT_GUID_TAB .

  methods GET_TEST_DATA
    returning
      value(RT_DATA) type CRMT_OBJECT_GUID_TAB .
  methods GET_EXPAND_NODE
    returning
      value(RO_NODE) type ref to /IWBEP/CL_MGW_EXPAND_NODE .
  methods COMPARE_ADMIN_I
    importing
      !IS_ORIGIN type TY_ORIGIN
      !IS_OPT type TY_OPT
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods COMPARE_FIELD
    importing
      !IV_STRU1 type ANY
      !IV_STRU2 type ANY
      !IV_FIELD type STRING
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods COMPARE_PRODUCT_I
    importing
      !IS_ORIGIN type TY_ORIGIN
      !IS_OPT type TY_OPT
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods COMPARE_SCHEDULE_I
    importing
      !IS_ORIGIN type TY_ORIGIN
      !IS_OPT type TY_OPT
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods COMPARE_PRICE_I
    importing
      !IS_ORIGIN type TY_ORIGIN
      !IS_OPT type TY_OPT
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods COMPARE_PRICE
    importing
      !IS_ORIGIN type TY_ORIGIN
      !IS_OPT type TY_OPT
    returning
      value(RV_EQUAL) type ABAP_BOOL .
ENDCLASS.



CLASS ZCL_CRM_OFFLINE_PRODUCT_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->COMPARE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ORIGIN                      TYPE        TY_ORIGIN
* | [--->] IS_OPT                         TYPE        TY_OPT
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare.

    CHECK lines( is_origin-orderadm_i ) = lines( is_opt-data ).

    CHECK compare_admin_i(    is_origin = is_origin is_opt = is_opt ) = abap_true.
    CHECK compare_product_i(  is_origin = is_origin is_opt = is_opt ) = abap_true.
    CHECK compare_schedule_i( is_origin = is_origin is_opt = is_opt ) = abap_true.
    CHECK compare_price_i(    is_origin = is_origin is_opt = is_opt ) = abap_true.
    CHECK compare_price(      is_origin = is_origin is_opt = is_opt ) = abap_true.

    rv_equal = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->COMPARE_ADMIN_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ORIGIN                      TYPE        TY_ORIGIN
* | [--->] IS_OPT                         TYPE        TY_OPT
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare_admin_i.

    LOOP AT is_origin-orderadm_i ASSIGNING FIELD-SYMBOL(<origin>).
      READ TABLE is_opt-data ASSIGNING FIELD-SYMBOL(<opt>)
        WITH KEY guid = <origin>-guid.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'HEADER' ) = abap_false.
        RETURN.
      ENDIF.

      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'PRODUCT' ) = abap_false.
        RETURN.
      ENDIF.

      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'ORDERED_PROD' ) = abap_false.
        RETURN.
      ENDIF.

      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'DESCRIPTION' ) = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

    rv_equal = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->COMPARE_FIELD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_STRU1                       TYPE        ANY
* | [--->] IV_STRU2                       TYPE        ANY
* | [--->] IV_FIELD                       TYPE        STRING
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare_field.
    FIELD-SYMBOLS: <value1> TYPE any,
                   <value2> TYPE any.

    ASSIGN COMPONENT iv_field OF STRUCTURE iv_stru1 TO <value1>.
    ASSIGN COMPONENT iv_field OF STRUCTURE iv_stru2 TO <value2>.

    IF <value1> = <value2>.
      rv_equal = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->COMPARE_PRICE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ORIGIN                      TYPE        TY_ORIGIN
* | [--->] IS_OPT                         TYPE        TY_OPT
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare_price.

    TYPES: BEGIN OF ty_price,
       guid TYPE crmt_object_guid,
       currency TYPE crmd_pricing-currency,
           END OF ty_price.

    TYPES: tt_price TYPE STANDARD TABLE OF ty_price WITH KEY guid.

    DATA: lt_price TYPE tt_price,
          lt_links TYPE STANDARD TABLE OF crmd_link.

    MOVE-CORRESPONDING is_origin-price TO lt_price.

    SORT lt_price.
    DELETE ADJACENT DUPLICATES FROM lt_price COMPARING guid.

    SELECT guid_hi guid_set INTO CORRESPONDING FIELDS OF TABLE lt_links FROM crmd_link
       FOR ALL ENTRIES IN lt_price
       WHERE guid_set = lt_price-guid AND objtype_hi = '05' " order Header
       AND objtype_set = '09'. " pricing set

   LOOP AT is_opt-data ASSIGNING FIELD-SYMBOL(<opt>) WHERE currency IS NOT INITIAL.
      READ TABLE lt_links ASSIGNING FIELD-SYMBOL(<links>) WITH KEY
         guid_hi = <opt>-header.
      IF sy-subrc <> 0.
         RETURN.
      ENDIF.

      READ TABLE lt_price ASSIGNING FIELD-SYMBOL(<price>) WITH KEY
         guid = <links>-guid_set.
      IF sy-subrc <> 0.
         RETURN.
      ENDIF.

      IF <price>-currency <> <opt>-currency.
         RETURN.
      ENDIF.
*    LOOP AT is_origin-price ASSIGNING FIELD-SYMBOL(<origin>).
*      READ TABLE is_opt-data ASSIGNING FIELD-SYMBOL(<opt>)
*        WITH KEY guid = <origin>-guid.
*      IF sy-subrc <> 0.
*        RETURN.
*      ENDIF.
*
*      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'CURRENCY' ) = abap_false.
*        RETURN.
*      ENDIF.
*    ENDLOOP.
   ENDLOOP.
    rv_equal = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->COMPARE_PRICE_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ORIGIN                      TYPE        TY_ORIGIN
* | [--->] IS_OPT                         TYPE        TY_OPT
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare_price_i.

    LOOP AT is_origin-price_i ASSIGNING FIELD-SYMBOL(<origin>).
      READ TABLE is_opt-data ASSIGNING FIELD-SYMBOL(<opt>)
        WITH KEY guid = <origin>-guid.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'NET_VALUE' ) = abap_false.
        RETURN.
      ENDIF.

      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'NET_VALUE_MAN' ) = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

    rv_equal = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->COMPARE_PRODUCT_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ORIGIN                      TYPE        TY_ORIGIN
* | [--->] IS_OPT                         TYPE        TY_OPT
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare_product_i.

    LOOP AT is_origin-product_i ASSIGNING FIELD-SYMBOL(<origin>).
      READ TABLE is_opt-data ASSIGNING FIELD-SYMBOL(<opt>)
        WITH KEY guid = <origin>-guid.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'PROCESS_QTY_UNIT' ) = abap_false.
        RETURN.
      ENDIF.

      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'PROD_HIERARCHY' ) = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

    rv_equal = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->COMPARE_SCHEDULE_I
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ORIGIN                      TYPE        TY_ORIGIN
* | [--->] IS_OPT                         TYPE        TY_OPT
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare_schedule_i.

    LOOP AT is_origin-schedlin_i ASSIGNING FIELD-SYMBOL(<origin>).
      READ TABLE is_opt-data ASSIGNING FIELD-SYMBOL(<opt>)
        WITH KEY guid = <origin>-guid.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

*      IF compare_field( iv_stru1 = <origin> iv_stru2 = <opt> iv_field = 'ORDER_QTY' ) = abap_false.
*        RETURN.
*      ENDIF.
      IF <origin>-order_qty <> <opt>-quantity.
        RETURN.
      ENDIF.

    ENDLOOP.

    rv_equal = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TEST_NUMBER                 TYPE        I(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.

    data: lv_count type i.

    IF iv_test_number IS NOT SUPPLIED.
       lv_count = 100.
    ELSE.
       lv_count = iv_test_number.
    ENDIF.
    SELECT guid INTO TABLE mt_test_guid_tab FROM crmd_orderadm_h UP TO lv_count ROWS
    ."   WHERE process_type = 'OPPT'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->GET_EXPAND_NODE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_NODE                        TYPE REF TO /IWBEP/CL_MGW_EXPAND_NODE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_expand_node.
    DATA:
      lo_model       TYPE REF TO /iwbep/if_mgw_odata_fw_model,
      lo_expand_tree TYPE REF TO /iwbep/cl_mgw_expand_tree,
      lo_root        TYPE REF TO /iwbep/cl_mgw_expand_node.

    lo_expand_tree = /iwbep/cl_mgw_expand_tree=>create(
                   iv_entity_set       = 'OpportunityCollection'
                   iv_entity_type      = 'Opportunity'
                   iv_tech_entity_set  = 'OpportunityCollection'
                   iv_tech_entity_type = 'Opportunity'
                   iv_multiplicity     = 'M'
                   iv_expand           = 'PRODUCTS'"'DocumentItems'
                   iv_tech_expand      = 'PRODUCTS'"'DOCUMENTITEMS'
                   io_model            = lo_model ).

    lo_expand_tree->get_root( IMPORTING eo_root = ro_node ).

    "lo_root->get_child( EXPORTING iv_nav_prop_name = 'DocumentItems'
    "                    IMPORTING eo_child = ro_node ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->GET_EXPAND_PROD_BY_GUID_ORIGIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GUID                        TYPE        CRMT_OBJECT_GUID
* | [<-()] RS_EXPANDED                    TYPE        CRMT_ODATA_OPPT_HDR_EXPANDED
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_expand_prod_by_guid_origin.
    DATA: lt_key_tab               TYPE /iwbep/t_mgw_name_value_pair,
          lo_expand                TYPE REF TO /iwbep/cl_mgw_expand_node,
          lt_expanded_clauses      TYPE string_table,
          lt_expanded_tech_clauses TYPE string_table,
          lo_request               TYPE REF TO /iwbep/cl_mgw_request,
          lt_path                  TYPE /iwbep/t_mgw_navigation_path.

    DATA(go_oppt_impl) = NEW cl_crm_opportunity_impl( ).
    DATA(ls_key) = VALUE /iwbep/s_mgw_name_value_pair( name = 'Guid'
       value = iv_guid ).
    APPEND ls_key TO lt_key_tab.
    lo_expand = get_expand_node( ).

    go_oppt_impl->get_oppt_expanded_entity(
      EXPORTING
        iv_entity_name               = space
        iv_entity_set_name           = space
        iv_source_name               = space
        it_key_tab                   = lt_key_tab
        it_navigation_path           = lt_path
        io_expand                    = lo_expand
        io_tech_request_context      = lo_request
      IMPORTING
        et_oppt_expanded             = rs_expanded
        "et_expanded_clauses          = lt_expanded_clauses
        "et_expanded_tech_clauses     = lt_expanded_tech_clauses
    ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->GET_ITEM_DATA_OPT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER_GUID_TAB             TYPE        CRMT_OBJECT_GUID_TAB(optional)
* | [<-()] ES_DATA                        TYPE        TY_OPT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_item_data_opt.

    TYPES: BEGIN OF ty_order_currency,
              guid_hi TYPE crmt_object_guid,
              currency TYPE crmd_pricing-currency,
           END OF ty_order_currency.

    TYPES: tt_order_currency TYPE STANDARD TABLE OF ty_order_currency
               WITH KEY guid_hi.

    DATA: lt_option LIKE it_header_guid_tab,
          lt_order_currency TYPE tt_order_currency.

    lt_option = it_header_guid_tab.
    IF it_header_guid_tab IS NOT SUPPLIED.
      lt_option = get_test_data( ).
    ENDIF.

    SELECT a~guid a~header  a~product a~ordered_prod a~description b~process_qty_unit b~prod_hierarchy
      c~quantity d~net_value d~net_value_man FROM crmd_orderadm_i AS a
      LEFT JOIN crmd_product_i AS b ON a~guid = b~guid
      LEFT JOIN crmd_schedlin AS c ON a~guid  = c~item_guid
      LEFT JOIN crmd_pricing_i AS d ON a~guid = d~guid
      INTO CORRESPONDING FIELDS OF TABLE es_data-data
      FOR ALL ENTRIES IN lt_option WHERE header = lt_option-table_line.

   SELECT a~guid_hi b~currency FROM crmd_link AS a
     LEFT JOIN crmd_pricing AS b ON a~guid_set = b~guid
       INTO TABLE lt_order_currency FOR ALL ENTRIES IN lt_option
       WHERE a~guid_hi = lt_option-table_line AND a~objtype_hi = '05'
      AND a~objtype_set = '09'.

   LOOP AT es_Data-data ASSIGNING FIELD-SYMBOL(<line>).
      READ TABLE lt_order_currency ASSIGNING FIELD-SYMBOL(<order>)
         WITH KEY guid_hi = <line>-header.
      IF sy-subrc = 0.
          <line>-currency = <order>-currency.
      ENDIF.
   ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->GET_ITEM_DATA_ORIGIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER_GUID_TAB             TYPE        CRMT_OBJECT_GUID_TAB(optional)
* | [<-()] ES_DATA                        TYPE        TY_ORIGIN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_item_data_origin.
    DATA: lt_input             TYPE crmt_object_guid_tab,
          lt_requested_objects TYPE crmt_object_name_tab,
          lt_orderadm_i        TYPE crmt_orderadm_i_wrkt,
          lt_product_i         TYPE crmt_product_i_wrkt,
          lt_price_i           TYPE crmt_pricing_i_wrkt,
          lt_price             TYPE crmt_pricing_wrkt,
          lt_schedlin_i        TYPE crmt_schedlin_i_wrkt,
          lt_option            LIKE lt_input.

    lt_option = it_header_guid_tab.
    IF it_header_guid_tab IS NOT SUPPLIED.
      lt_option = get_test_data( ).
    ENDIF.

    LOOP AT lt_option ASSIGNING FIELD-SYMBOL(<guid>).
      CLEAR: lt_input, lt_requested_objects,lt_orderadm_i, lt_product_i,lt_schedlin_i,
             lt_price_i, lt_price.

      APPEND <guid> TO lt_input.
      INSERT gc_orderadm_i INTO TABLE lt_requested_objects.
      INSERT gc_product_i INTO TABLE lt_requested_objects.
      INSERT gc_schedlin_i INTO TABLE lt_requested_objects.
      INSERT gc_pricing_i INTO TABLE lt_requested_objects.
      INSERT gc_pricing INTO TABLE lt_requested_objects.

      CALL FUNCTION 'CRM_ORDER_READ'
        EXPORTING
          it_header_guid       = lt_input
          it_requested_objects = lt_requested_objects
        IMPORTING
          et_orderadm_i        = lt_orderadm_i
          et_product_i         = lt_product_i
          et_pricing           = lt_price
          et_pricing_i         = lt_price_i
          et_schedlin_i        = lt_schedlin_i
        EXCEPTIONS
          document_not_found   = 1
          error_occurred       = 2
          document_locked      = 3
          no_change_authority  = 4
          no_display_authority = 5
          no_change_allowed    = 6
          OTHERS               = 7.
      IF lt_orderadm_i IS NOT INITIAL.
        INSERT LINES OF lt_orderadm_i INTO TABLE es_data-orderadm_i.
      ENDIF.

      IF lt_product_i IS NOT INITIAL.
        INSERT LINES OF lt_product_i INTO TABLE es_data-product_i.
      ENDIF.

      IF lt_schedlin_i IS NOT INITIAL.
        INSERT LINES OF lt_schedlin_i INTO TABLE es_data-schedlin_i.
      ENDIF.

      IF lt_price_i IS NOT INITIAL.
        INSERT LINES OF lt_price_i INTO TABLE es_data-price_i.
      ENDIF.

      IF lt_price IS NOT INITIAL.
        INSERT LINES OF lt_price INTO TABLE es_Data-price.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->GET_ORDER_CURRENCY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ORDER_GUID                  TYPE        CRMT_OBJECT_GUID
* | [<-()] RV_CURRENCY                    TYPE        CRMD_PRICING-CURRENCY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_ORDER_CURRENCY.
    data: lv_price_guid TYPE crmt_object_guid.

    SELECT SINGLE guid_set INTO lv_price_guid FROM crmd_link
       WHERE guid_hi = iv_order_guid AND objtype_hi = '05' " order Header
       AND objtype_set = '09'. " pricing set

    CHECK sy-subrc = 0.

    SELECT SINGLE currency INTO rv_currency FROM crmd_pricing
       WHERE guid = lv_price_guid.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->GET_TEST_DATA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        CRMT_OBJECT_GUID_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_test_data.
    rt_data = mt_test_guid_tab.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->START
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD start.
    GET RUN TIME FIELD mv_start.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_OFFLINE_PRODUCT_TOOL->STOP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MESSAGE                     TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD stop.
    GET RUN TIME FIELD mv_end.

    mv_end = mv_end - mv_start.

    DATA: lv_text TYPE string.

    IF iv_message IS SUPPLIED.
      lv_text = iv_message.
    ENDIF.

    lv_text = lv_text && ' consumed time: ' && mv_end.

    WRITE: / lv_text COLOR COL_NEGATIVE.
  ENDMETHOD.
ENDCLASS.