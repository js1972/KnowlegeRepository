REPORT demo_describe_distance.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA: BEGIN OF struc,
            comp1 TYPE i,
            comp2 TYPE x LENGTH 1,
            comp3 TYPE c LENGTH 4 VALUE 'Hey',
            comp4 TYPE c LENGTH 4 VALUE 'you!',
            comp5 TYPE x,
          END OF struc.

    FIELD-SYMBOLS: <hex>    TYPE x,
                   <result> TYPE c.

    DESCRIBE DISTANCE BETWEEN:
             struc       AND struc-comp3 INTO DATA(off) IN BYTE MODE,
             struc-comp3 AND struc-comp5 INTO DATA(len) IN BYTE MODE.

    ASSIGN: struc TO <hex> CASTING,
            <hex>+off(len) TO <result> CASTING.

    cl_demo_output=>display(
      |Offset off is { off }.\n| &&
      |Length len is { len }.\n| &&
      |<result> points to "{ <result> }".| ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).