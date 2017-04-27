class ZCL_INTEGER definition
  public
  final
  create private .

public section.

  class-methods VALUE_OF
    importing
      !IV_VALUE type INT4
    returning
      value(RO_INSTANCE) type ref to ZCL_INTEGER .
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
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_INTEGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method VALUE_OF.
     READ TABLE MT_CACHE ASSIGNING FIELD-SYMBOL(<cache>) WITH KEY int_value = IV_VALUE.
     IF sy-subrc = 0.
        ro_instance = <cache>-instance.
        RETURN.
     ENDIF.

     APPEND INITIAL LINE TO MT_CACHE ASSIGNING FIELD-SYMBOL(<new_cache>).
     <new_cache>-int_value = IV_VALUE.
     CREATE OBJECT <new_cache>-instance
       EXPORTING
         IV_VALUE = IV_VALUE.
  endmethod.
ENDCLASS.