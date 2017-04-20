class ZCL_CRMS4_BTX_ORDERADM_H_CONV definition
  public
  final
  create public .

public section.

  interfaces ZIF_CRMS4_BTX_DATA_MODEL .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CRMS4_BTX_ORDERADM_H_CONV IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_ORDERADM_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~CONVERT_S4_TO_1O
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WORKAREA                    TYPE        ANY(optional)
* | [<---] ES_WORKAREA                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRMS4_BTX_DATA_MODEL~CONVERT_S4_TO_1O.

* for ORDERADM_H move corresponding is enough
  MOVE-CORRESPONDING is_workarea TO es_workarea.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_ORDERADM_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~GET_WRK_STRUCTURE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_WRK_STRUCTURE_NAME          TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRMS4_BTX_DATA_MODEL~GET_WRK_STRUCTURE_NAME.
    rv_wrk_structure_name = 'CRMT_ORDERADM_H_WRK'.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRMS4_BTX_ORDERADM_H_CONV->ZIF_CRMS4_BTX_DATA_MODEL~PUT_TO_DB_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_WRK_STRUCTURE               TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_CRMS4_BTX_DATA_MODEL~PUT_TO_DB_BUFFER.
    CALL FUNCTION 'CRM_ORDERADM_H_PUT_OB'
      EXPORTING
         IS_ORDERADM_H_WRK = IS_WRK_STRUCTURE.
  endmethod.
ENDCLASS.