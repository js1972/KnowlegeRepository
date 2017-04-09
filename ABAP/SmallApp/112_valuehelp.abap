*&---------------------------------------------------------------------*
*& Report ZCO_TEST_CDS_REDIRECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zco_test_cds_redirect.

PARAMETERS: p TYPE string.

DATA : return_tab LIKE ddshretval OCCURS 0 WITH HEADER LINE.

  DATA: ls_readonly TYPE zcomm_product.

  INSERT zcomm_product FROM ls_readonly.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p.
  DATA: lt_tadir TYPE STANDARD TABLE OF tadir.


  SELECT * INTO TABLE lt_tadir FROM tadir UP TO 10 ROWS.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'OBJ_NAME'
      value_org       = 'S'
    TABLES
      value_tab       = lt_tadir
      return_tab      = return_tab
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF sy-subrc = 0.
    p = return_tab-fieldval.
  ENDIF.