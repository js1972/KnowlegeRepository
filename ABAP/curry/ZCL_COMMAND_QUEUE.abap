class ZCL_COMMAND_QUEUE definition
  public
  final
  create private .

public section.

  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCL_COMMAND_QUEUE .
protected section.
private section.

  class-data SO_INSTANCE type ref to ZCL_COMMAND_QUEUE .
ENDCLASS.



CLASS ZCL_COMMAND_QUEUE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_COMMAND_QUEUE=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CLASS_CONSTRUCTOR.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_COMMAND_QUEUE=>GET_INSTANCE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_COMMAND_QUEUE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_INSTANCE.
    ro_instance = so_instance.
  endmethod.
ENDCLASS.