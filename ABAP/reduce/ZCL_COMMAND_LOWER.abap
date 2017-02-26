class ZCL_COMMAND_LOWER definition
  public
  final
  create public .

public section.

  interfaces ZIF_COMMAND .
protected section.
private section.

  data MT_STRING type STRING_TABLE .
ENDCLASS.



CLASS ZCL_COMMAND_LOWER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_LOWER->ZIF_COMMAND~DO
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_COMMAND~DO.
         LOOP AT mt_string ASSIGNING FIELD-SYMBOL(<line>).
        TRANSLATE <line> TO LOWER CASE.
     ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_LOWER->ZIF_COMMAND~GET_NEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_NEXT                        TYPE REF TO ZIF_COMMAND
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_COMMAND~GET_NEXT.
    ZIF_COMMAND~do( ).
    ZIF_COMMAND~next->set_task( mt_string ).

    ro_next = ZIF_COMMAND~next.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_LOWER->ZIF_COMMAND~GET_RESULT
* +-------------------------------------------------------------------------------------------------+
* | [<---] RV_RESULT                      TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_COMMAND~GET_RESULT.
     rv_result = mt_string.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_LOWER->ZIF_COMMAND~SET_NEXT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_NEXT                        TYPE REF TO ZIF_COMMAND
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_COMMAND~SET_NEXT.
     ZIF_COMMAND~next = io_next.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_LOWER->ZIF_COMMAND~SET_TASK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TASK                        TYPE        ANY
* | [<-()] RO_CMD                         TYPE REF TO ZIF_COMMAND
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_COMMAND~SET_TASK.
     mt_string = iv_task.
     ro_cmd = me.

  endmethod.
ENDCLASS.