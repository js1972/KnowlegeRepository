*&---------------------------------------------------------------------*
*& Report  ZHANA_CAL_VIEW
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZHANA_CAL_VIEW.

DATA: r_adbc_conn TYPE REF TO CL_SQL_CONNECTION,
      lv_table_name TYPE ADBC_NAME,
      gt_hana_max_field_list TYPE ADBC_TABCOL_DESCR_TAB.

r_adbc_conn = cl_db6_con=>get_connection( connection_name = 'R/3*' sharable = 'X' ).
lv_table_name = 'sap.crm.ic-aui/CA_IC_INBOX'.
r_adbc_conn->get_metadata( )->get_columns(
            EXPORTING schema_name = '_SYS_BIC' table_name = lv_table_name
            IMPORTING column_tab = gt_hana_max_field_list ).
r_adbc_conn->close( ).

BREAK-POINT.