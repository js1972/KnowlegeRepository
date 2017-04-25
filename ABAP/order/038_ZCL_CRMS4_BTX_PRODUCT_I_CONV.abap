class ZCL_CRMS4_BTX_PRODUCT_I_CONV definition
  public
  final
  create public .

public section.

  interfaces ZIF_CRMS4_BTX_DATA_MODEL .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CRMS4_BTX_PRODUCT_I_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_PRODUCT_I_CONV->ZIF_CRMS4_BTX_DATA_MODEL~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY(optional)
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRMS4_BTX_DATA_MODEL~CONVERT_S4_TO_1O.
    MOVE-CORRESPONDING is_workarea to es_workarea.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_PRODUCT_I_CONV->ZIF_CRMS4_BTX_DATA_MODEL~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRMS4_BTX_DATA_MODEL~GET_WRK_STRUCTURE_NAME.
    rv_wrk_structure_name = 'CRMT_PRODUCT_I_WRK'.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_PRODUCT_I_CONV->ZIF_CRMS4_BTX_DATA_MODEL~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_crms4_btx_data_model~put_to_db_buffer.
    DATA: lt_product_i_db_buffer TYPE crmt_product_i_du_tab.

    APPEND is_wrk_structure TO lt_product_i_db_buffer.

    CALL FUNCTION 'ZCRM_PRODUCT_I_PUT_DB'
      EXPORTING
        it_product_i_db = lt_product_i_db_buffer.
  ENDMETHOD.
ENDCLASS.