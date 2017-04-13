class ZCL_ABAP_COVARIANCE_TOOL definition
  public
  final
  create public .

public section.

  methods GET_METHODS_INCLUDE
    importing
      !IS_METHOD_DEF type SEOCPDKEY
    exporting
      !EV_PROGRAM type PROGNAME
      !EV_INCLUDE type PROGRAM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAP_COVARIANCE_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABAP_COVARIANCE_TOOL->GET_METHODS_INCLUDE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_METHOD_DEF                  TYPE        SEOCPDKEY
* | [<---] EV_PROGRAM                     TYPE        PROGNAME
* | [<---] EV_INCLUDE                     TYPE        PROGRAM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_METHODS_INCLUDE.
  endmethod.
ENDCLASS.