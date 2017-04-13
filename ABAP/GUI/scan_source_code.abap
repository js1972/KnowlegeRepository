*&---------------------------------------------------------------------*
*& Report ZSCAN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zscan.
DATA tok TYPE TABLE OF stokex.
DATA stm TYPE TABLE OF sstmnt.
DATA level TYPE TABLE OF slevel.
DATA: lt_source TYPE string_table.

APPEND 'data(lo_dog) = new zcl_dog( ).' TO lt_source.
APPEND 'data(lo_cat) = new zcl_cat( ).' TO lt_source.
APPEND 'data(lo) = new zcl_animal_container( ).' TO lt_source.
APPEND 'lo->add( lo_dog ).' TO lt_source.
APPEND 'lo->add( lo_cat ).' TO lt_source.

APPEND 'data(lv_total) = lo->size( ).' TO lt_source.
APPEND 'DO lv_total TIMES.' TO lt_source.
APPEND '   data(lo_animal) = lo->get( sy-index ).' TO lt_source.
APPEND '   lo_animal->shout( ).' TO lt_source.
APPEND 'ENDDO.' TO lt_source.
SCAN ABAP-SOURCE  lt_source STATEMENTS      INTO stm
   TOKENS          INTO tok
   LEVELS          INTO level WITH ANALYSIS.
BREAK-POINT.