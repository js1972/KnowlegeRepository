* This is exactly what I want!!
REPORT demo_corresponding_vs_for.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      main,
      class_constructor.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF struct,
        carrier     TYPE spfli-carrid,
        connection  TYPE spfli-connid,
        departure   TYPE spfli-cityfrom,
        destination TYPE spfli-cityto,
      END OF struct.
    CLASS-DATA:
      itab    TYPE HASHED TABLE OF spfli
              WITH UNIQUE KEY carrid connid,
      result1 TYPE HASHED TABLE OF struct
              WITH UNIQUE KEY carrier connection,
      result2 TYPE HASHED TABLE OF struct
              WITH UNIQUE KEY carrier connection,
      result3 TYPE HASHED TABLE OF struct
              WITH UNIQUE KEY carrier connection,
      in      TYPE REF TO if_demo_input,
      out     TYPE REF TO if_demo_output.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA(iterations) = 10.
    in->request( CHANGING field = iterations ).

    DO iterations TIMES.

      DATA t1 TYPE i.
      GET RUN TIME FIELD DATA(t11).
      result1 = CORRESPONDING #(
                 itab MAPPING carrier     = carrid
                              connection  = connid
                              departure   = cityfrom
                              destination = cityto ).
      GET RUN TIME FIELD DATA(t12).
      t1 = t1 + t12 - t11.

      DATA t2 TYPE i.
      GET RUN TIME FIELD DATA(t21).
      result2 = VALUE #( FOR wa IN itab ( carrier     = wa-carrid
                                          connection  = wa-connid
                                          departure   = wa-cityfrom
                                          destination = wa-cityto ) ).
      GET RUN TIME FIELD DATA(t22).
      t2 = t2 + t22 - t21.

      DATA t3 TYPE i.
      GET RUN TIME FIELD DATA(t31).
      result3 = VALUE #( FOR wa IN itab (
                           CORRESPONDING #(
                             wa MAPPING carrier     = carrid
                                        connection  = connid
                                        departure   = cityfrom
                                        destination = cityto ) ) ).
      GET RUN TIME FIELD DATA(t32).
      t3 = t3 + t32 - t31.

    ENDDO.

    IF result1 = result2 AND result1 = result3.
      out->write(
       |CORRESPONDING:     {
         CONV decfloat16( t1 / iterations )
              WIDTH = 10 ALIGN = RIGHT } Microseconds\n| &&
       |FOR:               {
         CONV decfloat16( t2 / iterations )
              WIDTH = 10 ALIGN = RIGHT } Microseconds\n| &&
       |FOR CORRESPONDING: {
         CONV decfloat16( t3 / iterations )
              WIDTH = 10 ALIGN = RIGHT } Microseconds\n|
      )->line(
      )->display( result1 ).
    ELSE.
      out->display( `What?` ).
    ENDIF.

  ENDMETHOD.
  METHOD class_constructor.
    in  = cl_demo_input=>new( ).
    out = cl_demo_output=>new( ).
    SELECT *
           FROM spfli
           INTO TABLE @itab.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).