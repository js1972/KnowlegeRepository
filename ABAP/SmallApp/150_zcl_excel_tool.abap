CLASS zcl_excel_tool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_settype_fields
      IMPORTING
        !iv_settype_id TYPE comt_frgtype_id DEFAULT 'COMM_PR_SHTEXT' .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_column,
        a_index       TYPE char3,
        b_table       TYPE dd03l-tabname,
        c_fieldname   TYPE dd03l-fieldname,
        d_element     TYPE dd03l-rollname,
        e_datatype    TYPE x031l-dtyp,
        f_length      TYPE char4,
        g_description TYPE char40,
      END OF ty_column .
    TYPES:
      tt_column TYPE STANDARD TABLE OF ty_column WITH KEY a_index b_table c_fieldname .
    TYPES:
      BEGIN OF ty_clipdata,
        data TYPE c LENGTH 500,
      END   OF ty_clipdata .
    TYPES:
      tt_formatted TYPE STANDARD TABLE OF ty_clipdata .

    DATA mt_column TYPE tt_column .
    DATA mt_formatted TYPE tt_formatted .
    CONSTANTS c_tab TYPE char1 VALUE cl_abap_char_utilities=>horizontal_tab ##NO_TEXT.

    METHODS convert .
    METHODS get_field_label
      IMPORTING
        !iv_tab_name    TYPE ddobjname
        !iv_field_name  TYPE dfies-fieldname
      RETURNING
        VALUE(rv_label) TYPE string .
ENDCLASS.



CLASS ZCL_EXCEL_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_EXCEL_TOOL->CONVERT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD convert.

    LOOP AT mt_column ASSIGNING FIELD-SYMBOL(<raw>).
      APPEND INITIAL LINE TO mt_formatted ASSIGNING FIELD-SYMBOL(<converted>).
      CONCATENATE <raw>-a_index <raw>-b_table <raw>-c_fieldname <raw>-d_element <raw>-e_datatype
      <raw>-f_length <raw>-g_description INTO <converted> SEPARATED BY c_tab.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_EXCEL_TOOL->GET_FIELD_LABEL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TAB_NAME                    TYPE        DDOBJNAME
* | [--->] IV_FIELD_NAME                  TYPE        DFIES-FIELDNAME
* | [<-()] RV_LABEL                       TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_field_label.
    CALL FUNCTION 'DDIF_FIELDLABEL_GET'
      EXPORTING
        tabname   = iv_tab_name
        fieldname = iv_field_name
        langu     = sy-langu
      IMPORTING
        label     = rv_label.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_EXCEL_TOOL->GET_SETTYPE_FIELDS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SETTYPE_ID                  TYPE        COMT_FRGTYPE_ID (default ='COMM_PR_SHTEXT')
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_settype_fields.
    DATA: lv_tab  TYPE comc_settype-frgtype_tab,
          lv_ret  TYPE int4,
          lt_list TYPE STANDARD TABLE OF x031l.

    SELECT SINGLE frgtype_tab INTO lv_tab FROM comc_settype WHERE frgtype_id = iv_settype_id.
    IF sy-subrc <> 0.
      WRITE: / 'no database table maintained for settype: ', iv_settype_id.
      RETURN.
    ENDIF.

    CALL FUNCTION 'DDIF_NAMETAB_GET'
      EXPORTING
        tabname   = CONV ddobjname( lv_tab )
        status    = 'A'
      TABLES
        x031l_tab = lt_list
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc <> 0.
      WRITE:/ 'table metadata parse error'.
      RETURN.
    ENDIF.

    LOOP AT lt_list ASSIGNING FIELD-SYMBOL(<list>).
      APPEND INITIAL LINE TO mt_column ASSIGNING FIELD-SYMBOL(<insert>).
      <insert>-a_index = sy-tabix.
      <insert>-b_table = lv_tab.
      <insert>-c_fieldname = <list>-fieldname.
      <insert>-d_element = <list>-rollname.
      <insert>-e_datatype = <list>-dtyp.
      <insert>-f_length = CONV i( <list>-exlength ). "cast CL_ABAP_ELEMDESCR( CL_ABAP_ELEMDESCR=>describe_by_name( <list>-rollname ) )->output_length.
      <insert>-g_description = get_field_label( EXPORTING iv_tab_name = CONV #( lv_tab ) iv_field_name = <list>-fieldname ).
    ENDLOOP.

    convert( ).
    cl_gui_frontend_services=>clipboard_export(
    EXPORTING
        no_auth_check        = abap_true
        IMPORTING
          data                 = mt_formatted
        CHANGING
          rc                   = lv_ret
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
      ).

  ENDMETHOD.
ENDCLASS.