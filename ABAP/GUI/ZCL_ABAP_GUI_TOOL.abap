class ZCL_ABAP_GUI_TOOL definition
  public
  final
  create public .

public section.

  methods USE_NEW_HANDLER .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAP_GUI_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABAP_GUI_TOOL->USE_NEW_HANDLER
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD use_new_handler.
    DATA: lt_new TYPE TABLE OF wbregistry.

    SELECT * INTO TABLE lt_new FROM wbregistry WHERE tool = 'CL_WB_CLEDITOR'.

    CHECK sy-subrc = 0.

    LOOP AT lt_new ASSIGNING FIELD-SYMBOL(<new>).
      <new>-tool = 'ZCL_WB_CLEDITOR'.
    ENDLOOP.

    UPDATE wbregistry FROM TABLE lt_new.
  ENDMETHOD.
ENDCLASS.