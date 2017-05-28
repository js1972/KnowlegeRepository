REPORT.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: class_constructor,
                   main.
  PRIVATE SECTION.
    CLASS-DATA
      flight_tab
        TYPE STANDARD TABLE OF spfli
        WITH EMPTY KEY
        WITH UNIQUE HASHED KEY id COMPONENTS carrid connid
        WITH NON-UNIQUE SORTED KEY cities COMPONENTS cityfrom cityto.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA idx TYPE TABLE OF i.

    idx = VALUE #(
          ( line_index( flight_tab[ carrid = 'UA'
                                    connid = '0941'
                                    ##primkey[id] ] ) )
          ( line_index( flight_tab[ KEY id
                                    carrid = 'UA'
                                    connid = '0941' ] ) )
          ( line_index( flight_tab[ KEY id
                                    carrid = 'xx'
                                    connid = 'yyyy' ] ) )
          ( line_index( flight_tab[ cityfrom = 'FRANKFURT'
                                    cityto   = 'NEW YORK'
                                    ##primkey[cities] ] ) )
          ( line_index( flight_tab[ KEY cities
                                    cityfrom = 'FRANKFURT'
                                    cityto   = 'NEW YORK'  ] ) )
          ( line_index( flight_tab[ KEY cities
                                    cityfrom = 'xxxxxxxx'
                                    cityto   = 'yyyyyyyy'  ] ) ) ).

    cl_demo_output=>display( idx ).
  ENDMETHOD.
  METHOD class_constructor.
    SELECT *
           FROM spfli
           ORDER BY carrid, connid
           INTO TABLE @flight_tab.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).