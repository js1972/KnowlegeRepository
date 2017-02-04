
CLASS zlcl_determine_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>zlcl_Determine_Test
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>ZCL_CRM_PROD_DETERMINE_UNIT
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE>X
*?</GENERATE_CLASS_FIXTURE>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO zcl_crm_prod_determine_unit.  "class under test
    DATA mv_header TYPE crmt_object_guid.
    DATA: mv_fake_prod_guid TYPE comm_product-product_guid.

    CONSTANTS: gv_oppt_proc_type TYPE crmd_orderadm_h-process_type
     VALUE 'ZJER',
               gv_altid          TYPE isam_o_veh_ids-altvehno VALUE 'ABC',
               gv_prod_id        TYPE comm_product-product_id VALUE 'JERRY'.

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: determine_ok FOR TESTING.
    METHODS: determine_fail FOR TESTING.
ENDCLASS.       "zlcl_Determine_Test


CLASS zlcl_determine_test IMPLEMENTATION.

  METHOD class_setup.



  ENDMETHOD.


  METHOD class_teardown.



  ENDMETHOD.


  METHOD setup.

    DATA: ls_mock_header TYPE crmt_orderadm_h_wrk,
          ls_mock_alt_id TYPE isam_o_veh_ids,
          lt_link        TYPE crmt_link_comt,
          ls_link        LIKE LINE OF lt_link.
    CREATE OBJECT f_cut.

    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        ev_guid_16 = mv_header.

    ls_mock_header-guid = mv_header.
    ls_mock_header-process_type = gv_oppt_proc_type.

    CALL FUNCTION 'CRM_ORDERADM_H_PUT_OB'
      EXPORTING
        is_orderadm_h_wrk = ls_mock_header.

    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        ev_guid_16 = mv_fake_prod_guid.

    ls_mock_alt_id = VALUE #( product_guid = mv_fake_prod_guid
           upname = sy-uname
           altvehno = gv_altid ).

    INSERT isam_o_veh_ids FROM ls_mock_alt_id.
    DATA(prod) = VALUE comm_product( product_guid = mv_fake_prod_guid
         product_id = gv_prod_id
         product_type = '01' upname = sy-uname ).

    INSERT comm_product FROM prod.
    COMMIT WORK AND WAIT.

  ENDMETHOD.


  METHOD teardown.
    DELETE FROM isam_o_veh_ids WHERE product_guid = mv_fake_prod_guid.

    DELETE FROM comm_product WHERE product_guid = mv_fake_prod_guid.
    COMMIT WORK AND WAIT.

  ENDMETHOD.

  METHOD determine_fail.
    DATA lv_ordered_product TYPE crmt_ordered_prod.
    DATA cv_ordered_prod TYPE crmt_ordered_prod.
    DATA ls_product_detail TYPE crmt_product_detail.

    lv_ordered_product = 'NOT_EXIST_PROD_IN_SYSTEM'.

    f_cut->crm_orderadm_i_prod_determ_ow(
      EXPORTING
        iv_header = mv_header
        iv_ordered_product = lv_ordered_product
     IMPORTING
       es_product_detail = ls_product_detail
      CHANGING
        cv_ordered_prod = cv_ordered_prod ).

    cl_abap_unit_assert=>assert_initial( cv_ordered_prod ).
    cl_abap_unit_assert=>assert_initial( ls_product_detail ).
  ENDMETHOD.
  METHOD determine_ok.

    DATA lv_ordered_product TYPE crmt_ordered_prod.
    DATA iv_product TYPE crmt_object_guid.
    DATA iv_customervalid TYPE crmt_boolean.
    DATA et_product_detail TYPE crmt_product_detail_tab.
    DATA es_product_detail TYPE crmt_product_detail.
    DATA et_return TYPE comt_pcat_bapiret2_tab.
    DATA ev_product_search TYPE crmt_boolean.
    DATA cv_ordered_prod TYPE crmt_ordered_prod.

    lv_ordered_product = gv_altid.

    f_cut->crm_orderadm_i_prod_determ_ow(
      EXPORTING
        iv_header = mv_header
        iv_ordered_product = lv_ordered_product
      IMPORTING
        es_product_detail = es_product_detail
      CHANGING
        cv_ordered_prod = cv_ordered_prod ).

    cl_abap_unit_assert=>assert_equals(
      act   = es_product_detail-ordered_prod
      exp   = gv_prod_id
      msg   = 'Product ID determined from alternative id:failed'
    ).

  ENDMETHOD.




ENDCLASS.