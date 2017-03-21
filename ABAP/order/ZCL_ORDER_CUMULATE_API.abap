class ZCL_ORDER_CUMULATE_API definition
  public
  final
  create public .

public section.

  methods GET_ORDER_HEADER_GROSS_WEIGHT
    importing
      !IV_GUID type CRMT_OBJECT_GUID
    returning
      value(RV_GROSS_WEIGHT) type CRMT_GROSS_WEIGHT_CUM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ORDER_CUMULATE_API IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ORDER_CUMULATE_API->GET_ORDER_HEADER_GROSS_WEIGHT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GUID                        TYPE        CRMT_OBJECT_GUID
* | [<-()] RV_GROSS_WEIGHT                TYPE        CRMT_GROSS_WEIGHT_CUM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_ORDER_HEADER_GROSS_WEIGHT.
  endmethod.
ENDCLASS.