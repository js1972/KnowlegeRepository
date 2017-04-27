class ZCL_INTEGER definition
  public
  final
  create private .

public section.

  class-methods VALUE_OF
    importing
      !IV_VALUE type INT4 .
protected section.
private section.

  types:
    BEGIN OF ty_cache,
             int_value TYPE int4,
             instance TYPE REF TO ZCL_INTEGER,
         end of ty_cache .
  types:
    tt_cache TYPE TABLE OF ty_cache WITH KEY int_value .

  class-data MT_CACHE type TT_CACHE .

  methods CONSTRUCTOR
    importing
      !IV_VALUE type INT4 .
ENDCLASS.



CLASS ZCL_INTEGER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_INTEGER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VALUE                       TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CONSTRUCTOR.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_INTEGER=>VALUE_OF
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VALUE                       TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method VALUE_OF.
  endmethod.
ENDCLASS.