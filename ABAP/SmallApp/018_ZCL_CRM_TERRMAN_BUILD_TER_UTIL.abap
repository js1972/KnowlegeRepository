class ZCL_CRM_TERRMAN_BUILD_TER_UTIL definition
  public
  final
  create public .

public section.

  interfaces ZIF_CRM_TERR_VALUEPAIR_BUILDER .

  class-methods RUN
    importing
      !IT_TERR_GUID type CRMT_TERRITORY_GUID_TAB
      !IT_LINK type CRMT_TERR_LINK_T
    exporting
      !ET_TERRATTRIB type CRMT_TERRATTRIB_TAB
      !ET_TERRATTRIB_DATES type CRMT_TERRATTRIB_DATES_TAB
    changing
      !CT_ERRORS type BAPIRET2_T .
protected section.
private section.

  types:
    tt_rule_attr type TABLE OF crms_fdt_create_ctxt .
  types:
    tt_rule_data type TABLE OF crms_fdt_rule_cell .

  class-data MV_TERRITORY_GUID type CRMT_TERRITORY_GUID .
  class-data MV_TERRITORY_V_GUID type CRMT_OBJECT_GUID .
  class-data MT_TERRATTR_BW type CRMT_TERRATTR_BW_T .
  class-data MV_RULE_ID type CRMDT_FDT_GUID .
  class-data MT_RULE_ATTR type TT_RULE_ATTR .
  class-data MT_RULE_DATA type TT_RULE_DATA .
  class-data MT_BP_BRICK type CRMT_TERR_RANGE_T .
  class-data MT_BP_COUNTRY type CRMT_TERR_RANGE_T .
  class-data MT_BP_REGION type CRMT_TERR_RANGE_T .
  class-data MT_BP_POST_CODE type CRMT_TERR_RANGE_T .
  class-data MT_BP_GROUP type CRMT_TERR_RANGE_T .
  class-data MT_BP_SUBGROUP type CRMT_TERR_RANGE_T .
  class-data MT_BP_MAIN type CRMT_TERR_RANGE_T .
  class-data MT_BP_PARTNER type WFDST_PARTNER_RANGES_TAB .
  class-data mv_valid_from TYPE CRM_TERRMAN_VALID_FROM.
  class-data mv_valid_to TYPE CRM_TERRMAN_VALID_TO.
  class-data MV_CUST_TERRATTRIB type EXIT_DEF value 'CRM_TERRMAN_ATTRIB'. "#EC NOTEXT .  .  .  .  . " .
  class-data:
    mt_bp_node_guid_tab TYPE TABLE OF STRING .
  class-data MT_CATEGORY_ID type COMT_PR_CATEGORY_RANGE_TAB .
  class-data MT_CAT_ID type COMT_PR_CATEGORY_RANGE_TAB .
  class-data MT_HIER_ID type COMT_HIERARCHY_ID_RANGE_TAB .
  class-data MT_HIERARCHY_ID type COMT_HIERARCHY_ID_RANGE_TAB .
  class-data:
    mt_sales_area TYPE TABLE OF string .
  class-data MT_RULE_CUSTATTR_BP type CRMT_RULE_ATTRIBUTES .
  class-data:
    mt_valuepair TYPE TABLE OF crmt_tmil_ui .
  class-data MT_ERRORS type BAPIRET2_T .
  class-data MT_TERRATTRIB_ALL type CRMT_TERRATTRIB_TAB .

  class-methods POST_HANDLING
    exporting
      !ET_TERRATTRIB type CRMT_TERRATTRIB_TAB
      !ET_TERRATTRIB_DATES type CRMT_TERRATTRIB_DATES_TAB
      !ET_ERRORS type BAPIRET2_T .
  class-methods LOOP_RULEATTRIB_FINALCP
    importing
      !IT_ATTRIB_FINALCP type CRMT_RULE_ATTRIBUTES
      !IT_ATTRIB_FINAL type CRMT_RULE_ATTRIBUTES .
  class-methods INIT
    importing
      !IT_TERR_GUID type CRMT_TERRITORY_GUID_TAB
      !IT_LINK type CRMT_TERR_LINK_T .
  class-methods GET_RULEATTRIB_FINAL_TABLE
    returning
      value(RT_TABLE) type CRMT_RULE_ATTRIBUTES .
  class-methods LOOP_RULEATTRIB_ROW
    importing
      !IT_ATTRIB_ROW type CRMT_RULE_ATTRIBUTES
      !IT_ATTRIB_FINAL type CRMT_RULE_ATTRIBUTES
      !IT_ATTRIB_FINALCP type CRMT_RULE_ATTRIBUTES .
  class-methods BUILD_TERR_RANGE_TABLE
    importing
      !IV_RULE_ATTR type CRMS_RULE_ATTRIBUTES .
  class-methods APPEND_VALUE_PAIR
    importing
      !IV_RULE_ATTR type CRMS_RULE_ATTRIBUTES
      !IT_ATTRIB_FINAL type CRMT_RULE_ATTRIBUTES .
  class-methods GET_TERRATTRIB_ALL .
  class-methods CLEANUP .
ENDCLASS.



CLASS ZCL_CRM_TERRMAN_BUILD_TER_UTIL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>APPEND_VALUE_PAIR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RULE_ATTR                   TYPE        CRMS_RULE_ATTRIBUTES
* | [--->] IT_ATTRIB_FINAL                TYPE        CRMT_RULE_ATTRIBUTES
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method APPEND_VALUE_PAIR.

    CASE iv_rule_attr-attribute_id.
      WHEN 'BP_BRICK'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_bp_brick( ).
      WHEN 'BP_COUNTRY'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_bp_country( ).
      WHEN 'BP_REGION'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_bp_region( ).
      WHEN 'BP_POST_CODE'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_bp_postcode( ).
      WHEN 'BP_GROUP'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_bp_group( ).
      WHEN 'BP_SUBGROUP'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_bp_subgroup( ).
      WHEN 'BP_GUID'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_bp_guid( EXPORTING it_attrib_final = it_attrib_final ).
      WHEN 'BP_MAIN_SPEC'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_bp_mainspec( ).
      WHEN 'BP_NODE_GUID'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_bp_node_guid( ).
      WHEN 'PM_CATEGORY'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_pm_category( ).
      WHEN 'PM_CATEGORY_GUID'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_pm_category_guid( ).
      WHEN 'PM_HIERARCHYGUID'.
         ZIF_CRM_TERR_VALUEPAIR_BUILDER~build_pm_hierarchy_guid( ).
      WHEN OTHERS.
    ENDCASE.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>BUILD_TERR_RANGE_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RULE_ATTR                   TYPE        CRMS_RULE_ATTRIBUTES
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method BUILD_TERR_RANGE_TABLE.

    DATA: ls_range           TYPE CRMS_TERRMAN_RANGE,
          ls_bp_partner       TYPE LINE OF wfdst_partner_ranges_tab,
          ls_category_id      TYPE LINE OF comt_pr_category_range_tab,
          ls_cat_id           LIKE LINE OF mt_cat_id,
          ls_hier_id          LIKE LINE OF mt_hier_id,
          ls_hierarchy_id     LIKE LINE OF mt_hierarchy_id,
          lr_ref              TYPE REF TO if_ex_crm_terrman_attrib,
          lv_cust_terrattrib  TYPE exit_def VALUE 'CRM_TERRMAN_ATTRIB',
          lt_cust_attr        TYPE  crmt_terr_range_t,
          lt_cust_attrval     TYPE  crmt_terr_rule_attr,
          ls_cust_attr        LIKE LINE OF lt_cust_attr,
          ls_cust_attrval     LIKE LINE OF lt_cust_attrval,
          ls_valuepair        LIKE LINE OF mt_valuepair.

    IF iv_rule_attr-lvalue IS INITIAL AND iv_rule_attr-hvalue IS INITIAL.
       RETURN.
    ENDIF.

    CASE iv_rule_attr-attribute_id.
      WHEN 'BP_BRICK'.
         ls_range-sign   = iv_rule_attr-sign.
         ls_range-option = iv_rule_attr-option.
         ls_range-low    = iv_rule_attr-lvalue.
         ls_range-high   = iv_rule_attr-hvalue.
         APPEND  ls_range TO mt_bp_brick.
      WHEN 'BP_COUNTRY'.
         ls_range-sign   = iv_rule_attr-sign.
         ls_range-option = iv_rule_attr-option.
         ls_range-low    = iv_rule_attr-lvalue.
         ls_range-high   = iv_rule_attr-hvalue.
         APPEND  ls_range TO mt_bp_country.
      WHEN 'BP_REGION'.
         ls_range-sign   = iv_rule_attr-sign.
         ls_range-option = iv_rule_attr-option.
         ls_range-low    = iv_rule_attr-lvalue.
         ls_range-high   = iv_rule_attr-hvalue.
         APPEND  ls_range TO mt_bp_region.
      WHEN 'BP_POST_CODE'.
         ls_range-sign   = iv_rule_attr-sign.
         ls_range-option = iv_rule_attr-option.
         ls_range-low    = iv_rule_attr-lvalue.
         ls_range-high   = iv_rule_attr-hvalue.
         APPEND  ls_range TO mt_bp_post_code.
      WHEN 'BP_GROUP'.
         ls_range-sign   = iv_rule_attr-sign.
         ls_range-option = iv_rule_attr-option.
         ls_range-low    = iv_rule_attr-lvalue.
         ls_range-high   = iv_rule_attr-hvalue.
         APPEND  ls_range TO mt_bp_group.
      WHEN 'BP_SUBGROUP'.
         ls_range-sign   = iv_rule_attr-sign.
         ls_range-option = iv_rule_attr-option.
         ls_range-low    = iv_rule_attr-lvalue.
         ls_range-high   = iv_rule_attr-hvalue.
         APPEND  ls_range TO mt_bp_subgroup.
      WHEN 'BP_GUID'.
         ls_bp_partner-sign   = iv_rule_attr-sign.
         ls_bp_partner-option = iv_rule_attr-option.
         ls_bp_partner-low    = iv_rule_attr-lvalue.
         ls_bp_partner-high   = iv_rule_attr-hvalue.
         APPEND  ls_bp_partner TO mt_bp_partner.
      WHEN 'BP_MAIN_SPEC'.
         ls_range-sign   = iv_rule_attr-sign.
         ls_range-option = iv_rule_attr-option.
         ls_range-low    = iv_rule_attr-lvalue.
         ls_range-high   = iv_rule_attr-hvalue.
         APPEND  ls_range TO mt_bp_main.
      WHEN 'BP_NODE_GUID'.
         APPEND iv_rule_attr-lvalue TO mt_bp_node_guid_tab.
      WHEN 'PM_CATEGORY'.
         ls_category_id-sign   = iv_rule_attr-sign.
         ls_category_id-option = iv_rule_attr-option.
         ls_category_id-low    = iv_rule_attr-lvalue.
         ls_category_id-high   = iv_rule_attr-hvalue.
         APPEND ls_category_id TO mt_category_id.
      WHEN 'PM_CATEGORY_GUID'.
         ls_cat_id-sign    = iv_rule_attr-sign.
         ls_cat_id-option  = iv_rule_attr-option.
         ls_hier_id-sign   = iv_rule_attr-sign.
         ls_hier_id-option = iv_rule_attr-option.
         IF iv_rule_attr-lvalue IS NOT INITIAL.
            SPLIT iv_rule_attr-lvalue AT ':' INTO  ls_hier_id-low ls_cat_id-low.
            SHIFT ls_cat_id-low BY 1 PLACES LEFT.
         ENDIF.
         IF iv_rule_attr-hvalue IS NOT INITIAL.
            SPLIT iv_rule_attr-hvalue AT ':' INTO  ls_hier_id-high ls_cat_id-high.
            SHIFT ls_cat_id-high BY 1 PLACES LEFT.
         ENDIF.
         APPEND ls_cat_id  TO mt_cat_id.
         APPEND ls_hier_id TO mt_hier_id.
      WHEN 'PM_HIERARCHYGUID'.
         ls_hierarchy_id-sign   = iv_rule_attr-sign.
         ls_hierarchy_id-option = iv_rule_attr-option.
         ls_hierarchy_id-low    = iv_rule_attr-lvalue.
         ls_hierarchy_id-high   = iv_rule_attr-hvalue.
         APPEND ls_hierarchy_id TO mt_hierarchy_id.
      WHEN 'SA_SALES_AREA'.
         APPEND iv_rule_attr-lvalue TO mt_sales_area.

      WHEN OTHERS.
         APPEND iv_rule_attr TO mt_rule_custattr_bp.

         CALL METHOD cl_exithandler=>get_instance
            EXPORTING
              exit_name              = lv_cust_terrattrib
              null_instance_accepted = 'X'
            CHANGING
                  instance               = lr_ref.
         CHECK lr_ref IS NOT INITIAL.

         IF iv_rule_attr-lvalue IS INITIAL AND iv_rule_attr-hvalue IS INITIAL.
            RETURN.
         ENDIF.

         ls_cust_attr-sign   = iv_rule_attr-sign.
         ls_cust_attr-option = iv_rule_attr-option.
         ls_cust_attr-low    = iv_rule_attr-lvalue.
         ls_cust_attr-high   = iv_rule_attr-hvalue.
         APPEND  ls_cust_attr TO lt_cust_attr.

         CALL METHOD lr_ref->get_customer_attrval
            EXPORTING
              iv_attr_name   = iv_rule_attr-attribute_id
              it_value_range = lt_cust_attr
            IMPORTING
              et_attr_values = lt_cust_attrval.
         LOOP AT lt_cust_attrval INTO ls_cust_attrval.
             ls_valuepair-attribute = ls_cust_attrval-attribute_id.
             ls_valuepair-value = ls_cust_attrval-value.
             APPEND ls_valuepair TO mt_valuepair.
         ENDLOOP.

      ENDCASE.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>CLEANUP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CLEANUP.
    CLEAR: mt_valuepair,
           mt_bp_brick,
           mt_bp_country,
           mt_bp_region,
           mt_bp_post_code,
           mt_bp_group,
           mt_bp_subgroup,
           mt_bp_partner,
           mt_bp_main,
           mt_bp_node_guid_tab,
           mt_category_id,
           mt_cat_id,
           mt_hier_id,
           mt_hierarchy_id,
           mt_sales_area,
           mt_rule_custattr_bp.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>GET_RULEATTRIB_FINAL_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_TABLE                       TYPE        CRMT_RULE_ATTRIBUTES
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_RULEATTRIB_FINAL_TABLE.

    FIELD-SYMBOLS: <rule_data> LIKE LINE OF mt_rule_data.
    DATA: ls_rule_attr   LIKE LINE OF mt_rule_attr,
          lt_ruleattrib  TYPE crmt_rule_attributes,
          ls_ruleattrib  LIKE LINE OF lt_ruleattrib,
          lt_condition   TYPE crmt_fdt_rule_condition,
          ls_condition   LIKE LINE OF lt_condition.

    LOOP AT mt_rule_data ASSIGNING <rule_data>.

      READ TABLE mt_rule_attr INTO ls_rule_attr WITH KEY col_no = <rule_data>-col_no.

      ls_ruleattrib-rule_id      = mv_rule_id.
      ls_ruleattrib-row_no       = <rule_data>-row_no.
      ls_ruleattrib-attribute_id = ls_rule_attr-attribute.
      lt_condition                = <rule_data>-conditions.

***   Loop at conditions tab to populate condition field values
      LOOP AT lt_condition INTO ls_condition.

        ls_ruleattrib-sign   = ls_condition-sign.
        ls_ruleattrib-option = ls_condition-option.
        ls_ruleattrib-lvalue = ls_condition-lvalue-value.
        ls_ruleattrib-hvalue = ls_condition-hvalue-value.
        APPEND ls_ruleattrib TO lt_ruleattrib.
      ENDLOOP.
    ENDLOOP.

    INSERT LINES OF lt_ruleattrib INTO TABLE rt_table.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>GET_TERRATTRIB_ALL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_TERRATTRIB_ALL.
    DATA: ls_valuepair  LIKE LINE OF mt_valuepair,
          lt_terrattrib TYPE crmt_terrattrib_tab.

    LOOP AT mt_valuepair INTO ls_valuepair WHERE attribute = 'PM_HIERARCHYGUID' .
        ls_valuepair-attribute = 'PM_HIERARCHY' .
        MODIFY mt_valuepair FROM ls_valuepair INDEX sy-tabix.
    ENDLOOP.

    IF mt_valuepair IS NOT INITIAL.
        CALL FUNCTION 'CRM_TERRMAN_UI_ATTR_CONVERT_TM'
          TABLES
            ct_valuepair  = mt_valuepair
            ct_terrattrib = lt_terrattrib.
        " performance can be improved in below logics
        APPEND LINES OF lt_terrattrib TO mt_terrattrib_all.
        SORT mt_terrattrib_all.
        DELETE ADJACENT DUPLICATES FROM mt_terrattrib_all COMPARING ALL FIELDS.
    ENDIF.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>INIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TERR_GUID                   TYPE        CRMT_TERRITORY_GUID_TAB
* | [--->] IT_LINK                        TYPE        CRMT_TERR_LINK_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method INIT.
    "* Right now, this FM is called only from AFTER_RULE_SAVE;
    "* so we get only one terr_guid, one entry in the link table

    DATA: ls_link TYPE CRMD_TERR_LINK.
    READ TABLE it_link INTO ls_link INDEX 1.
    CHECK sy-subrc = 0.

    mv_territory_guid = ls_link-territory_guid.
    mv_territory_v_guid = ls_link-territory_v_guid.
    mv_valid_from = ls_link-valid_from.
    mv_valid_to = ls_link-valid_to.

    CALL FUNCTION 'CRM_TERRMAN_READ_BW_TERR_DB'
      EXPORTING
        iv_terr_guid   = mv_territory_guid
      IMPORTING
        et_terrattr_bw = mt_terrattr_bw
      EXCEPTIONS
        not_found      = 1
        OTHERS         = 2.

    mv_rule_id = ls_link-rule_id.

    CALL METHOD cl_crm_fdt=>read_rule
      EXPORTING
        iv_ruleid    = mv_rule_id
      IMPORTING
        et_rule_attr = mt_rule_attr
        et_rule_data = mt_rule_data.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>LOOP_RULEATTRIB_FINALCP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ATTRIB_FINALCP              TYPE        CRMT_RULE_ATTRIBUTES
* | [--->] IT_ATTRIB_FINAL                TYPE        CRMT_RULE_ATTRIBUTES
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method LOOP_RULEATTRIB_FINALCP.
     DATA: ls_ruleattrib TYPE LINE OF crmt_rule_attributes.

     LOOP AT it_attrib_finalcp INTO ls_ruleattrib.
        append_value_pair( EXPORTING iv_rule_attr = ls_ruleattrib it_attrib_final = it_attrib_final ).
     ENDLOOP.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>LOOP_RULEATTRIB_ROW
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ATTRIB_ROW                  TYPE        CRMT_RULE_ATTRIBUTES
* | [--->] IT_ATTRIB_FINAL                TYPE        CRMT_RULE_ATTRIBUTES
* | [--->] IT_ATTRIB_FINALCP              TYPE        CRMT_RULE_ATTRIBUTES
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method LOOP_RULEATTRIB_ROW.

    DATA: ls_ruleattrib_row TYPE crms_rule_attributes,
          ls_ruleattrib TYPE crms_rule_attributes.

    LOOP AT it_attrib_row INTO ls_ruleattrib_row.
       LOOP AT it_attrib_final INTO ls_ruleattrib WHERE row_no = ls_ruleattrib_row-row_no.
          build_terr_range_table( EXPORTING iv_rule_attr = ls_ruleattrib ).
       ENDLOOP.

       loop_ruleattrib_finalcp( EXPORTING it_attrib_final   = it_attrib_final
                                          it_attrib_finalcp = it_attrib_finalcp ).

       get_terrattrib_all( ).

       cleanup( ).
    ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>POST_HANDLING
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_TERRATTRIB                  TYPE        CRMT_TERRATTRIB_TAB
* | [<---] ET_TERRATTRIB_DATES            TYPE        CRMT_TERRATTRIB_DATES_TAB
* | [<---] ET_ERRORS                      TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method POST_HANDLING.

    DATA: ls_terrattrib LIKE LINE OF mt_terrattrib_all,
          ls_terrattr_bw LIKE LINE OF mt_terrattr_bw,
          ls_terrattrib_dates LIKE LINE OF et_terrattrib_dates,
          lv_index LIKE sy-tabix.

    DELETE mt_terrattr_bw WHERE rule_id NE mv_rule_id.

    LOOP AT mt_terrattrib_all INTO ls_terrattrib.
       lv_index = sy-tabix.
       READ TABLE mt_terrattr_bw INTO ls_terrattr_bw INDEX lv_index.
       IF sy-subrc EQ 0 AND ls_terrattr_bw-rule_id EQ mv_rule_id.
          ls_terrattrib-guid = ls_terrattr_bw-tras_guid.
       ENDIF.
       IF ls_terrattrib-guid IS INITIAL.
          CALL FUNCTION 'CRM_GUID_CREATE'
            IMPORTING
              ev_guid = ls_terrattrib-guid.
       ENDIF.
       ls_terrattrib-territory_v_guid = mv_territory_v_guid.
       APPEND ls_terrattrib TO et_terrattrib.
       MOVE-CORRESPONDING ls_terrattrib TO ls_terrattrib_dates.
       ls_terrattrib_dates-rule_id = mv_rule_id .
       ls_terrattrib_dates-rule_valid_from = mv_valid_from .
       ls_terrattrib_dates-rule_valid_to = mv_valid_to .
       APPEND ls_terrattrib_dates TO et_terrattrib_dates .
    ENDLOOP.

  et_errors = mt_errors.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>RUN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TERR_GUID                   TYPE        CRMT_TERRITORY_GUID_TAB
* | [--->] IT_LINK                        TYPE        CRMT_TERR_LINK_T
* | [<---] ET_TERRATTRIB                  TYPE        CRMT_TERRATTRIB_TAB
* | [<---] ET_TERRATTRIB_DATES            TYPE        CRMT_TERRATTRIB_DATES_TAB
* | [<-->] CT_ERRORS                      TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method RUN.
     DATA: lt_ruleattrib_final   TYPE crmt_rule_attributes,
           lt_ruleattrib_finalcp TYPE crmt_rule_attributes,
           lt_ruleattrib_row     TYPE crmt_rule_attributes.

     cleanup( ).

     init( EXPORTING it_terr_guid = it_terr_guid it_link = it_link ).

     lt_ruleattrib_finalcp = lt_ruleattrib_final = get_ruleattrib_final_table( ).
     SORT lt_ruleattrib_finalcp BY attribute_id.
     DELETE lt_ruleattrib_finalcp WHERE attribute_id+0(1) EQ 'Z' OR attribute_id+0(1) EQ 'Y'.
     DELETE ADJACENT DUPLICATES FROM lt_ruleattrib_finalcp COMPARING attribute_id .

     lt_ruleattrib_row = lt_ruleattrib_final.
     DELETE ADJACENT DUPLICATES FROM lt_ruleattrib_row COMPARING row_no.

     loop_ruleattrib_row( EXPORTING it_attrib_row     = lt_ruleattrib_row
                                    it_attrib_final   = lt_ruleattrib_final
                                    it_attrib_finalcp = lt_ruleattrib_finalcp ).

     post_handling( IMPORTING et_terrattrib       = et_terrattrib
                              et_terrattrib_dates = et_terrattrib_dates
                              et_errors           = ct_errors  ).

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_BRICK
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_BRICK.
    DATA: lt_where TYPE crmt_report_dyn_sql_line_ta,
          lt_brick TYPE TABLE OF crmpham_bp_frg30,
          ls_valuepair LIKE LINE OF mt_valuepair,
          ls_brick LIKE LINE OF lt_brick.

    CLEAR: lt_where.

    CALL FUNCTION 'CRM_REPORT_DYN_ITAB_BREAK_DOWN'
       EXPORTING
         i_name_on_db = 'BRICK_NUMBER'
         it_sel_table = mt_bp_brick
       CHANGING
         ct_where     = lt_where.


    CHECK lt_where IS NOT INITIAL.
    CALL FUNCTION 'CRM_REPORT_REMOVE_LAST_AND'
       CHANGING
         ct_where = lt_where.

    SELECT * FROM crmpham_bp_frg30 INTO TABLE lt_brick WHERE (lt_where) AND brick_type = 'RP'.
    SORT lt_brick BY brick_number.
    DELETE ADJACENT DUPLICATES FROM lt_brick COMPARING brick_number.
    LOOP AT lt_brick INTO ls_brick.
       ls_valuepair-attribute = 'BP_BRICK'.
       ls_valuepair-value = ls_brick-brick_number.
       APPEND ls_valuepair TO mt_valuepair.
    ENDLOOP.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_COUNTRY
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_COUNTRY.
    DATA: lt_where TYPE crmt_report_dyn_sql_line_ta,
          ls_valuepair LIKE LINE OF mt_valuepair,
          lt_t005t TYPE TABLE OF t005t,
          ls_t005t LIKE LINE OF lt_t005t.

    CLEAR: lt_where.

    CALL FUNCTION 'CRM_REPORT_DYN_ITAB_BREAK_DOWN'
      EXPORTING
        i_name_on_db = 'LAND1'
        it_sel_table = mt_bp_country
      CHANGING
        ct_where     = lt_where.
    CHECK lt_where IS NOT INITIAL.
    CALL FUNCTION 'CRM_REPORT_REMOVE_LAST_AND'
       CHANGING
          ct_where = lt_where.
    SELECT * FROM t005t INTO TABLE lt_t005t WHERE (lt_where) AND spras = 'E'.
    LOOP AT lt_t005t INTO ls_t005t.
       ls_valuepair-attribute = 'BP_COUNTRY'.
       ls_valuepair-value = ls_t005t-land1.
       APPEND ls_valuepair TO mt_valuepair.
    ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_GROUP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_GROUP.
     DATA: lt_where     TYPE crmt_report_dyn_sql_line_ta,
           ls_valuepair LIKE LINE OF mt_valuepair,
           lt_group     TYPE TABLE OF crmphac_bp_grp,
           ls_group     LIKE LINE OF lt_group.

     CLEAR: lt_where.
     CALL FUNCTION 'CRM_REPORT_DYN_ITAB_BREAK_DOWN'
        EXPORTING
          i_name_on_db = 'BPGROUP'
          it_sel_table = mt_bp_group
        CHANGING
          ct_where     = lt_where.

     CHECK lt_where IS NOT INITIAL.
     CALL FUNCTION 'CRM_REPORT_REMOVE_LAST_AND'
        CHANGING
          ct_where = lt_where.
     SELECT * FROM crmphac_bp_grp INTO TABLE lt_group WHERE (lt_where).
     LOOP AT lt_group INTO ls_group.
        ls_valuepair-attribute = 'BP_GROUP'.
        ls_valuepair-value = ls_group-bpgroup.
        APPEND ls_valuepair TO mt_valuepair.
     ENDLOOP.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_GUID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ATTRIB_FINAL                TYPE        CRMT_RULE_ATTRIBUTES
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_GUID.

  DATA: lt_bp_partner_eq LIKE mt_bp_partner,
        lt_partner_ids TYPE TABLE OF bu_partner,
        lv_partner_id LIKE LINE OF lt_partner_ids,
        lr_badi_name TYPE REF TO crm_tm_flt_by_custattr_bw_badi,
        ls_errors LIKE LINE OF mt_errors,
        lv_msg_text TYPE string,
        iv_msg_v1 TYPE string,
        iv_msg_v2 TYPE string,
        iv_msg_v3  TYPE string,
        iv_msg_v4  TYPE string,
        ls_valuepair LIKE LINE OF mt_valuepair,
        lr_cx_badi_implement_error TYPE REF TO cx_badi_not_single_use.

  CHECK mt_bp_partner IS NOT INITIAL.
  lt_bp_partner_eq = mt_bp_partner.
  DELETE lt_bp_partner_eq WHERE sign <> 'I' OR option <> 'EQ'.
  DELETE mt_bp_partner WHERE sign = 'I' AND option = 'EQ'.

  call method zcl_crm_terrman_bp_guid_util=>get_partner_id
    exporting
      it_attrib_final  = it_attrib_final
      it_bp_partner_eq = lt_bp_partner_eq
      it_bp_brick      = mt_bp_brick
      it_bp_partner    = mt_bp_partner
      it_bp_region     = mt_bp_region
      it_bp_postcode   = mt_bp_post_code
      it_bp_country    = mt_bp_country
  importing
      et_partner_ids   = lt_partner_ids.


  CLEAR: lr_cx_badi_implement_error.
  TRY.
     GET BADI lr_badi_name.
  CATCH
     cx_badi_not_implemented
     cx_badi_multiply_implemented INTO lr_cx_badi_implement_error.
     RETURN.
  ENDTRY.


  TRY.
     CALL BADI lr_badi_name->filter_accounts
       EXPORTING
           it_custattr_values = mt_rule_custattr_bp
       CHANGING
           ct_bp_ids          = lt_partner_ids.
     CATCH cx_root.
       MESSAGE ID 'CRM_FDT_MSG' TYPE 'W' NUMBER '109' WITH iv_msg_v1 iv_msg_v2 iv_msg_v3 iv_msg_v4  INTO lv_msg_text.
       ls_errors-type = 'W'.
       ls_errors-message = lv_msg_text.
       APPEND ls_errors TO mt_errors.
  ENDTRY.

  CLEAR lt_bp_partner_eq.
  ls_valuepair-attribute = 'BP_PARTNER'.
  LOOP AT lt_partner_ids INTO lv_partner_id.
      ls_valuepair-value     = lv_partner_id.
      APPEND ls_valuepair TO mt_valuepair.
  ENDLOOP.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_MAINSPEC
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_MAINSPEC.
    DATA: lt_where TYPE crmt_report_dyn_sql_line_ta,
          ls_valuepair LIKE LINE OF mt_valuepair,
          lt_bp_main_spec TYPE TABLE OF crmphac_bp_spv,
          ls_bp_main_spec LIKE LINE OF lt_bp_main_spec.

    CALL FUNCTION 'CRM_REPORT_DYN_ITAB_BREAK_DOWN'
       EXPORTING
         i_name_on_db = 'SPEC_TYPE'
         it_sel_table = mt_bp_main
       CHANGING
         ct_where     = lt_where.

    CHECK lt_where IS NOT INITIAL.
    CALL FUNCTION 'CRM_REPORT_REMOVE_LAST_AND'
       CHANGING
          ct_where = lt_where.

    SELECT * FROM crmphac_bp_spv INTO TABLE lt_bp_main_spec WHERE (lt_where).
    LOOP AT lt_bp_main_spec INTO ls_bp_main_spec.
       ls_valuepair-attribute = 'BP_MAIN_SPEC'.
       ls_valuepair-value = ls_bp_main_spec-spec_type.
       APPEND ls_valuepair TO mt_valuepair.
    ENDLOOP.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_NODE_GUID
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_NODE_GUID.

     DATA: lv_bp_node_guid LIKE LINE OF mt_bp_node_guid_tab,
           ls_valuepair LIKE LINE OF mt_valuepair.

     LOOP AT mt_bp_node_guid_tab INTO lv_bp_node_guid.
       ls_valuepair-attribute = 'BP_NODE_GUID'.
       ls_valuepair-value = lv_bp_node_guid.
       APPEND ls_valuepair TO mt_valuepair.
     ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_POSTCODE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_POSTCODE.

    DATA: lt_range_table_list TYPE TABLE OF REF TO crmt_terr_range_t,
          lt_range_table      LIKE LINE OF lt_range_table_list,
          ls_valuepair        LIKE LINE OF mt_valuepair,
          lr_ref              TYPE REF TO if_ex_crm_terrman_attrib,
          lt_bp_postal_code   TYPE crmt_terr_rule_attr,
          lv_cust_terrattrib  TYPE exit_def VALUE 'CRM_TERRMAN_ATTRIB',
          ls_bp_postal_code   LIKE LINE OF mt_bp_post_code,
          ls_postal_code      LIKE LINE OF lt_bp_postal_code.

    CLEAR lt_range_table_list.

    IF mt_bp_post_code IS NOT INITIAL.
        GET REFERENCE OF mt_bp_post_code INTO lt_range_table.
        INSERT lt_range_table INTO TABLE lt_range_table_list.
    ENDIF.

    CALL FUNCTION 'CRM_TERRMAN_ADJUST_RULE_DATA'
      CHANGING
        it_range_table_list = lt_range_table_list.

* Loop only once to check if postal code value can derive multiple postal codes
* Then implement badi to find out the postal codes for all
* If  conditions only has I and EQ then form attributes directly
    LOOP AT mt_bp_post_code INTO ls_bp_postal_code WHERE sign NE 'I' OR option NE 'EQ'.
       EXIT.
    ENDLOOP.

    IF sy-subrc <> 0.
       LOOP AT mt_bp_post_code INTO ls_bp_postal_code WHERE sign EQ 'I' AND option EQ 'EQ'.
          ls_valuepair-attribute = 'BP_POST_CODE'.
          ls_valuepair-value = ls_bp_postal_code-low.
          APPEND ls_valuepair TO mt_valuepair.
       ENDLOOP.
    ELSE.
       CALL METHOD cl_exithandler=>get_instance
          EXPORTING
            exit_name              = lv_cust_terrattrib
            null_instance_accepted = 'X'
          CHANGING
            instance               = lr_ref.
       IF lr_ref IS NOT INITIAL.
          CALL METHOD lr_ref->get_postal_code
            EXPORTING
               it_bp_post_code = mt_bp_post_code
            IMPORTING
               et_valuepair    = lt_bp_postal_code.
       ENDIF.
       CLEAR ls_bp_postal_code.
       LOOP AT lt_bp_postal_code INTO ls_postal_code.
          ls_valuepair-attribute = ls_postal_code-attribute_id.
          ls_valuepair-value = ls_postal_code-value.
          APPEND ls_valuepair TO mt_valuepair.
       ENDLOOP.
    ENDIF.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_REGION
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_REGION.
    DATA: lt_where TYPE crmt_report_dyn_sql_line_ta,
          lt_region TYPE TABLE OF t005s,
          ls_region LIKE LINE OF lt_region,
          ls_valuepair LIKE LINE OF mt_valuepair.
    CLEAR: lt_where.

    CALL FUNCTION 'CRM_REPORT_DYN_ITAB_BREAK_DOWN'
      EXPORTING
        i_name_on_db = 'BLAND'
        it_sel_table = mt_bp_region
      CHANGING
        ct_where     = lt_where.

    CHECK lt_where IS NOT INITIAL.
    CALL FUNCTION 'CRM_REPORT_REMOVE_LAST_AND'
       CHANGING
           ct_where = lt_where.

    SELECT * FROM t005s INTO TABLE lt_region WHERE (lt_where).
    SORT lt_region BY bland.
    DELETE ADJACENT DUPLICATES FROM lt_region COMPARING bland.
    LOOP AT lt_region INTO ls_region.
       ls_valuepair-attribute = 'BP_REGION'.
       ls_valuepair-value = ls_region-bland.
       APPEND ls_valuepair TO mt_valuepair.
    ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_SUBGROUP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_BP_SUBGROUP.
     DATA: lt_where     TYPE crmt_report_dyn_sql_line_ta,
           lt_subgroup  TYPE TABLE OF crmphac_bp_sgr,
           ls_subgroup  LIKE LINE OF lt_subgroup,
           ls_valuepair LIKE LINE OF mt_valuepair.

     CLEAR: lt_where.
     CALL FUNCTION 'CRM_REPORT_DYN_ITAB_BREAK_DOWN'
       EXPORTING
         i_name_on_db = 'BPSUBGROUP'
         it_sel_table = mt_bp_subgroup
       CHANGING
         ct_where     = lt_where.

     CHECK lt_where IS NOT INITIAL.
     CALL FUNCTION 'CRM_REPORT_REMOVE_LAST_AND'
       CHANGING
         ct_where = lt_where.
     SELECT * FROM crmphac_bp_sgr INTO TABLE lt_subgroup WHERE (lt_where).
     LOOP AT lt_subgroup INTO ls_subgroup.
        ls_valuepair-attribute = 'BP_SUBGROUP'.
        ls_valuepair-value = ls_subgroup-bpsubgroup.
        APPEND ls_valuepair TO mt_valuepair.
     ENDLOOP.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_PM_CATEGORY
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_PM_CATEGORY.

    DATA: lt_category TYPE TABLE OF comt_category_selection,
          ls_category LIKE LINE OF lt_category,
          ls_valuepair LIKE LINE OF mt_valuepair.

    CALL FUNCTION 'COM_PRODUCT_CATEGORY_GETLIST'
       EXPORTING
          it_category_id_range = mt_category_id
          iv_langu             = sy-langu
          iv_non_assignable    = 'X'
          iv_request_data      = 'X'
       IMPORTING
          et_product_category  = lt_category
       EXCEPTIONS
         wrong_call           = 1
         hierarchy_not_found  = 2
         langu_not_found      = 3
         OTHERS               = 4.
     LOOP AT lt_category INTO ls_category.
        ls_valuepair-attribute = 'PM_CATEGORY'.
        ls_valuepair-value = ls_category-category_id.
        APPEND ls_valuepair TO mt_valuepair.
     ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_PM_CATEGORY_GUID
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_PM_CATEGORY_GUID.

    DATA: lt_category_list_hier TYPE comt_category_selection_tab,
          ls_valuepair LIKE LINE OF mt_valuepair,
          lv_hierarchy_id TYPE comt_hierarchy_id,
          ls_category_list LIKE LINE OF lt_category_list_hier.

     CALL FUNCTION 'COM_PRODUCT_CATEGORY_GETLIST'
       EXPORTING
          it_category_id_range  = mt_cat_id
          it_hierarchy_id_range = mt_hier_id
      IMPORTING
          et_product_category   = lt_category_list_hier
      EXCEPTIONS
          wrong_call            = 1
          hierarchy_not_found   = 2
          langu_not_found       = 3
          OTHERS                = 4.

      LOOP AT lt_category_list_hier INTO ls_category_list.
         ls_valuepair-attribute = 'PM_CATEGORY_GUID'.
         CALL FUNCTION 'CRM_TERRMAN_HIERARCHY_ID_GUID'
            EXPORTING
               iv_hierarchy_guid = ls_category_list-hierarchy_guid
            IMPORTING
               ev_hierarchy_id   = lv_hierarchy_id.
         CONCATENATE lv_hierarchy_id ls_category_list-category_id
                  INTO ls_valuepair-value SEPARATED BY ': '.
         APPEND ls_valuepair TO mt_valuepair.
      ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_TERRMAN_BUILD_TER_UTIL=>ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_PM_HIERARCHY_GUID
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRM_TERR_VALUEPAIR_BUILDER~BUILD_PM_HIERARCHY_GUID.

    DATA: lt_hierarchy TYPE TABLE OF comt_category_selection,
          ls_hierarchy LIKE LINE OF lt_hierarchy,
          ls_valuepair LIKE LINE OF mt_valuepair.

    CALL FUNCTION 'COM_PRODUCT_CATEGORY_GETLIST'
       EXPORTING
         it_hierarchy_id_range = mt_hierarchy_id
         iv_langu              = sy-langu
         iv_non_assignable     = 'X'
         iv_request_data       = 'X'
       IMPORTING
         et_product_category   = lt_hierarchy
       EXCEPTIONS
         wrong_call            = 1
         hierarchy_not_found   = 2
         langu_not_found       = 3
         OTHERS                = 4.

    LOOP AT lt_hierarchy INTO ls_hierarchy.
        ls_valuepair-attribute = 'PM_HIERARCHYGUID'.
        ls_valuepair-value = ls_hierarchy-hierarchy_guid.
        APPEND ls_valuepair TO mt_valuepair.
    ENDLOOP.
  endmethod.
ENDCLASS.