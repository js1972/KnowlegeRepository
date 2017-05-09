class CL_CRMS4_BT_PRICING_CONV definition
  public
  final
  create public .

public section.

  interfaces IF_CRMS4_BTX_DATA_MODEL_CONV .
protected section.
private section.
ENDCLASS.



CLASS CL_CRMS4_BT_PRICING_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRICING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND
* | [--->] IV_CURRENT_GUID                TYPE        CRMT_OBJECT_GUID
* | [<-->] CT_TO_INSERT                   TYPE        ANY TABLE
* | [<-->] CT_TO_UPDATE                   TYPE        ANY TABLE
* | [<-->] CT_TO_DELETE                   TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4.
    DATA: lt_insert  TYPE crmt_pricing_du_tab,
          lt_update  TYPE crmt_pricing_du_tab,
          lt_delete  TYPE crmt_pricing_du_tab,
          lt_to_save TYPE crmt_object_guid_tab,
          lv_created_set_guid TYPE crmt_object_guid.

    DATA(lo_tool) = cl_crms4_bt_data_model_tool=>get_instance( ).
* Jerry 2017-05-08 7:07PM - always header guid passed into this method
    APPEND iv_current_guid TO lt_to_save.

    CALL FUNCTION 'CRM_ORDER_UPDATE_TABLES_DETERM'
      EXPORTING
        iv_object_name       = 'PRICING'
        iv_field_name_key    = 'GUID'
        it_guids_to_process  = lt_to_save
        iv_header_to_save    = iv_ref_guid
      IMPORTING
        et_records_to_insert = lt_insert
        et_records_to_update = lt_update
        et_records_to_delete = lt_delete.

* ct_* can have different table type like CRMS4D_SALE_I_T, CRMS4D_SVPR_I_T
* Jerry 2017-04-26 12:11PM only support update currently

    DATA(tool) = cl_crms4_bt_data_model_tool=>get_instance( ).

    CALL METHOD tool->merge_change_2_global_buffer
      EXPORTING
        it_current_insert = lt_insert
        it_current_update = lt_update
        it_current_delete = lt_delete
      CHANGING
        ct_global_insert  = ct_to_insert
        ct_global_update  = ct_to_update
        ct_global_delete  = ct_to_delete.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRICING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY(optional)
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O.
    MOVE-CORRESPONDING IS_WORKAREA TO ES_WORKAREA.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRICING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_OB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GUID                        TYPE        CRMT_OBJECT_GUID
* | [<---] ES_DATA                        TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD IF_CRMS4_BTX_DATA_MODEL_CONV~GET_OB.
    DATA: lt_guid   TYPE crmt_object_guid_tab,
          lt_buffer TYPE crmt_pricing_wrkt.

    APPEND iv_guid TO lt_guid.

    CALL FUNCTION 'CRM_PRICING_GET_MULTI_OB'
      EXPORTING
        it_guids_to_get  = lt_guid
      IMPORTING
        et_object_buffer = lt_buffer.

    READ TABLE lt_buffer ASSIGNING FIELD-SYMBOL(<buffer>) INDEX 1.
    CHECK sy-subrc = 0.

    MOVE-CORRESPONDING <buffer> TO es_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRICING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME.
    rv_wrk_structure_name = 'CRMT_PRICING_WRK'.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_PRICING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID(optional)
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~put_to_db_buffer.
    DATA: lt_db       TYPE crmt_pricing_du_tab,
          ls_db       LIKE LINE OF lt_db,
          lt_link_com TYPE crmt_link_comt,
          lv_hi_name  TYPE crmt_object_name,
          lt_dummy    TYPE  crmt_pricing_revs_wrkt,
          ls_link_com LIKE LINE OF lt_link_com.

    MOVE-CORRESPONDING is_wrk_structure TO ls_db.
    APPEND ls_db TO lt_db.
    CALL FUNCTION 'CRM_PRICING_PUT_DB'
      EXPORTING
        it_pricing_db     = lt_db
        it_pricing_rev_db = lt_dummy.

    CLEAR ls_link_com.
    CLEAR lt_link_com.
    ls_link_com-guid_hi     = ls_db-guid.
    ls_link_com-guid_set    = ls_db-guid.
    ls_link_com-objname_set = 'PRICING'.
    ls_link_com-objtype_set = '09'.
    IF iv_ref_kind = 'A'.
      ls_link_com-objname_hi  = lv_hi_name = 'ORDERADM_H'.
      ls_link_com-objtype_hi  = '05'.
    ELSE.
      ls_link_com-objname_hi  = lv_hi_name = 'ORDERADM_I'.
      ls_link_com-objtype_hi  = '06'.
    ENDIF.
    INSERT ls_link_com INTO TABLE lt_link_com.
    CALL FUNCTION 'CRM_LINK_CREATE_OW'
      EXPORTING
        iv_guid_hi    = ls_db-guid
        iv_objname_hi = lv_hi_name
        it_link       = lt_link_com
      EXCEPTIONS
        OTHERS        = 0.

  ENDMETHOD.
ENDCLASS.