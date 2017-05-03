class CL_CRMS4_BT_DATA_MODEL_TOOL definition
  public
  final
  create private .

public section.

  methods SAVE_HEADER
    importing
      !IT_HEADER_GUID type CRMT_OBJECT_GUID_TAB .
  class-methods CLASS_CONSTRUCTOR .
  methods GET_ITEM
    importing
      !IT_ITEM_GUID type CRMT_OBJECT_GUID_TAB
    exporting
      !ET_ORDERADM_I_DB type CRMT_ORDERADM_I_DU_TAB .
  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to CL_CRMS4_BT_DATA_MODEL_TOOL .
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
    tt_supported_components TYPE STANDARD TABLE OF crmt_object_name WITH KEY table_line .
  types:
    tt_component_conv_cls TYPE TABLE OF ty_component_conv_cls WITH KEY component .

  data MT_CONVERTOR_INST_BUFFER type TT_CONVERTOR_INSTANCE .
  data MT_COMPONENT_CONV_CLS type TT_COMPONENT_CONV_CLS .
  class-data SO_INSTANCE type ref to CL_CRMS4_BT_DATA_MODEL_TOOL .
  data MT_HEADER_OBJECT_TYPE_BUF type TT_HEADER_OBJECT_TYPE .
  data MT_HEADER_SUPPORTED_COMPS type TT_OBJECT_SUPPORTED_COMPONENT .
  data MT_ITEM_SUPPORTED_COMPS type TT_OBJECT_SUPPORTED_COMPONENT .
  data mt_acronym TYPE STANDARD TABLE OF CRMC_SUBOB_CAT_I.
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
      value(RO_CONVERTOR) type ref to if_crms4_btx_data_model_conv .
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
ENDCLASS.



CLASS CL_CRMS4_BT_DATA_MODEL_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method CL_CRMS4_BT_DATA_MODEL_TOOL=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD CLASS_CONSTRUCTOR.
    so_instance = NEW #( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->CONV_S4_2_1ORDER_AND_FILL_BUFF
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OBJECTS                     TYPE        CRMT_OBJECT_NAME_TAB
* | [<-->] CS_ITEM                        TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD CONV_S4_2_1ORDER_AND_FILL_BUFF.
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
          is_wrk_structure = <ls_wrk_structure>.

    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->FETCH_COMPONENT_CONV_CLS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD FETCH_COMPONENT_CONV_CLS.
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
  METHOD FETCH_HEADER_OBJECT_TYPE.
    DATA: lt_header_buffer_miss TYPE crmt_object_guid_tab,
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
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->FETCH_HEADER_SUPPORTED_COMP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD FETCH_HEADER_SUPPORTED_COMP.
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
  METHOD FETCH_ITEM_CONV_CLASS.
    DATA: lt_missing_comp TYPE TABLE OF CRMT_OBJECT_NAME,
          lt_objects TYPE TABLE OF CRMC_OBJECTS.

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

    SELECT name conv_class INTO CORRESPONDING FIELDS OF TABLE lt_objects FROM CRMC_OBJECTS FOR ALL ENTRIES IN lt_missing_comp
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
  METHOD FETCH_ITEM_SUPPORTED_COMP.
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
  METHOD GET_CONVERTOR_INSTANCE.
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
  METHOD GET_CONV_CLS_NAME_BY_COMPONENT.
    READ TABLE mt_component_conv_cls ASSIGNING FIELD-SYMBOL(<buffer>)
     WITH KEY component = iv_component_name.
    rv_cls_name = <buffer>-conv_cls.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_HEADER_DB_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID
* | [<-()] RV_DB_TYPE                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD GET_HEADER_DB_TYPE.
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
  METHOD GET_HEADER_SUPPORTED_COMP.
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
  METHOD GET_INSTANCE.
    ro_instance = so_instance.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_ITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ITEM_GUID                   TYPE        CRMT_OBJECT_GUID_TAB
* | [<---] ET_ORDERADM_I_DB               TYPE        CRMT_ORDERADM_I_DU_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD GET_ITEM.
    DATA: lt_btx_i   TYPE TABLE OF crms4d_btx_i,
          lt_acronym TYPE TABLE OF CRMC_SUBOB_CAT_I,
          lr_dbtab   TYPE REF TO data,
          lt_objects TYPE crmt_object_name_tab.

    FIELD-SYMBOLS: <lt_dbtab>         TYPE ANY TABLE.

    CHECK it_item_guid IS NOT INITIAL.

    SELECT  * INTO TABLE lt_btx_i FROM crms4d_btx_i FOR ALL ENTRIES IN
       it_item_guid WHERE item_guid = it_item_guid-table_line.

    CHECK sy-subrc = 0.

    SELECT * FROM CRMC_SUBOB_CAT_I INTO TABLE lt_acronym
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
      APPEND <ls_dbtab> TO et_orderadm_i_db.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->GET_ITEM_DB_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ITEM_OBJECT_TYPE            TYPE        CRMT_SUBOBJECT_CATEGORY_DB
* | [<-()] RV_DB_TYPE                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD GET_ITEM_DB_TYPE.

    DATA: ls_zcrmc_subob_cat TYPE CRMC_SUBOB_CAT_I.

    SELECT SINGLE * INTO ls_zcrmc_subob_cat FROM CRMC_SUBOB_CAT_I
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
  METHOD GET_ITEM_SUPPORTED_COMP.
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
  METHOD GET_UNSORTED_COMPONENT_LIST.
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
* | Instance Public Method CL_CRMS4_BT_DATA_MODEL_TOOL->SAVE_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD SAVE_HEADER.
    fetch_header_object_type( it_header_guid ).
    fetch_header_supported_comp( ).
    fetch_component_conv_cls( ).
    LOOP AT it_header_guid ASSIGNING FIELD-SYMBOL(<guid>).
      save_single_header( <guid> ).
      save_single_items( <guid> ).
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRMS4_BT_DATA_MODEL_TOOL->SAVE_SINGLE_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD SAVE_SINGLE_HEADER.

    DATA: lr_to_insert_db TYPE REF TO data,
          lr_to_update_db TYPE REF TO data,
          lr_to_delete_db TYPE REF TO data.

    FIELD-SYMBOLS: <to_insert> TYPE ANY TABLE,
                   <to_update> TYPE ANY TABLE,
                   <to_delete> TYPE ANY TABLE.

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
    LOOP AT lt_unsorted ASSIGNING FIELD-SYMBOL(<component>).
      DATA(lv_conv_cls) = get_conv_cls_name_by_component( <component> ).
      CHECK lv_conv_cls IS NOT INITIAL.

      DATA(lo_convertor) = get_convertor_instance( lv_conv_cls ).

      CALL METHOD lo_convertor->convert_1o_to_s4
        EXPORTING
          iv_ref_guid  = iv_header_guid
          iv_ref_kind  = 'A'
        CHANGING
          ct_to_insert = <to_insert>
          ct_to_update = <to_update>
          ct_to_delete = <to_delete>.
    ENDLOOP.

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

    FIELD-SYMBOLS: <to_insert> TYPE ANY TABLE,
                   <to_update> TYPE ANY TABLE,
                   <to_delete> TYPE ANY TABLE.

    CALL FUNCTION 'CRM_ORDERADM_I_READ_OB'
      EXPORTING
        iv_header         = iv_header_guid
      IMPORTING
        et_orderadm_i_wrk = lt_orderadm_i_wrk
      EXCEPTIONS
        OTHERS            = 0.

    fetch_item_supported_comp( lt_orderadm_i_wrk ).
    fetch_item_conv_class( ).

    LOOP AT lt_orderadm_i_wrk ASSIGNING FIELD-SYMBOL(<orderadm_i_wrk>).

      DATA(lt_item_supported_comp) = get_item_supported_comp( <orderadm_i_wrk>-object_type ).
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

      LOOP AT lt_unsorted ASSIGNING FIELD-SYMBOL(<comp>).
        DATA(lv_conv_class) = get_conv_cls_name_by_component( <comp> ).
        CHECK lv_conv_class IS NOT INITIAL.
        DATA(lo_conv_class) = get_convertor_instance( lv_conv_class ).
        CALL METHOD lo_conv_class->convert_1o_to_s4
          EXPORTING
            iv_ref_guid  = <orderadm_i_wrk>-guid
            iv_ref_kind  = 'B'
          CHANGING
            ct_to_insert = <to_insert>
            ct_to_update = <to_update>
            ct_to_delete = <to_delete>.
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
    ASSIGN COMPONENT lv_insert_field OF STRUCTURE <update_data> TO <tab_for_insert>.
    ASSIGN COMPONENT lv_insert_field OF STRUCTURE <update_data> TO <tab_for_insert>.

    IF <to_insert> IS NOT INITIAL.
       INSERT LINES OF <to_insert> INTO TABLE <tab_for_insert>.
    ENDIF.

    IF <to_update> IS NOT INITIAL.
       INSERT LINES OF <to_update> INTO TABLE <tab_for_update>.
    ENDIF.

    IF <to_delete> IS NOT INITIAL.
       INSERT LINES OF <to_delete> INTO TABLE <tab_for_delete>.
    ENDIF.
* Jerry 2017-05-03 15:37PM - loop is end, ready to fill update records now
    ENDLOOP.


    CALL FUNCTION 'CRM_BTX_I_UPDATE_DU' IN UPDATE TASK
      EXPORTING
        is_update_record = ls_item_update.
  ENDMETHOD.
ENDCLASS.