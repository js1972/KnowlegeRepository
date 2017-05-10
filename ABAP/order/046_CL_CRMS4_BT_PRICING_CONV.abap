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
  METHOD if_crms4_btx_data_model_conv~convert_1o_to_s4.
    DATA: lt_insert   TYPE crmt_pricing_du_tab,
          lt_update   TYPE crmt_pricing_du_tab,
          ls_du       TYPE crmd_pricing,
          ls_pricing TYPE crmt_pricing_wrk.

    DATA(lo_tool) = cl_crms4_bt_data_model_tool=>get_instance( ).
* Jerry 2017-05-08 7:07PM - always header guid passed into this method
    DATA(lv_ref_kind) = COND crmt_object_kind( WHEN iv_current_guid = iv_ref_guid THEN 'A'
          ELSE 'B' ).

    IF lv_ref_kind = 'B' and lo_tool->mv_current_item_mode = 'D'.
       RETURN.
    ENDIF.

    CALL FUNCTION 'CRM_PRICING_READ_OW'
      EXPORTING
        iv_ref_guid    = iv_current_guid
        iv_ref_kind    = lv_ref_kind
      IMPORTING
        es_pricing_wrk = ls_pricing.

* Jerry 2017-05-10 5:49PM if ls_shipping is completely initial, it means this data has never
* been maintained yet. Please differentiate with another scenario: all fields in ls_pricing
* are initial except guid - which means the pricing has once been maintained, but
* cleared by end user in current transaction manually
* see: https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/55
    IF ls_pricing IS INITIAL.
       RETURN.
    ENDIF.
    ls_du = CORRESPONDING #( ls_pricing ).
    ls_du-guid = iv_current_guid.
* Jerry 2017-05-10 8:51PM !!! set update record should consider current set context!
* this code is ugly!!!
    CASE lv_ref_kind.
      WHEN 'A'.
        CASE lo_tool->mv_current_head_mode.
          WHEN 'A'.
             INSERT ls_du INTO TABLE lt_insert.
          WHEN 'B'.
             INSERT ls_du INTO TABLE lt_update.
        ENDCASE.
      WHEN 'B'.
         CASE lo_tool->mv_current_item_mode.
          WHEN 'A'.
             INSERT ls_du INTO TABLE lt_insert.
          WHEN 'B'.
             INSERT ls_du INTO TABLE lt_update.
         ENDCASE.
    ENDCASE.

    CALL METHOD lo_tool->merge_change_2_global_buffer
      EXPORTING
        it_current_insert = lt_insert
        it_current_update = lt_update
      CHANGING
        ct_global_insert  = ct_to_insert
        ct_global_update  = ct_to_update.
  ENDMETHOD.


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
* | Instance Private Method CL_CRMS4_BT_PRICING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_OB
* +-------------------------------------------------------------------------------------------------+
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