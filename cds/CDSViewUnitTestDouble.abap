*"* use this source file for your ABAP unit test classes
CLASS lcl_test_productshorttex
DEFINITION FINAL FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS .
  PRIVATE SECTION.
    CLASS-DATA:
      environment TYPE REF TO if_cds_test_environment.
    CLASS-METHODS:
      class_setup
        RAISING
          cx_static_check,
      class_teardown.
    DATA:
      test_data   TYPE REF TO if_cds_test_data,
      act_results TYPE STANDARD TABLE OF p_crms4_productshorttext  WITH EMPTY KEY,
      makt_data   TYPE STANDARD TABLE OF makt  WITH EMPTY KEY,
      mara_data   TYPE STANDARD TABLE OF mara  WITH EMPTY KEY.

    METHODS:
      setup RAISING cx_static_check,

      insert_test_data IMPORTING
                         it_data     TYPE ANY TABLE
                         iv_viewname TYPE string,
      test_single_record      FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_test_productshorttex  IMPLEMENTATION.
  METHOD class_setup.
    environment = cl_cds_test_environment=>create(   i_for_entity ='PRODUCTSHORTTEXT'  ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.

  METHOD insert_test_data.
    CLEAR test_data.
    test_data = cl_cds_test_data=>create( i_data = it_data ).
    DATA(z_test_data_dbl) = environment->get_double( i_name = iv_viewname ).
    z_test_data_dbl->insert( test_data ).
  ENDMETHOD.

  METHOD test_single_record.
    DATA: ls_productshorttext TYPE productshorttext,
          lt_productshorttext TYPE TABLE OF productshorttext.

    makt_data = VALUE #(  (
           mandt =  sy-mandt
           matnr =  'JA-1010-NOT_EXIST'
           spras =  'E'
           maktx =  'JDK Version 1.6'
           maktg =  'JDK VERSION 1.6'  )   ).
    insert_test_data( it_data = makt_data iv_viewname = 'MAKT' ).

    mara_data = VALUE #(  (
                    mandt = sy-mandt
                    matnr = 'JA-1010-NOT_EXIST'
                    scm_matid_guid16 =  '6C0B84B759DF1ED6B0D80E896AE01049'
                 ) ).
    insert_test_data( it_data = mara_data iv_viewname = 'MARA' ).

    lt_productshorttext = VALUE #(  (
                                      productguid = '6C0B84B759DF1ED6B0D80E896AE01049'
                                      language = 'E'
                                      productname = 'JDK Version 1.6'
                                      productnamelarge = 'JDK VERSION 1.6'
                                   )  ).

    SELECT * FROM productshorttext INTO TABLE @DATA(act_results).

    cl_abap_unit_assert=>assert_equals( act = lines( act_results )
                                         exp = 1 ).

    READ TABLE act_results INDEX 1 INTO ls_productshorttext.
    cl_abap_unit_assert=>assert_table_contains( line = ls_productshorttext
                                        table =  lt_productshorttext ).
  ENDMETHOD.

ENDCLASS.