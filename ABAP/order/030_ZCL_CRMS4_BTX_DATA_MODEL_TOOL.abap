class ZCL_CRMS4_BTX_DATA_MODEL_TOOL definition
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
      value(RO_INSTANCE) type ref to ZCL_CRMS4_BTX_DATA_MODEL_TOOL .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_convertor,
        cls_name  TYPE crmt_object_name,
        convertor TYPE REF TO zif_crms4_btx_data_model,
      END OF ty_convertor .
  types:
    tt_convertor TYPE TABLE OF ty_convertor WITH KEY cls_name .
  types:
    BEGIN OF ty_header_object_type,
                       guid TYPE crmt_object_guid,
                       object_type TYPE CRMT_SUBOBJECT_CATEGORY_DB,
         end of ty_header_object_type .
  types:
    tt_header_object_type TYPE TABLE OF ty_header_object_type with key guid .
  types:
    BEGIN OF ty_object_supported_component,
             object_type TYPE CRMT_SUBOBJECT_CATEGORY_DB,
             supported_comps TYPE CRMT_OBJECT_NAME_TAB,
         END OF ty_object_supported_component .
  types:
    tt_object_supported_component TYPE TABLE OF ty_object_supported_component
    WITH KEY object_type .

  data MT_CONVERTOR type TT_CONVERTOR .
  class-data SO_INSTANCE type ref to ZCL_CRMS4_BTX_DATA_MODEL_TOOL .
  data MT_HEADER_OBJECT_TYPE_BUF type TT_HEADER_OBJECT_TYPE .
  data MT_HEADER_SUPPORTED_COMPS type TT_OBJECT_SUPPORTED_COMPONENT .

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
  methods GET_CONVERTOR
    importing
      !IV_CLS_NAME type CRMT_OBJECT_NAME
    returning
      value(RO_CONVERTOR) type ref to ZIF_CRMS4_BTX_DATA_MODEL .
  methods FETCH_HEADER_SUPPORTED_COMP .
ENDCLASS.



CLASS ZCL_CRMS4_BTX_DATA_MODEL_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_constructor.
    so_instance = NEW #( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL->CONV_S4_2_1ORDER_AND_FILL_BUFF
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OBJECTS                     TYPE        CRMT_OBJECT_NAME_TAB
* | [<-->] CS_ITEM                        TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD CONV_S4_2_1ORDER_AND_FILL_BUFF.
    DATA: lv_wrk_structure_name TYPE string,
          lr_wrk_structure      TYPE REF TO data,
          lt_convert_class      TYPE TABLE OF zcrmc_objects,
          lo_convertor          TYPE REF TO zif_crms4_btx_data_model.

    FIELD-SYMBOLS: <ls_wrk_structure> TYPE any.

    SELECT name conv_class INTO CORRESPONDING FIELDS OF TABLE lt_convert_class FROM zcrmc_objects
       FOR ALL ENTRIES IN it_objects WHERE name = it_objects-table_line.

    LOOP AT it_objects ASSIGNING FIELD-SYMBOL(<lv_object>).

      READ TABLE lt_convert_class ASSIGNING FIELD-SYMBOL(<cls_name>) WITH KEY
          name = <lv_object>.
      lo_convertor = get_convertor( iv_cls_name = <cls_name>-conv_class ).

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
* | Instance Private Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL->FETCH_HEADER_OBJECT_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method FETCH_HEADER_OBJECT_TYPE.
    DATA: lt_header_buffer_miss TYPE CRMT_OBJECT_GUID_TAB,
          lt_header_shadow TYPE TABLE OF zcrms4d_btx.
    LOOP AT it_header_guid ASSIGNING FIELD-SYMBOL(<guid>).
       READ TABLE MT_HEADER_OBJECT_TYPE_BUF WITH KEY guid = <guid> TRANSPORTING NO FIELDS.
       IF sy-subrc <> 0.
          APPEND <guid> TO lt_header_buffer_miss.
       ENDIF.
    ENDLOOP.

    CHECK lt_header_buffer_miss IS NOT INITIAL.

    SELECT * INTO TABLE lt_header_shadow FROM zcrms4d_btx FOR ALL ENTRIES IN lt_header_buffer_miss
        WHERE order_guid = lt_header_buffer_miss-table_line.

    LOOP AT lt_header_shadow ASSIGNING FIELD-SYMBOL(<header_shadow>).
       APPEND INITIAL LINE TO MT_HEADER_OBJECT_TYPE_BUF ASSIGNING FIELD-SYMBOL(<new_buffer>).
       <new_buffer> = value #( guid = <header_shadow>-order_guid
                                object_type = <header_shadow>-object_type ).
    ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL->FETCH_HEADER_SUPPORTED_COMP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method FETCH_HEADER_SUPPORTED_COMP.
    DATA: lt_missed_header_object TYPE TABLE OF CRMT_SUBOBJECT_CATEGORY_DB,
          lt_ZCRMC_OBJECT_ASS TYPE TABLE OF ZCRMC_OBJECT_ASS.

    LOOP AT MT_HEADER_OBJECT_TYPE_BUF ASSIGNING FIELD-SYMBOL(<header_buf>).
        READ TABLE mt_header_supported_comps WITH KEY object_type = <header_buf>-object_type
          TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          APPEND <header_buf>-object_type TO lt_missed_header_object.
        ENDIF.
    ENDLOOP.

    CHECK lt_missed_header_object IS NOT INITIAL.
    SORT lt_missed_header_object.
    DELETE ADJACENT DUPLICATES FROM lt_missed_header_object.

    SELECT * INTO TABLE lt_ZCRMC_OBJECT_ASS FROM ZCRMC_OBJECT_ASS FOR ALL ENTRIES IN
         lt_missed_header_object WHERE SUBOBJ_CATEGORY = lt_missed_header_object-table_line.
    check sy-subrc = 0.

  LOOP AT lt_missed_header_object ASSIGNING FIELD-SYMBOL(<missing>).
     APPEND INITIAL LINE TO mt_header_supported_comps ASSIGNING FIELD-SYMBOL(<new_buffer>).
     <new_buffer>-object_type = <missing>.
     LOOP AT lt_ZCRMC_OBJECT_ASS ASSIGNING FIELD-SYMBOL(<header_supported>)
         WHERE SUBOBJ_CATEGORY = <missing>.
       APPEND <header_supported>-name TO <new_buffer>-supported_comps.
     ENDLOOP.
  ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL->GET_CONVERTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CLS_NAME                    TYPE        CRMT_OBJECT_NAME
* | [<-()] RO_CONVERTOR                   TYPE REF TO ZIF_CRMS4_BTX_DATA_MODEL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_convertor.
    READ TABLE mt_convertor ASSIGNING FIELD-SYMBOL(<convertor>) WITH KEY cls_name = iv_cls_name.
    IF sy-subrc = 0.
      ro_convertor = <convertor>-convertor.
      RETURN.
    ENDIF.

    CREATE OBJECT ro_convertor TYPE (iv_cls_name).
    APPEND INITIAL LINE TO mt_convertor ASSIGNING FIELD-SYMBOL(<new_convertor>).
    <new_convertor> = VALUE ty_convertor( cls_name = iv_cls_name convertor = ro_convertor ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL->GET_HEADER_OBJECT_TYPE_BY_GUID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID
* | [<-()] RV_OBJECT_TYPE                 TYPE        CRMT_SUBOBJECT_CATEGORY_DB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_HEADER_OBJECT_TYPE_BY_GUID.
    read TABLE MT_HEADER_OBJECT_TYPE_BUF ASSIGNING FIELD-SYMBOL(<header_type>)
     with key guid = IV_HEADER_GUId.
    check sy-subrc = 0.

    RV_OBJECT_TYPE = <header_type>-object_type.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_CRMS4_BTX_DATA_MODEL_TOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_instance.
    ro_instance = so_instance.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL->GET_ITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ITEM_GUID                   TYPE        CRMT_OBJECT_GUID_TAB
* | [<---] ET_ORDERADM_I_DB               TYPE        CRMT_ORDERADM_I_DU_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_item.
    DATA: lt_btx_i   TYPE TABLE OF zcrms4d_btx_i,
          lt_acronym TYPE TABLE OF zcrmc_sub_cat_i,
          lr_dbtab   TYPE REF TO data,
          lt_objects TYPE crmt_object_name_tab.

    FIELD-SYMBOLS: <lt_dbtab>         TYPE ANY TABLE.

    CHECK it_item_guid IS NOT INITIAL.

    SELECT  * INTO TABLE lt_btx_i FROM zcrms4d_btx_i FOR ALL ENTRIES IN
       it_item_guid WHERE item_guid = it_item_guid-table_line.

    CHECK sy-subrc = 0.

    SELECT * FROM zcrmc_sub_cat_i INTO TABLE lt_acronym
       FOR ALL ENTRIES IN lt_btx_i
         WHERE subobj_category = lt_btx_i-object_type.

* Jerry 2017-04-21 14:21PM for POC, I assume all items belong to the same item table
* Jerry 2017-04-25 9:21AM - one order can have multiple item with different item object type!!!
* this scenario needs to be enhanced later!!
    ASSERT lines( lt_acronym ) = 1.
    READ TABLE lt_btx_i INTO DATA(ls_btx_i) INDEX 1.

    READ TABLE lt_acronym ASSIGNING FIELD-SYMBOL(<acronym>) INDEX 1.

    DATA(lv_dbtab_name) = 'ZCRMS4D_' && <acronym>-acronym && '_I'.

    CREATE DATA lr_dbtab TYPE TABLE OF (lv_dbtab_name).
    ASSIGN lr_dbtab->* TO <lt_dbtab>.

    SELECT  * FROM (lv_dbtab_name) INTO TABLE <lt_dbtab> FOR ALL ENTRIES IN
        it_item_guid WHERE guid = it_item_guid-table_line.

    CHECK sy-subrc = 0.

* Get all possible components for the given header object type
    SELECT name FROM zcrmc_obj_assi_i INTO TABLE lt_objects WHERE subobj_category = ls_btx_i-object_type.

    LOOP AT <lt_dbtab> ASSIGNING FIELD-SYMBOL(<ls_dbtab>).
      conv_s4_2_1order_and_fill_buff( EXPORTING it_objects = lt_objects
                           CHANGING cs_item = <ls_dbtab> ).
      APPEND <ls_dbtab> TO et_orderadm_i_db.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL->SAVE_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER_GUID                 TYPE        CRMT_OBJECT_GUID_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD save_header.
    fetch_header_object_type( it_header_guid ).

  ENDMETHOD.
ENDCLASS.