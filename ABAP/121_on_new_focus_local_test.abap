CLASS zlcl_txt_test DEFINITION DEFERRED.
CLASS zcl_prdtxt_textcuco_cn02 DEFINITION
    LOCAL FRIENDS zlcl_txt_test.

CLASS zlcl_txt_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.


  PRIVATE SECTION.
    DATA:
      f_cut   TYPE REF TO zcl_prdtxt_textcuco_cn02.  "class under test
    CLASS-DATA: lo_prod TYPE REF TO cl_crm_bol_entity.

    CLASS-METHODS: class_setup.
    CLASS-METHODS: get_sample_data RETURNING VALUE(rs_data) TYPE comt_product_ui.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: create_wrapper.
    METHODS: teardown.
    METHODS: on_new_focus FOR TESTING.
ENDCLASS.       "zlcl_Txt_Test


CLASS zlcl_txt_test IMPLEMENTATION.

  METHOD get_sample_data.
    DATA:ls_prod TYPE comm_product.
    SELECT SINGLE * INTO ls_prod FROM comm_product WHERE product_type = '01'.
    rs_data = VALUE #( product_guid = ls_prod-product_guid product_id = ls_prod-product_id product_type = '01' ).
  ENDMETHOD.

  METHOD class_setup.

    lo_prod = zcl_prod_unit_test_tool=>get_fake_bol_entity(
       iv_bol_name = 'Product'
       is_data = get_sample_data( )
       iv_key = get_sample_data( )-product_guid ).

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.


  METHOD setup.


    CREATE OBJECT f_cut.
    create_wrapper( ).
  ENDMETHOD.

  METHOD create_wrapper.
    DATA: lr_attr TYPE REF TO crmst_uiu_text_attr.

    CREATE DATA lr_attr.

    DATA(lr_value) = NEW cl_bsp_wd_value_node( lr_attr ).
    CREATE OBJECT f_cut->collection_wrapper.

    f_cut->collection_wrapper->add( lr_value ).
  ENDMETHOD.

  METHOD teardown.



  ENDMETHOD.


  METHOD on_new_focus.

    DATA focus_bo TYPE REF TO if_bol_bo_property_access.

    focus_bo ?= lo_prod.
    f_cut->on_new_focus( focus_bo ).

  ENDMETHOD.




ENDCLASS.