*&---------------------------------------------------------------------*
*& Report  ZSEARCH_BP_IN_APPOINTMENT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZSEARCH_BP_IN_APPOINTMENT.


    DATA: lv_use_es             TYPE char1.
    DATA: lv_cursor             TYPE cursor.
    DATA: lv_orderby            TYPE string.

    DATA: lv_select_statement             TYPE string.
    DATA: lt_select_statement   TYPE crmt_bp_odata_string_t.
    DATA: lt_from_statement     TYPE crmt_bp_odata_string_t.
    DATA: lt_where_statement    TYPE crmt_bp_odata_string_t.

    FIELD-SYMBOLS: <lf_sel_opt>       TYPE /iwbep/s_cod_select_option.
    FIELD-SYMBOLS: <lt_result_data>   TYPE STANDARD TABLE.
    FIELD-SYMBOLS: <lt_package_data>  TYPE STANDARD TABLE.

    DATA: lr_result_data       TYPE REF TO data.
    DATA: lr_package_data      TYPE REF TO data.


    DATA: lv_more_records_on_db           TYPE abap_bool.

    DATA: lt_result TYPE crmt_bp_odata_account_sel_t,
          lr_result TYPE REF TO crmt_bp_odata_account_sel_t.
    DATA: lv_package_size TYPE i VALUE 80.
    DATA: it_authgroup_range TYPE bup_augr_range_t,
          ls_authgroup_range LIKE LINE OF it_authgroup_range.

    GET REFERENCE OF lt_result INTO lr_result.

    ASSIGN lr_result->* TO <lt_package_data>.

    ls_authgroup_range-sign = 'I'.
    ls_authgroup_range-option = 'EQ'.
    APPEND ls_authgroup_range TO it_authgroup_range.

    ls_authgroup_range-low = 'RTRD'.
    APPEND ls_authgroup_range TO it_authgroup_range.

    lv_select_statement = `account~partner      AS account_id, account~partner_guid AS account_guid, `
    && `account~name_org1    AS name1, account~mc_name1     AS mc_name1, account~name_org2, account~name_last,`
    && `account~name_first, account~name_grp1, account~name_grp2, `
    && `account~title, account~title_aca1, account~birthdt      AS birthdate,`
    && ` type AS category, account~xpcpt, account~persnumber`.

    APPEND 'but000 AS account' TO lt_from_statement.

    APPEND 'account~xdele = @space' TO lt_where_statement.

    IF 0 = 1.
      APPEND 'AND account~augrp IN @it_authgroup_range' TO lt_where_statement.
    ENDIF.

    lv_orderby = 'mc_name1 ASCENDING'.

    OPEN CURSOR WITH HOLD @lv_cursor FOR

     SELECT DISTINCT (lv_select_statement)
            FROM (lt_from_statement)
            WHERE (lt_where_statement)
            ORDER BY (lv_orderby).


    DO.
      FETCH NEXT CURSOR @lv_cursor
            INTO CORRESPONDING FIELDS OF TABLE @<lt_package_data>
            PACKAGE SIZE @lv_package_size.

      IF sy-subrc = 0.
        IF lines( <lt_package_data> ) >=   80.
          lv_more_records_on_db       =    abap_true.
        ENDIF.

      EXIT.
      ENDIF.
    ENDDO.
    CLOSE CURSOR @lv_cursor.