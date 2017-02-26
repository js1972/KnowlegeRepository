class ZCL_COMMAND_SPLIT definition
  public
  final
  create public .

public section.

  interfaces ZIF_COMMAND .
protected section.
private section.

  data MV_STRING_TO_SPLIT type STRING .
  data MT_SPLITED type STRING_TABLE .
ENDCLASS.



CLASS ZCL_COMMAND_SPLIT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_SPLIT->ZIF_COMMAND~DO
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_COMMAND~DO.
    SPLIT mv_string_to_split AT SPACE INTO TABLE mt_splited.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_SPLIT->ZIF_COMMAND~GET_NEXT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_NEXT                        TYPE REF TO ZIF_COMMAND
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_COMMAND~GET_NEXT.

    ZIF_COMMAND~do( ).
    ZIF_COMMAND~next->set_task( mt_splited ).

    ro_next = ZIF_COMMAND~next.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_SPLIT->ZIF_COMMAND~SET_TASK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TASK                        TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ZIF_COMMAND~SET_TASK.
    mv_string_to_split = iv_task.
  endmethod.
ENDCLASS.