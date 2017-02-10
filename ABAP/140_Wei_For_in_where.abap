*&---------------------------------------------------------------------*
*& Report ZTEST_WEI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_wei.


CLASS lcl_test DEFINITION.
  PUBLIC SECTION.
    METHODS: create_data IMPORTING iv_name TYPE string RETURNING VALUE(rv) TYPE crmt_java.
ENDCLASS.

CLASS lcl_test IMPLEMENTATION.
  METHOD: create_data.
    rv = VALUE #( name = iv_name age = 1 ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lt_child TYPE crmt_java_t,
        node_tab TYPE crmt_bsp_treetable_node_tab,
        lo_test  TYPE REF TO lcl_test.

  node_tab = value #( ( node_key = '1' parent_key = '0' )
                      ( node_key = '2' )
                      ( node_key = '3' parent_key = '0' )
   ).
  lo_test = NEW #( ).

  lt_child = VALUE #( FOR <node> IN node_tab
                      WHERE ( parent_key IS INITIAL )
                      ( lo_test->create_data( <node>-node_key ) )
                    ).

  BREAK-POINT.