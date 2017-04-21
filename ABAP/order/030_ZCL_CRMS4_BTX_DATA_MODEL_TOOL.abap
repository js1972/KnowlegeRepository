class ZCL_CRMS4_BTX_DATA_MODEL_TOOL definition
  public
  final
  create public .

public section.

  methods GET_ITEM
    importing
      !IT_ITEM_GUID type CRMT_OBJECT_GUID_TAB
    exporting
      !ET_ORDERADM_I_DB type CRMT_ORDERADM_I_DU_TAB .
protected section.
private section.

  methods CONVERT_S4_2_1ORDER
    changing
      !CS_ITEM type ANY .
ENDCLASS.



CLASS ZCL_CRMS4_BTX_DATA_MODEL_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL->CONVERT_S4_2_1ORDER
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CS_ITEM                        TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CONVERT_S4_2_1ORDER.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_DATA_MODEL_TOOL->GET_ITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ITEM_GUID                   TYPE        CRMT_OBJECT_GUID_TAB
* | [<---] ET_ORDERADM_I_DB               TYPE        CRMT_ORDERADM_I_DU_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_item.
    DATA: lt_btx_i              TYPE TABLE OF zcrms4d_btx_i,
          lt_acronym            TYPE TABLE OF zcrmc_subob_cat,
          lr_dbtab              TYPE REF TO data,
          lt_objects            TYPE crmt_object_name_tab,
          lv_type               TYPE zcrmc_objects-type,
          lv_kind               TYPE zcrmc_objects-kind,
          lv_wrk_structure_name TYPE string,
          lr_wrk_structure      TYPE REF TO data,
          lo_convertor          TYPE REF TO zif_crms4_btx_data_model,
          lv_conv_class         TYPE seoclass-clsname.

    FIELD-SYMBOLS: <lt_dbtab>         TYPE ANY TABLE,
                   <ls_wrk_structure> TYPE any,
                   <lv_object>        TYPE crmc_object_assi-name.

    CHECK it_item_guid IS NOT INITIAL.

    SELECT  * INTO TABLE lt_btx_i FROM zcrms4d_btx_i FOR ALL ENTRIES IN
       it_item_guid WHERE item_guid = it_item_guid-table_line.

    CHECK sy-subrc = 0.

    SELECT * FROM zcrmc_subob_cat INTO TABLE lt_acronym
       FOR ALL ENTRIES IN lt_btx_i
         WHERE subobj_category = lt_btx_i-object_type.

* Jerry 2017-04-21 14:21PM for POC, I assume all items belong to the same item table
    ASSERT lines( lt_acronym ) = 1.
    READ TABLE lt_btx_i INTO DATA(ls_btx_i) INDEX 1.

    READ TABLE lt_acronym ASSIGNING FIELD-SYMBOL(<acronym>) INDEX 1.

    DATA(lv_dbtab_name) = 'ZCRMS4D_' && <acronym>-acronym && '_I'.

    CREATE DATA lr_dbtab TYPE (lv_dbtab_name).
    ASSIGN lr_dbtab->* TO <lt_dbtab>.

    SELECT  * FROM (lv_dbtab_name) INTO TABLE <lt_dbtab> FOR ALL ENTRIES IN
        it_item_guid WHERE guid = it_item_guid-table_line.

    CHECK sy-subrc = 0.

* Get all possible components for the given header object type
    SELECT name FROM zcrmc_obj_assi_i INTO TABLE lt_objects WHERE subobj_category = ls_btx_i-object_type.

    LOOP AT <lt_dbtab> ASSIGNING FIELD-SYMBOL(<ls_dbtab>).
      convert_s4_2_1order( CHANGING cs_item = <ls_dbtab> ).
      APPEND <ls_dbtab> TO et_orderadm_i_db.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.