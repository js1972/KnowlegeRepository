class CL_CRMS4_BT_DATA_MODEL_TOOL definition
  public
  final
  create private .

public section.

  types:
    tt_supported_components TYPE STANDARD TABLE OF crmt_object_name WITH KEY table_line .

  data MV_CURRENT_HEAD_MODE type CRMT_MODE read-only .
  data MV_CURRENT_ITEM_MODE type CRMT_MODE read-only .

  methods SAVE_HEADER
    importing
      !IT_HEADER_GUID type CRMT_OBJECT_GUID_TAB .
  methods MERGE_CHANGE_2_GLOBAL_BUFFER
    importing
      !IT_CURRENT_INSERT type ANY TABLE
      !IT_CURRENT_UPDATE type ANY TABLE
      !IT_CURRENT_DELETE type ANY TABLE optional
    changing
      !CT_GLOBAL_INSERT type ANY TABLE
      !CT_GLOBAL_UPDATE type ANY TABLE
      !CT_GLOBAL_DELETE type ANY TABLE optional .
  class-methods CLASS_CONSTRUCTOR .
  methods GET_ITEM
    importing
      !IT_ITEM_GUID type CRMT_OBJECT_GUID_TAB
    exporting
      !ET_ORDERADM_I_DB type CRMT_ORDERADM_I_DU_TAB .
  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to CL_CRMS4_BT_DATA_MODEL_TOOL .
  methods SET_CURRENT_ITEM_MODE
    importing
      !IV_MODE type CRMT_MODE .
  methods DETERMINE_HEAD_CHANGE_MODE
    importing
      !IV_ORDER_GUID type CRMT_OBJECT_GUID .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_convertor_instance,
        cls_name  TYPE crmt_object_name,
        convertor TYPE REF TO if_crms4_btx_data_model_conv,
      END OF ty_convertor_instance .
  types:
    tt_convertor_instance TYPE TABLE OF ty_convertor_instance WITH KEY cls_name .
  types:
    BEGIN OF ty_header_object_type,
        guid        TYPE crmt_object_guid,
        object_type TYPE crmt_subobject_category_db,
      END OF ty_header_object_type .
  types:
    tt_header_object_type TYPE TABLE OF ty_header_object_type WITH KEY guid .
  types:
    BEGIN OF ty_object_supported_component,
        object_type     TYPE crmt_subobject_category_db,
        supported_comps TYPE crmt_object_name_tab,
      END OF ty_object_supported_component .
  types:
    tt_object_supported_component TYPE TABLE OF ty_object_supported_component
                  WITH KEY object_type .
  types:
    BEGIN OF ty_component_conv_cls,
        component TYPE crmt_object_name,
        conv_cls  TYPE string,
      END OF ty_component_conv_cls .
  types:
    tt_component_conv_cls TYPE TABLE OF ty_component_conv_cls WITH KEY component .

  data MT_CONVERTOR_INST_BUFFER type TT_CONVERTOR_INSTANCE .
  data MT_COMPONENT_CONV_CLS type TT_COMPONENT_CONV_CLS .
  class-data SO_INSTANCE type ref to CL_CRMS4_BT_DATA_MODEL_TOOL .
  data MT_HEADER_OBJECT_TYPE_BUF type TT_HEADER_OBJECT_TYPE .
  data MT_HEADER_SUPPORTED_COMPS type TT_OBJECT_SUPPORTED_COMPONENT .
  data MT_ITEM_SUPPORTED_COMPS type TT_OBJECT_SUPPORTED_COMPONENT .
  data:
    mt_acronym TYPE STANDARD TABLE OF crmc_subob_cat_i .

  methods MERGE_LOCAL_CHANGE_2_GLOBAL
    importing
      !IS_CURRENT_INSERT type ANY optional
      !IS_CURRENT_UPDATE type ANY optional
      !IS_CURRENT_DELETE type ANY optional
    changing
      !CT_GLOBAL_INSERT type ANY TABLE
      !CT_GLOBAL_UPDATE type ANY TABLE
      !CT_GLOBAL_DELETE type ANY TABLE optional .
  methods DETECT_CHANGE_REVERT
    importing
      !IV_ORDER_DB_BUFFER_NAME type STRING
    changing
      !CT_TO_UPDATE type ANY TABLE .
  methods CLEANUP .
  methods FETCH_ITEM_CONV_CLASS .
  methods FETCH_ITEM_SUPPORTED_COMP
    importing
      !IT_ITEM_WRKT type CRMT_ORDERADM_I_WRKT .
  methods GET_HEADER_DB_TYPE
    importing
      !IV_HEADER_GUID type CRMT_OBJECT_GUID
    returning
      value(RV_DB_TYPE) type STRING .
  methods GET_HEADER_SUPPORTED_COMP
    importing
      !IV_HEADER_OBJECT_TYPE type CRMT_SUBOBJECT_CATEGORY_DB
    returning
      value(RT_HEADER_SUPPORTED_COMP) type CRMT_OBJECT_NAME_TAB .
  methods FETCH_HEADER_OBJECT_TYPE
    importing
      !IT_HEADER_GUID type CRMT_OBJECT_GUID_TAB .
  methods GET_HEADER_OBJECT_TYPE_BY_GUID
    importing
      !IV_HEADER_GUID type CRMT_OBJECT_GUID
    returning
      value(RV_OBJECT_TYPE) type CRMT_SUBOBJECT_CATEGORY_DB .
  methods CONV_S4_2_1ORDER_AND_FILL_BUFF
    importing
      !IT_OBJECTS type CRMT_OBJECT_NAME_TAB
    changing
      !CS_ITEM type ANY .
  methods GET_CONVERTOR_INSTANCE
    importing
      !IV_CLS_NAME type CRMT_OBJECT_NAME
    returning
      value(RO_CONVERTOR) type ref to IF_CRMS4_BTX_DATA_MODEL_CONV .
  methods FETCH_HEADER_SUPPORTED_COMP .
  methods SAVE_SINGLE_HEADER
    importing
      !IV_HEADER_GUID type CRMT_OBJECT_GUID .
  methods FETCH_COMPONENT_CONV_CLS .
  methods GET_CONV_CLS_NAME_BY_COMPONENT
    importing
      !IV_COMPONENT_NAME type CRMT_OBJECT_NAME
    returning
      value(RV_CLS_NAME) type CRMT_OBJECT_NAME .
  methods GET_UNSORTED_COMPONENT_LIST
    importing
      !IT_SORTED_COMP type CRMT_OBJECT_NAME_TAB
      !IV_HEADER type ABAP_BOOL default ABAP_TRUE
    returning
      value(RT_UNSORTED_COMP) type TT_SUPPORTED_COMPONENTS .
  methods SAVE_SINGLE_ITEMS
    importing
      !IV_HEADER_GUID type CRMT_OBJECT_GUID .
  methods GET_ITEM_SUPPORTED_COMP
    importing
      !IV_ITEM_OBJECT_TYPE type CRMT_SUBOBJECT_CATEGORY_DB
    returning
      value(RT_ITEM_SUPPORTED_COMP) type CRMT_OBJECT_NAME_TAB .
  methods GET_ITEM_DB_TYPE
    importing
      !IV_ITEM_OBJECT_TYPE type CRMT_SUBOBJECT_CATEGORY_DB
    returning
      value(RV_DB_TYPE) type STRING .
  methods GET_HEADER_DB_BUFFER_TYPE
    importing
      !IV_HEADER_GUID type CRMT_OBJECT_GUID
    returning
      value(RV_DB_TYPE) type STRING .
ENDCLASS.



CLASS CL_CRMS4_BT_DATA_MODEL_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_CRMS4_BT_DATA_MODEL_TOOL=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_constructor.
    so_instance = NEW #( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->CLEANUP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD cleanup.
*    CLEAR: mt_order_to_be_created.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->CONV_S4_2_1ORDER_AND_FILL_BUFF
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OBJECTS                     TYPE        CRMT_OBJECT_NAME_TAB
* | [<-->] CS_ITEM                        TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD conv_s4_2_1order_and_fill_buff.
    DATA: lv_wrk_structure_name TYPE string,
          lr_wrk_structure      TYPE REF TO data,
          lt_convert_class      TYPE TABLE OF crmc_objects,
          lo_convertor          TYPE REF TO if_crms4_btx_data_model_conv.

    FIELD-SYMBOLS: <ls_wrk_structure> TYPE any.

    SELECT name conv_class INTO CORRESPONDING FIELDS OF TABLE lt_convert_class FROM crmc_objects
       FOR ALL ENTRIES IN it_objects WHERE name = it_objects-table_line.

    LOOP AT it_objects ASSIGNING FIELD-SYMBOL(<lv_object>).

      READ TABLE lt_convert_class ASSIGNING FIELD-SYMBOL(<cls_name>) WITH KEY
          name = <lv_object>.
      CHECK sy-subrc = 0 AND <cls_name>-conv_class IS NOT INITIAL.
      lo_convertor = get_convertor_instance( iv_cls_name = <cls_name>-conv_class ).

      CALL METHOD lo_convertor->get_wrk_structure_name
        RECEIVING
          rv_wrk_structure_name = lv_wrk_structure_name.
      CREATE DATA lr_wrk_structure TYPE (lv_wrk_structure_name).
      ASSIGN lr_wrk_structure->* TO <ls_wrk_structure>.
      CALL METHOD lo_convertor->convert_s4_to_1o
        EXPORTING
          is_workarea = cs_item
        IMPORTING
          es_workarea = <ls_wrk_structure>.
      CALL METHOD lo_convertor->put_to_db_buffer
        EXPORTING
          is_wrk_structure = <ls_wrk_structure>
          iv_ref_kind      = 'B'.

    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->DETECT_CHANGE_REVERT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ORDER_DB_BUFFER_NAME        TYPE        STRING
* | [<-->] CT_TO_UPDATE                   TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD detect_change_revert.

    DATA: lr_db_header TYPE REF TO data.

    CREATE DATA lr_db_header TYPE (iv_order_db_buffer_name).
    ASSIGN lr_db_header->* TO FIELD-SYMBOL(<db_header>).

    LOOP AT ct_to_update ASSIGNING FIELD-SYMBOL(<to_update>).
      ASSIGN COMPONENT 'GUID' OF STRUCTURE <to_update> TO FIELD-SYMBOL(<guid>).
      ASSERT sy-subrc = 0.
      CALL FUNCTION 'CRM_SRVO_H_GET_DB'
        EXPORTING
          iv_order_guid = <guid>
        IMPORTING
          es_db_buffer  = <db_header>.
      IF <db_header> = <to_update>.
* Jerry 2017-05-10 14:11PM TODO
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_DATA_MODEL_TOOL->DETERMINE_HEAD_CHANGE_MODE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ORDER_GUID                  TYPE        CRMT_OBJECT_GUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD determine_head_change_mode.
* Jerry 2017-05-12 10:34AM mt_order_to_be_created not necessary!
*    READ TABLE me->mt_order_to_be_created WITH KEY table_line = iv_order_guid
*      TRANSPORTING NO FIELDS.

    DATA: lv_on_db TYPE abap_bool.

    CALL FUNCTION 'CRM_ORDERADM_H_ON_DATABASE_OW'
      EXPORTING
        iv_orderadm_h_guid  = iv_order_guid
      IMPORTING
        ev_on_database_flag = lv_on_db.

    me->mv_current_head_mode = COND crmt_mode( WHEN lv_on_db = abap_false THEN 'A'
                                                ELSE 'B' ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->FETCH_COMPONENT_CONV_CLS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fetch_component_conv_cls.
    DATA: lt_missing_comp  TYPE crmt_object_name_tab,
          lt_zcrmc_objects TYPE TABLE OF crmc_objects.

    LOOP AT mt_header_supported_comps ASSIGNING FIELD-SYMBOL(<comp>).
      LOOP AT <comp>-supported_comps ASSIGNING FIELD-SYMBOL(<component>).
        READ TABLE mt_component_conv_cls WITH KEY component = <component>
           TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          INSERT <component> INTO TABLE lt_missing_comp.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    SELECT name conv_class INTO CORRESPONDING FIELDS OF TABLE lt_zcrmc_objects
        FROM crmc_objects FOR ALL ENTRIES IN lt_missing_comp
          WHERE name = lt_missing_comp-table_line.

    LOOP AT lt_zcrmc_objects ASSIGNING FIELD-SYMBOL(<missing_comp>).
      APPEND INITIAL LINE TO mt_component_conv_cls ASSIGNING FIELD-SYMBOL(<new_buffer>).
      <new_buffer>-component = <missing_comp>-name.
      <new_buffer>-conv_cls = <missing_comp>-conv_class.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->FETCH_HEADER_OBJECT_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fetch_header_object_type.
    DATA: lt_header_buffer_miss TYPE crmt_object_guid_tab,
          lt_order_h            TYPE crmt_orderadm_h_wrkt,
          lt_header_shadow      TYPE TABLE OF crms4d_btx.
    LOOP AT it_header_guid ASSIGNING FIELD-SYMBOL(<guid>).
      READ TABLE mt_header_object_type_buf WITH KEY guid = <guid> TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        APPEND <guid> TO lt_header_buffer_miss.
      ENDIF.
    ENDLOOP.

    CHECK lt_header_buffer_miss IS NOT INITIAL.

    SELECT * INTO TABLE lt_header_shadow FROM crms4d_btx FOR ALL ENTRIES IN lt_header_buffer_miss
        WHERE order_guid = lt_header_buffer_miss-table_line.

    LOOP AT lt_header_shadow ASSIGNING FIELD-SYMBOL(<header_shadow>).
      APPEND INITIAL LINE TO mt_header_object_type_buf ASSIGNING FIELD-SYMBOL(<new_buffer>).
      <new_buffer> = VALUE #( guid = <header_shadow>-order_guid
                               object_type = <header_shadow>-object_type ).
    ENDLOOP.

* Jerry 2017-05-08 5:29PM in save case shadow table does not have record for this guid
* Creation case!
    IF lt_header_shadow IS INITIAL.
      CALL FUNCTION 'CRM_ORDERADM_H_READ_OB'
        EXPORTING
          it_guid           = it_header_guid
        IMPORTING
          et_orderadm_h_wrk = lt_order_h.

      LOOP AT it_header_guid ASSIGNING FIELD-SYMBOL(<order_to_create>).
* Jerry 2017-05-08 6:48PM record those order into an internal table
*        "INSERT <order_to_create> INTO TABLE mt_order_to_be_created.
        READ TABLE lt_order_h ASSIGNING FIELD-SYMBOL(<order_header>)
           WITH KEY guid = <order_to_create>.
        ASSERT sy-subrc = 0.
        APPEND INITIAL LINE TO mt_header_object_type_buf ASSIGNING FIELD-SYMBOL(<buffer_for_created>).
          <buffer_for_created> = VALUE #( guid = <order_to_create>
                                          object_type = <order_header>-object_type ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->FETCH_HEADER_SUPPORTED_COMP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fetch_header_supported_comp.
    DATA: lt_missed_header_object TYPE TABLE OF crmt_subobject_category_db,
          lt_zcrmc_object_ass     TYPE TABLE OF crmc_object_assi.

    LOOP AT mt_header_object_type_buf ASSIGNING FIELD-SYMBOL(<header_buf>).
      READ TABLE mt_header_supported_comps WITH KEY object_type = <header_buf>-object_type
        TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        APPEND <header_buf>-object_type TO lt_missed_header_object.
      ENDIF.
    ENDLOOP.

    CHECK lt_missed_header_object IS NOT INITIAL.
    SORT lt_missed_header_object.
    DELETE ADJACENT DUPLICATES FROM lt_missed_header_object.

    SELECT * INTO TABLE lt_zcrmc_object_ass FROM crmc_object_assi FOR ALL ENTRIES IN
         lt_missed_header_object WHERE subobj_category = lt_missed_header_object-table_line.
    CHECK sy-subrc = 0.

    LOOP AT lt_missed_header_object ASSIGNING FIELD-SYMBOL(<missing>).
      APPEND INITIAL LINE TO mt_header_supported_comps ASSIGNING FIELD-SYMBOL(<new_buffer>).
      <new_buffer>-object_type = <missing>.
      LOOP AT lt_zcrmc_object_ass ASSIGNING FIELD-SYMBOL(<header_supported>)
          WHERE subobj_category = <missing>.
        INSERT <header_supported>-name INTO TABLE <new_buffer>-supported_comps.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->FETCH_ITEM_CONV_CLASS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fetch_item_conv_class.
    DATA: lt_missing_comp TYPE TABLE OF crmt_object_name,
          lt_objects      TYPE TABLE OF crmc_objects.

    LOOP AT mt_item_supported_comps ASSIGNING FIELD-SYMBOL(<item_comp_buffer>).
      LOOP AT <item_comp_buffer>-supported_comps ASSIGNING FIELD-SYMBOL(<comp>).
        READ TABLE mt_component_conv_cls WITH KEY component = <comp> TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          APPEND <comp> TO lt_missing_comp.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    SORT lt_missing_comp.
    DELETE ADJACENT DUPLICATES FROM lt_missing_comp.
    CHECK lt_missing_comp IS NOT INITIAL.

    SELECT name conv_class INTO CORRESPONDING FIELDS OF TABLE lt_objects FROM crmc_objects FOR ALL ENTRIES IN lt_missing_comp
        WHERE name = lt_missing_comp-table_line.

    LOOP AT lt_missing_comp ASSIGNING FIELD-SYMBOL(<missing_comp>).
      APPEND INITIAL LINE TO mt_component_conv_cls ASSIGNING FIELD-SYMBOL(<new_buffer>).
      <new_buffer>-component = <missing_comp>.
      READ TABLE lt_objects ASSIGNING FIELD-SYMBOL(<crm_object>) WITH KEY name = <missing_comp>.
      ASSERT sy-subrc = 0.
      <new_buffer>-conv_cls = <crm_object>-conv_class.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->FETCH_ITEM_SUPPORTED_COMP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ITEM_WRKT                   TYPE        CRMT_ORDERADM_I_WRKT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fetch_item_supported_comp.
    DATA: lt_missed_item_object_type TYPE TABLE OF crmt_subobject_category_db,
          lt_item_supported_compo    TYPE TABLE OF crmc_obj_assi_i.

    LOOP AT it_item_wrkt ASSIGNING FIELD-SYMBOL(<item>).
      READ TABLE mt_item_supported_comps WITH KEY object_type = <item>-object_type
       TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        APPEND <item>-object_type TO lt_missed_item_object_type.
      ENDIF.
    ENDLOOP.

    SORT lt_missed_item_object_type.
    DELETE ADJACENT DUPLICATES FROM lt_missed_item_object_type.
    CHECK lt_missed_item_object_type IS NOT INITIAL.

    SELECT * INTO TABLE lt_item_supported_compo FROM crmc_obj_assi_i
        FOR ALL ENTRIES IN lt_missed_item_object_type WHERE
      subobj_category = lt_missed_item_object_type-table_line.

    LOOP AT lt_missed_item_object_type ASSIGNING FIELD-SYMBOL(<miss_item_obj_type>).
      APPEND INITIAL LINE TO mt_item_supported_comps ASSIGNING FIELD-SYMBOL(<new_buffer>).
      <new_buffer>-object_type = <miss_item_obj_type>.
      LOOP AT lt_item_supported_compo ASSIGNING FIELD-SYMBOL(<support_comp>)
          WHERE subobj_category = <miss_item_obj_type>.
        INSERT <support_comp>-name INTO TABLE <new_buffer>-supported_comps.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_CONVERTOR_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CLS_NAME                    TYPE        CRMT_OBJECT_NAME
* | [<-()] RO_CONVERTOR                   TYPE REF TO IF_CRMS4_BTX_DATA_MODEL_CONV
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_convertor_instance.
    READ TABLE mt_convertor_inst_buffer ASSIGNING FIELD-SYMBOL(<convertor>) WITH KEY cls_name = iv_cls_name.
    IF sy-subrc = 0.
      ro_convertor = <convertor>-convertor.
      RETURN.
    ENDIF.

    CREATE OBJECT ro_convertor TYPE (iv_cls_name).
    APPEND INITIAL LINE TO mt_convertor_inst_buffer ASSIGNING FIELD-SYMBOL(<new_convertor>).
    <new_convertor> = VALUE ty_convertor_instance( cls_name = iv_cls_name convertor = ro_convertor ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_CONV_CLS_NAME_BY_COMPONENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_COMPONENT_NAME              TYPE        CRMT_OBJECT_NAME
* | [<-()] RV_CLS_NAME                    TYPE        CRMT_OBJECT_NAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_conv_cls_name_by_component.
    READ TABLE mt_component_conv_cls ASSIGNING FIELD-SYMBOL(<buffer>)
     WITH KEY component = iv_component_name.
    rv_cls_name = <buffer>-conv_cls.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_HEADER_DB_BUFFER_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID
* | [<-()] RV_DB_TYPE                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_header_db_buffer_type.
    DATA(lv_object_type) = get_header_object_type_by_guid( iv_header_guid ).
    DATA: ls_zcrmc_subob_cat TYPE crmc_subob_cat.

    SELECT SINGLE * INTO ls_zcrmc_subob_cat FROM crmc_subob_cat
       WHERE subobj_category = lv_object_type.
    ASSERT sy-subrc = 0.
    rv_db_type = 'CRMS4T_' && ls_zcrmc_subob_cat-acronym && '_H_DB_WRK'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_HEADER_DB_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID
* | [<-()] RV_DB_TYPE                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_header_db_type.
    DATA(lv_object_type) = get_header_object_type_by_guid( iv_header_guid ).
    DATA: ls_zcrmc_subob_cat TYPE crmc_subob_cat.

    SELECT SINGLE * INTO ls_zcrmc_subob_cat FROM crmc_subob_cat
       WHERE subobj_category = lv_object_type.
    ASSERT sy-subrc = 0.
    rv_db_type = 'CRMS4D_' && ls_zcrmc_subob_cat-acronym && '_H'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_HEADER_OBJECT_TYPE_BY_GUID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID
* | [<-()] RV_OBJECT_TYPE                 TYPE        CRMT_SUBOBJECT_CATEGORY_DB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_header_object_type_by_guid.
    DATA: ls_header TYPE crmt_orderadm_h_wrk.
    READ TABLE mt_header_object_type_buf ASSIGNING FIELD-SYMBOL(<header_type>)
     WITH KEY guid = iv_header_guid.
    IF sy-subrc = 0.
      rv_object_type = <header_type>-object_type.
      RETURN.
    ENDIF.

    CALL FUNCTION 'CRM_ORDERADM_H_READ_OB'
      EXPORTING
        iv_guid           = iv_header_guid
      IMPORTING
        es_orderadm_h_wrk = ls_header.

    APPEND INITIAL LINE TO mt_header_object_type_buf ASSIGNING FIELD-SYMBOL(<buffer>).
    <buffer>-guid = iv_header_guid.
    <buffer>-object_type = ls_header-object_type.
    rv_object_type = ls_header-object_type.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_HEADER_SUPPORTED_COMP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER_OBJECT_TYPE          TYPE        CRMT_SUBOBJECT_CATEGORY_DB
* | [<-()] RT_HEADER_SUPPORTED_COMP       TYPE        CRMT_OBJECT_NAME_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_header_supported_comp.
    READ TABLE mt_header_supported_comps ASSIGNING FIELD-SYMBOL(<supported>)
     WITH KEY object_type = iv_header_object_type.

    CHECK sy-subrc = 0.

    rt_header_supported_comp = <supported>-supported_comps.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_CRMS4_BT_DATA_MODEL_TOOL=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_INSTANCE                    TYPE REF TO CL_CRMS4_BT_DATA_MODEL_TOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_instance.
    ro_instance = so_instance.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_ITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ITEM_GUID                   TYPE        CRMT_OBJECT_GUID_TAB
* | [<---] ET_ORDERADM_I_DB               TYPE        CRMT_ORDERADM_I_DU_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_item.
    DATA: lt_btx_i   TYPE TABLE OF crms4d_btx_i,
          lt_acronym TYPE TABLE OF crmc_subob_cat_i,
          lr_dbtab   TYPE REF TO data,
          lt_objects TYPE crmt_object_name_tab,
          ls_item    LIKE LINE OF et_orderadm_i_db.

    FIELD-SYMBOLS: <lt_dbtab>         TYPE ANY TABLE.

    CHECK it_item_guid IS NOT INITIAL.

    SELECT  * INTO TABLE lt_btx_i FROM crms4d_btx_i FOR ALL ENTRIES IN
       it_item_guid WHERE item_guid = it_item_guid-table_line.

    CHECK sy-subrc = 0.

    SELECT * FROM crmc_subob_cat_i INTO TABLE lt_acronym
       FOR ALL ENTRIES IN lt_btx_i
         WHERE subobj_category = lt_btx_i-object_type.

* Jerry 2017-04-21 14:21PM for POC, I assume all items belong to the same item table
* Jerry 2017-04-25 9:21AM - one order can have multiple item with different item object type!!!
* this scenario needs to be enhanced later!!
    ASSERT lines( lt_acronym ) = 1.
    READ TABLE lt_btx_i INTO DATA(ls_btx_i) INDEX 1.

    READ TABLE lt_acronym ASSIGNING FIELD-SYMBOL(<acronym>) INDEX 1.

    DATA(lv_dbtab_name) = 'CRMS4D_' && <acronym>-acronym && '_I'.

    CREATE DATA lr_dbtab TYPE TABLE OF (lv_dbtab_name).
    ASSIGN lr_dbtab->* TO <lt_dbtab>.

    SELECT  * FROM (lv_dbtab_name) INTO TABLE <lt_dbtab> FOR ALL ENTRIES IN
        it_item_guid WHERE guid = it_item_guid-table_line.

    CHECK sy-subrc = 0.

* Get all possible components for the given header object type
    SELECT name FROM crmc_obj_assi_i INTO TABLE lt_objects WHERE subobj_category = ls_btx_i-object_type.

    LOOP AT <lt_dbtab> ASSIGNING FIELD-SYMBOL(<ls_dbtab>).
      conv_s4_2_1order_and_fill_buff( EXPORTING it_objects = lt_objects
                           CHANGING cs_item = <ls_dbtab> ).
* Jerry 2017-05-03 10:05AM - <ls_dbtab> has format such as CRMS4D_SALE_I, should not directly put to et_orderadm_i_db.
      MOVE-CORRESPONDING <ls_dbtab> TO ls_item.
      INSERT ls_item INTO TABLE et_orderadm_i_db.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_ITEM_DB_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ITEM_OBJECT_TYPE            TYPE        CRMT_SUBOBJECT_CATEGORY_DB
* | [<-()] RV_DB_TYPE                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_item_db_type.

    DATA: ls_zcrmc_subob_cat TYPE crmc_subob_cat_i.

    SELECT SINGLE * INTO ls_zcrmc_subob_cat FROM crmc_subob_cat_i
       WHERE subobj_category = iv_item_object_type.
    ASSERT sy-subrc = 0.
    rv_db_type = 'CRMS4D_' && ls_zcrmc_subob_cat-acronym && '_I'.

    READ TABLE mt_acronym ASSIGNING FIELD-SYMBOL(<acronum>)
      WITH KEY subobj_category = iv_item_object_type.
    IF sy-subrc <> 0.
      APPEND ls_zcrmc_subob_cat TO mt_acronym.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_ITEM_SUPPORTED_COMP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ITEM_OBJECT_TYPE            TYPE        CRMT_SUBOBJECT_CATEGORY_DB
* | [<-()] RT_ITEM_SUPPORTED_COMP         TYPE        CRMT_OBJECT_NAME_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_item_supported_comp.
    READ TABLE mt_item_supported_comps ASSIGNING FIELD-SYMBOL(<supported>)
     WITH KEY object_type = iv_item_object_type.

    CHECK sy-subrc = 0.

    rt_item_supported_comp = <supported>-supported_comps.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_UNSORTED_COMPONENT_LIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_SORTED_COMP                 TYPE        CRMT_OBJECT_NAME_TAB
* | [--->] IV_HEADER                      TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [<-()] RT_UNSORTED_COMP               TYPE        TT_SUPPORTED_COMPONENTS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_unsorted_component_list.
    DATA: lv_line TYPE crmt_object_name.
    rt_unsorted_comp = it_sorted_comp.
    IF iv_header = abap_true.
      DELETE rt_unsorted_comp WHERE table_line = 'ORDERADM_H'.
      lv_line = 'ORDERADM_H'.
    ELSE.
      DELETE rt_unsorted_comp WHERE table_line = 'ORDERADM_I'.
      lv_line = 'ORDERADM_I'.
    ENDIF.

    INSERT lv_line INTO rt_unsorted_comp INDEX 1.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_DATA_MODEL_TOOL->MERGE_CHANGE_2_GLOBAL_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_CURRENT_INSERT              TYPE        ANY TABLE
* | [--->] IT_CURRENT_UPDATE              TYPE        ANY TABLE
* | [--->] IT_CURRENT_DELETE              TYPE        ANY TABLE(optional)
* | [<-->] CT_GLOBAL_INSERT               TYPE        ANY TABLE
* | [<-->] CT_GLOBAL_UPDATE               TYPE        ANY TABLE
* | [<-->] CT_GLOBAL_DELETE               TYPE        ANY TABLE(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD merge_change_2_global_buffer.
    DATA: lr_new_line TYPE REF TO data.

    FIELD-SYMBOLS:<i_update>      TYPE ANY TABLE,
                  <i_insert>      TYPE ANY TABLE,
                  <i_delete>      TYPE ANY TABLE,
                  <new_line_item> TYPE any.

* ct_* can have different table type like CRMS4D_SALE_I_T, CRMS4D_SVPR_I_T
* Jerry 2017-04-26 12:11PM only support update currently

    DATA(lr_to_update) = REF #( ct_global_update ).
    ASSIGN lr_to_update->* TO <i_update>.
    LOOP AT it_current_update ASSIGNING FIELD-SYMBOL(<update>).
      LOOP AT <i_update> ASSIGNING FIELD-SYMBOL(<update_queue>).
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <update_queue> TO
           FIELD-SYMBOL(<update_record_in_queue>).
        CHECK sy-subrc = 0.
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <update> TO
           FIELD-SYMBOL(<currently_determined_update>).
        CHECK sy-subrc = 0.
        IF <update_record_in_queue> = <currently_determined_update>.
          MOVE-CORRESPONDING <update> TO <update_queue>.
        ENDIF.
      ENDLOOP.
      IF <i_update> IS INITIAL.
        CREATE DATA lr_new_line LIKE LINE OF ct_global_update.
        ASSIGN lr_new_line->* TO <new_line_item>.
        MOVE-CORRESPONDING <update> TO <new_line_item>.
        INSERT <new_line_item> INTO TABLE <i_update>.
      ENDIF.
    ENDLOOP.

    DATA(lr_to_insert) = REF #( ct_global_insert ).
    ASSIGN lr_to_insert->* TO <i_insert>.
    LOOP AT it_current_insert ASSIGNING FIELD-SYMBOL(<insert>).
      LOOP AT <i_insert> ASSIGNING FIELD-SYMBOL(<insert_queue>).
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <insert_queue> TO
           FIELD-SYMBOL(<insert_record_in_queue>).
        CHECK sy-subrc = 0.
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <insert> TO
           FIELD-SYMBOL(<currently_determined_insert>).
        CHECK sy-subrc = 0.
        IF <insert_record_in_queue> = <currently_determined_insert>.
          MOVE-CORRESPONDING <insert> TO <insert_queue>.
        ENDIF.
      ENDLOOP.
      IF <i_insert> IS INITIAL.
* Jerry 2017-05-04 10:56AM - reason for this code:
* https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/36
        CREATE DATA lr_new_line LIKE LINE OF ct_global_insert.
        ASSIGN lr_new_line->* TO <new_line_item>.
        MOVE-CORRESPONDING <insert> TO <new_line_item>.
        INSERT <new_line_item> INTO TABLE <i_insert>.
      ENDIF.
    ENDLOOP.

* Jerry 2017-05-09 18:53PM - delete
    DATA(lr_to_delete) = REF #( ct_global_delete ).
    ASSIGN lr_to_delete->* TO <i_delete>.
    LOOP AT it_current_delete ASSIGNING FIELD-SYMBOL(<delete>).
      LOOP AT <i_delete> ASSIGNING FIELD-SYMBOL(<delete_queue>).
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <delete_queue> TO
           FIELD-SYMBOL(<delete_record_in_queue>).
        CHECK sy-subrc = 0.
        ASSIGN COMPONENT 'GUID' OF STRUCTURE <delete> TO
           FIELD-SYMBOL(<currently_determined_delete>).
        CHECK sy-subrc = 0.
        IF <delete_record_in_queue> = <currently_determined_delete>.
          MOVE-CORRESPONDING <delete> TO <delete_queue>.
        ENDIF.
      ENDLOOP.
      IF <i_delete> IS INITIAL.
* Jerry 2017-05-04 10:56AM - reason for this code:
* https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/36
        CREATE DATA lr_new_line LIKE LINE OF ct_global_delete.
        ASSIGN lr_new_line->* TO <new_line_item>.
        MOVE-CORRESPONDING <delete> TO <new_line_item>.
        INSERT <new_line_item> INTO TABLE <i_delete>.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->MERGE_LOCAL_CHANGE_2_GLOBAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CURRENT_INSERT              TYPE        ANY(optional)
* | [--->] IS_CURRENT_UPDATE              TYPE        ANY(optional)
* | [--->] IS_CURRENT_DELETE              TYPE        ANY(optional)
* | [<-->] CT_GLOBAL_INSERT               TYPE        ANY TABLE
* | [<-->] CT_GLOBAL_UPDATE               TYPE        ANY TABLE
* | [<-->] CT_GLOBAL_DELETE               TYPE        ANY TABLE(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD merge_local_change_2_global.
    DATA: lr_new_line TYPE REF TO data.

    FIELD-SYMBOLS:<i_update>      TYPE ANY TABLE,
                  <i_insert>      TYPE ANY TABLE,
                  <i_delete>      TYPE ANY TABLE,
                  <new_line_item> TYPE any.

* ct_* can have different table type like CRMS4D_SALE_I_T, CRMS4D_SVPR_I_T
* Jerry 2017-04-26 12:11PM only support update currently

    DATA(lr_to_update) = REF #( ct_global_update ).
    ASSIGN lr_to_update->* TO <i_update>.
    LOOP AT <i_update> ASSIGNING FIELD-SYMBOL(<update_queue>).
      ASSIGN COMPONENT 'GUID' OF STRUCTURE <update_queue> TO
         FIELD-SYMBOL(<update_record_in_queue>).
      ASSERT sy-subrc = 0.
      ASSIGN COMPONENT 'GUID' OF STRUCTURE is_current_update TO
         FIELD-SYMBOL(<currently_determined_update>).
      ASSERT sy-subrc = 0.
      IF <update_record_in_queue> = <currently_determined_update>.
        MOVE-CORRESPONDING is_current_update TO <update_queue>.
      ENDIF.
    ENDLOOP.
    IF <i_update> IS INITIAL AND is_current_update IS NOT INITIAL.
      CREATE DATA lr_new_line LIKE LINE OF ct_global_update.
      ASSIGN lr_new_line->* TO <new_line_item>.
      MOVE-CORRESPONDING is_current_update TO <new_line_item>.
      INSERT <new_line_item> INTO TABLE <i_update>.
    ENDIF.

********** END OF update

    DATA(lr_to_insert) = REF #( ct_global_insert ).
    ASSIGN lr_to_insert->* TO <i_insert>.
    LOOP AT <i_insert> ASSIGNING FIELD-SYMBOL(<insert_queue>).
      ASSIGN COMPONENT 'GUID' OF STRUCTURE <insert_queue> TO
         FIELD-SYMBOL(<insert_record_in_queue>).
      ASSERT sy-subrc = 0.
      ASSIGN COMPONENT 'GUID' OF STRUCTURE is_current_insert TO
         FIELD-SYMBOL(<currently_determined_insert>).
      ASSERT sy-subrc = 0.
      IF <insert_record_in_queue> = <currently_determined_insert>.
        MOVE-CORRESPONDING is_current_insert TO <insert_queue>.
      ENDIF.
    ENDLOOP.
    IF <i_insert> IS INITIAL AND is_current_insert IS NOT INITIAL.
* Jerry 2017-05-04 10:56AM - reason for this code:
* https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/36
      CREATE DATA lr_new_line LIKE LINE OF ct_global_insert.
      ASSIGN lr_new_line->* TO <new_line_item>.
      MOVE-CORRESPONDING is_current_insert TO <new_line_item>.
      INSERT <new_line_item> INTO TABLE <i_insert>.
    ENDIF.

* Jerry 2017-05-09 18:53PM - delete
    DATA(lr_to_delete) = REF #( ct_global_delete ).
    ASSIGN lr_to_delete->* TO <i_delete>.
    LOOP AT <i_delete> ASSIGNING FIELD-SYMBOL(<delete_queue>).
      ASSIGN COMPONENT 'GUID' OF STRUCTURE <delete_queue> TO
         FIELD-SYMBOL(<delete_record_in_queue>).
      ASSERT sy-subrc = 0.
      ASSIGN COMPONENT 'GUID' OF STRUCTURE is_current_delete TO
         FIELD-SYMBOL(<currently_determined_delete>).
      ASSERT sy-subrc = 0.
      IF <delete_record_in_queue> = <currently_determined_delete>.
        MOVE-CORRESPONDING is_current_delete TO <delete_queue>.
      ENDIF.
    ENDLOOP.
    IF <i_delete> IS INITIAL AND is_current_delete IS NOT INITIAL.
* Jerry 2017-05-04 10:56AM - reason for this code:
* https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/36
      CREATE DATA lr_new_line LIKE LINE OF ct_global_delete.
      ASSIGN lr_new_line->* TO <new_line_item>.
      MOVE-CORRESPONDING is_current_delete TO <new_line_item>.
      INSERT <new_line_item> INTO TABLE <i_delete>.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_DATA_MODEL_TOOL->SAVE_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_header.
    fetch_header_object_type( it_header_guid ).
    fetch_header_supported_comp( ).
    fetch_component_conv_cls( ).
    LOOP AT it_header_guid ASSIGNING FIELD-SYMBOL(<guid>).
      save_single_header( <guid> ).
      save_single_items( <guid> ).
    ENDLOOP.
    cleanup( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->SAVE_SINGLE_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_single_header.

* Jerry: global change
    DATA: lr_to_insert_db TYPE REF TO data,
          lr_to_update_db TYPE REF TO data,
          lr_to_delete_db TYPE REF TO data,
          lr_cur_change   TYPE REF TO data.

* Jerry: local change
    DATA: lr_local_insert TYPE REF TO data,
          lr_local_update TYPE REF TO data,
          lr_local_delete TYPE REF TO data.
* Jerry: global change buffer
    FIELD-SYMBOLS: <to_insert> TYPE ANY TABLE,
                   <to_update> TYPE ANY TABLE,
                   <to_delete> TYPE ANY TABLE.
* Jerry: local change buffer
    FIELD-SYMBOLS:
      <current_change> TYPE any,
      <current_insert> TYPE any,
      <current_update> TYPE any,
      <current_delete> TYPE any.


    DATA(lv_object_type) = get_header_object_type_by_guid( iv_header_guid ).
    DATA(lt_header_supported_comp) = get_header_supported_comp( lv_object_type ).
    DATA(lt_unsorted) = get_unsorted_component_list( lt_header_supported_comp ).
    DATA(lv_comp_db_name) = get_header_db_type( iv_header_guid ).

    CREATE DATA lr_to_insert_db TYPE TABLE OF (lv_comp_db_name).
    ASSIGN lr_to_insert_db->* TO <to_insert>.

    CREATE DATA lr_to_update_db TYPE TABLE OF (lv_comp_db_name).
    ASSIGN lr_to_update_db->* TO <to_update>.

    CREATE DATA lr_to_delete_db TYPE TABLE OF (lv_comp_db_name).
    ASSIGN lr_to_delete_db->* TO <to_delete>.

    determine_head_change_mode( iv_header_guid ).
    LOOP AT lt_unsorted ASSIGNING FIELD-SYMBOL(<component>).
* Jerry 2017-05-03 16:39PM ignore ORDERADM_I in this method
* If ORDERADM_I is not assigned to header object type like BUS2000116, there is some validation
* error
      CHECK <component> <> 'ORDERADM_I'.

      DATA(lv_conv_cls) = get_conv_cls_name_by_component( <component> ).
      CHECK lv_conv_cls IS NOT INITIAL.

      DATA(lo_convertor) = get_convertor_instance( lv_conv_cls ).

      DATA(lv_comp_type) = lo_convertor->get_wrk_structure_name( ).
      CREATE DATA lr_cur_change TYPE (lv_comp_type).
      ASSIGN lr_cur_change->* TO <current_change>.
      CALL METHOD lo_convertor->convert_1o_to_s4
        EXPORTING
          iv_ref_guid  = iv_header_guid
          iv_ref_kind  = 'A'
        CHANGING
          ct_to_insert = <to_insert>
          ct_to_update = <to_update>
          ct_to_delete = <to_delete>
          cs_workarea  = <current_change>.

      IF <current_change> IS INITIAL.
        CONTINUE.
      ENDIF.

      CREATE DATA lr_local_insert TYPE (lv_comp_type).
      CREATE DATA lr_local_update TYPE (lv_comp_type).
      CREATE DATA lr_local_delete TYPE (lv_comp_type).

      ASSIGN lr_local_insert->* TO <current_insert>.
      ASSIGN lr_local_update->* TO <current_update>.
      ASSIGN lr_local_delete->* TO <current_delete>.

      CASE mv_current_head_mode.
        WHEN 'A'.
          ASSIGN <current_change> TO <current_insert>.
        WHEN 'B'.
          ASSIGN <current_change> TO <current_update>.
      ENDCASE.

      CALL METHOD merge_local_change_2_global
        EXPORTING
          is_current_insert = <current_insert>
          is_current_update = <current_update>
          is_current_delete = <current_delete>
        CHANGING
          ct_global_insert  = <to_insert>
          ct_global_update  = <to_update>
          ct_global_delete  = <to_delete>.
    ENDLOOP.

    detect_change_revert( EXPORTING iv_order_db_buffer_name = get_header_db_buffer_type( iv_header_guid )
                          CHANGING  ct_to_update = <to_update> ).

    CALL FUNCTION 'CRM_SRVO_H_UPDATE_DU' IN UPDATE TASK
      EXPORTING
        it_to_insert = <to_insert>
        it_to_update = <to_update>
        it_to_delete = <to_delete>.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->SAVE_SINGLE_ITEMS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_single_items.
    DATA: lt_orderadm_i_wrk TYPE crmt_orderadm_i_wrkt,
          lt_objects        TYPE crmt_object_name_tab,
          ls_item_update    TYPE crms4s_btx_i_update_records.

    DATA: lr_to_insert_db TYPE REF TO data,
          lr_to_update_db TYPE REF TO data,
          lr_to_delete_db TYPE REF TO data.

* global update buffer
    FIELD-SYMBOLS: <to_insert> TYPE ANY TABLE,
                   <to_update> TYPE ANY TABLE,
                   <to_delete> TYPE ANY TABLE.
* Jerry 2017-05-12: local change buffer
    FIELD-SYMBOLS:
      <current_change> TYPE any,
      <current_insert> TYPE any,
      <current_update> TYPE any,
      <current_delete> TYPE any.

* Jerry 2017-05-12 6:14PM : local change
    DATA: lr_local_insert TYPE REF TO data,
          lr_local_update TYPE REF TO data,
          lr_local_delete TYPE REF TO data,
          lr_cur_change   TYPE REF TO data.

    CALL FUNCTION 'CRM_ORDERADM_I_READ_OB'
      EXPORTING
        iv_header                = iv_header_guid
        iv_include_deleted_items = 'X'
      IMPORTING
        et_orderadm_i_wrk        = lt_orderadm_i_wrk
      EXCEPTIONS
        OTHERS                   = 0.

* Jerry 2017-05-09 5:13PM - only deal with item whose change flag = X
    DELETE lt_orderadm_i_wrk WHERE item_changed <> 'X'.
    fetch_item_supported_comp( lt_orderadm_i_wrk ).
    fetch_item_conv_class( ).

    LOOP AT lt_orderadm_i_wrk ASSIGNING FIELD-SYMBOL(<orderadm_i_wrk>).

      DATA(lt_item_supported_comp) = get_item_supported_comp( <orderadm_i_wrk>-object_type ).
* Jerry 2017-05-09: make sure ORDERADM_I get processed IN THE FIRST POSITION
* This might not be a good design to introduce dependency on execution sequence,
* However from semantic point of view, ORDERADM_I should be processed before any other item component.
      DATA(lt_unsorted) = get_unsorted_component_list( it_sorted_comp = lt_item_supported_comp
                                                       iv_header      = abap_false ).

* Jerry 2017-05-03 12:08PM each item can have different item object type
* and thus the corresponding item table could be different
* CRMS4D_SVPR_I, CRMS4D_SALE_I etc
      DATA(lv_comp_db_name) = get_item_db_type( <orderadm_i_wrk>-object_type ).
      CREATE DATA lr_to_insert_db TYPE TABLE OF (lv_comp_db_name).
      ASSIGN lr_to_insert_db->* TO <to_insert>.

      CREATE DATA lr_to_update_db TYPE TABLE OF (lv_comp_db_name).
      ASSIGN lr_to_update_db->* TO <to_update>.

      CREATE DATA lr_to_delete_db TYPE TABLE OF (lv_comp_db_name).
      ASSIGN lr_to_delete_db->* TO <to_delete>.

      me->mv_current_item_mode = <orderadm_i_wrk>-mode.
      LOOP AT lt_unsorted ASSIGNING FIELD-SYMBOL(<comp>).
        DATA(lv_conv_class) = get_conv_cls_name_by_component( <comp> ).
        CHECK lv_conv_class IS NOT INITIAL.
        DATA(lo_conv_class) = get_convertor_instance( lv_conv_class ).
        DATA(lv_comp_workarea) = lo_conv_class->get_wrk_structure_name( ).
        CREATE DATA lr_cur_change TYPE (lv_comp_workarea).
        ASSIGN lr_cur_change->* TO <current_change>.
        CALL METHOD lo_conv_class->convert_1o_to_s4
          EXPORTING
            iv_ref_guid = <orderadm_i_wrk>-guid
            iv_ref_kind = 'B'
          CHANGING
            cs_workarea = <current_change>.

        IF <current_change> IS INITIAL.
          CONTINUE.
        ENDIF.

        CREATE DATA lr_local_insert TYPE (lv_comp_workarea).
        CREATE DATA lr_local_update TYPE (lv_comp_workarea).
        CREATE DATA lr_local_delete TYPE (lv_comp_workarea).

        ASSIGN lr_local_insert->* TO <current_insert>.
        ASSIGN lr_local_update->* TO <current_update>.
        ASSIGN lr_local_delete->* TO <current_delete>.

        CASE mv_current_item_mode.
          WHEN 'A'.
            ASSIGN <current_change> TO <current_insert>.
          WHEN 'B'.
            ASSIGN <current_change> TO <current_update>.
          WHEN 'D'.
            ASSIGN <current_change> TO <current_delete>.
        ENDCASE.

        CALL METHOD merge_local_change_2_global
          EXPORTING
            is_current_insert = <current_insert>
            is_current_update = <current_update>
            is_current_delete = <current_delete>
          CHANGING
            ct_global_insert  = <to_insert>
            ct_global_update  = <to_update>
            ct_global_delete  = <to_delete>.
      ENDLOOP.

      READ TABLE mt_acronym ASSIGNING FIELD-SYMBOL(<acronym>) WITH KEY
         subobj_category = <orderadm_i_wrk>-object_type.
      ASSERT sy-subrc = 0.

      ASSIGN COMPONENT <acronym>-acronym OF STRUCTURE ls_item_update TO FIELD-SYMBOL(<update_data>).
      ASSERT sy-subrc = 0.
      FIELD-SYMBOLS:<tab_for_insert> TYPE ANY TABLE,
                    <tab_for_update> TYPE ANY TABLE,
                    <tab_for_delete> TYPE ANY TABLE.
      DATA(lv_insert_field) = |{ <acronym>-acronym }_INSERT|.
      DATA(lv_update_field) = |{ <acronym>-acronym }_UPDATE|.
      DATA(lv_delete_field) = |{ <acronym>-acronym }_DELETE|.
      ASSIGN COMPONENT lv_insert_field OF STRUCTURE <update_data> TO <tab_for_insert>.
      ASSIGN COMPONENT lv_update_field OF STRUCTURE <update_data> TO <tab_for_update>.
      ASSIGN COMPONENT lv_delete_field OF STRUCTURE <update_data> TO <tab_for_delete>.

      IF <to_insert> IS NOT INITIAL.
        INSERT LINES OF <to_insert> INTO TABLE <tab_for_insert>.
      ENDIF.

      IF <to_update> IS NOT INITIAL.
        INSERT LINES OF <to_update> INTO TABLE <tab_for_update>.
      ENDIF.

      IF <to_delete> IS NOT INITIAL.
        INSERT LINES OF <to_delete> INTO TABLE <tab_for_delete>.
      ENDIF.

    ENDLOOP.
* Jerry 2017-05-09 5:53PM - save multiple item belonging to a given order at ONE SHOT
    CALL FUNCTION 'CRM_BTX_I_UPDATE_DU' IN UPDATE TASK
      EXPORTING
        is_update_record = ls_item_update.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_DATA_MODEL_TOOL->SET_CURRENT_ITEM_MODE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MODE                        TYPE        CRMT_MODE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_current_item_mode.
    me->mv_current_item_mode = iv_mode.
  ENDMETHOD.
ENDCLASS.