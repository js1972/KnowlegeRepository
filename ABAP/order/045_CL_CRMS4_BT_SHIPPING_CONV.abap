class CL_CRMS4_BT_SHIPPING_CONV definition
  public
  final
  create public .

public section.

  interfaces IF_CRMS4_BTX_DATA_MODEL_CONV .
protected section.
private section.
ENDCLASS.



CLASS CL_CRMS4_BT_SHIPPING_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_SHIPPING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND
* | [--->] IV_CURRENT_GUID                TYPE        CRMT_OBJECT_GUID
* | [<-->] CT_TO_INSERT                   TYPE        ANY TABLE
* | [<-->] CT_TO_UPDATE                   TYPE        ANY TABLE
* | [<-->] CT_TO_DELETE                   TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_SHIPPING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY(optional)
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_S4_TO_1O.
    MOVE-CORRESPONDING IS_WORKAREA TO ES_WORKAREA.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_SHIPPING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_CRMS4_BTX_DATA_MODEL_CONV~GET_WRK_STRUCTURE_NAME.
    rv_wrk_structure_name = 'CRMT_SHIPPING_WRK'.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRMS4_BT_SHIPPING_CONV->IF_CRMS4_BTX_DATA_MODEL_CONV~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* | [--->] IV_REF_GUID                    TYPE        CRMT_OBJECT_GUID(optional)
* | [--->] IV_REF_KIND                    TYPE        CRMT_OBJECT_KIND(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_crms4_btx_data_model_conv~put_to_db_buffer.
    DATA: lt_db       TYPE crmt_shipping_du_tab,
          ls_db       LIKE LINE OF lt_db,
          lt_link_com TYPE crmt_link_comt,
          lv_hi_name  TYPE crmt_object_name,
          ls_link_com LIKE LINE OF lt_link_com.

    MOVE-CORRESPONDING is_wrk_structure TO ls_db.
    APPEND ls_db TO lt_db.
    CALL FUNCTION 'CRM_SHIPPING_PUT_DB'
      EXPORTING
        it_shipping_db = lt_db.

    CLEAR ls_link_com.
    CLEAR lt_link_com.
    ls_link_com-guid_hi     = ls_db-guid.
    ls_link_com-guid_set    = ls_db-guid.
    ls_link_com-objname_set = 'SHIPPING'.
    ls_link_com-objtype_set = '12'.
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