*&---------------------------------------------------------------------*
*& Report ZFILTER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFILTER.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA carrid TYPE spfli-carrid VALUE 'LH'.
    cl_demo_input=>add_field( CHANGING field = carrid ).
    DATA cityfrom TYPE spfli-cityfrom VALUE 'Frankfurt'.
    cl_demo_input=>request( CHANGING field = cityfrom ).

    DATA spfli_tab TYPE STANDARD TABLE OF spfli
                   WITH EMPTY KEY
                   WITH NON-UNIQUE SORTED KEY carr_city
                        COMPONENTS carrid cityfrom.

    SELECT *
           FROM spfli
           INTO TABLE @spfli_tab.

    DATA(extract) =
      FILTER #( spfli_tab USING KEY carr_city
                  WHERE carrid   = CONV #( to_upper( carrid ) ) AND
                        cityfrom = CONV #( to_upper( cityfrom ) ) ).

    cl_demo_output=>display( extract ).

    DATA(rest) =
      FILTER #( spfli_tab EXCEPT USING KEY carr_city
                  WHERE carrid   = CONV #( to_upper( carrid ) ) AND
                        cityfrom = CONV #( to_upper( cityfrom ) ) ).

    ASSERT lines( extract ) + lines( rest ) = lines( spfli_tab ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).