class ZCL_COMMAND_QUEUE definition
  public
  final
  create private .

public section.

  types:
    begin of ty_cmd_queue,
             cmd TYPE REF TO ZIF_COMMAND,
        end of tY_cmd_queue .
  types:
    tt_cmd_queue TYPE TABLE OF ty_cmd_queue WITH KEY cmd .

  data MT_QUEUE type TT_CMD_QUEUE read-only .

  methods POP
    returning
      value(RO_CMD) type ref to ZIF_COMMAND .
  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCL_COMMAND_QUEUE .
  methods INSERT
    importing
      !IO_COMMAND type ref to ZIF_COMMAND
    returning
      value(RO_THIS) type ref to ZCL_COMMAND_QUEUE .
protected section.
private section.

  class-data SO_INSTANCE type ref to ZCL_COMMAND_QUEUE .
  data MO_PREVIOUS_CMD type ref to ZIF_COMMAND .
ENDCLASS.



CLASS ZCL_COMMAND_QUEUE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_COMMAND_QUEUE=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CLASS_CONSTRUCTOR.
    CREATE OBJECT so_instance.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_COMMAND_QUEUE=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_COMMAND_QUEUE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_INSTANCE.
    ro_instance = so_instance.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_QUEUE->INSERT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_COMMAND                     TYPE REF TO ZIF_COMMAND
* | [<-()] RO_THIS                        TYPE REF TO ZCL_COMMAND_QUEUE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method INSERT.
     IF MO_PREVIOUS_CMD IS NOT INITIAL.
        MO_PREVIOUS_CMD->set_next( IO_COMMAND ).
     ELSE.
        MO_PREVIOUS_CMD = IO_COMMAND.
     ENDIF.

     data(ls_queue) = value ty_cmd_queue( cmd = IO_COMMAND ).
     APPEND ls_queue TO mt_queue.

     ro_this = me.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_COMMAND_QUEUE->POP
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_CMD                         TYPE REF TO ZIF_COMMAND
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method POP.
     READ TABLE mt_queue ASSIGNING FIELD-SYMBOL(<head>) INDEX 1.
     CHECK sy-subrc = 0.
     ro_cmd = <head>-cmd.
     DELETE mt_queue INDEX 1.
  endmethod.
ENDCLASS.