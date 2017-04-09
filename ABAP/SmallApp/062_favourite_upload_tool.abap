*&---------------------------------------------------------------------*
*& Report  ZFAVORITE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zfavorite.

TYPES: tt_tcode  TYPE STANDARD TABLE OF tstct-tcode,
       tt_wd_app TYPE STANDARD TABLE OF wdy_applicationt-application_name.
TYPES: BEGIN OF ty_file,
         text  LIKE smen_buffc-text,
         tcode LIKE smen_buffc-report,
       END   OF ty_file.

CLASS lcl_counter DEFINITION.

  PUBLIC SECTION.
    METHODS: get_new_obj_id RETURNING VALUE(rv_id) TYPE int4,
      get_folder_sort RETURNING VALUE(rv_id) TYPE int4,
      get_tcode_sort RETURNING VALUE(rv_id) TYPE int4,
      reset_tcode_sort.

    CONSTANTS: cv_root TYPE smen_buffc-parent_id VALUE '00001'.
    CONSTANTS: cv_level1 TYPE smen_buffc-menu_level VALUE '01',
               cv_level2 LIKE cv_level1 VALUE '02'.
  PRIVATE SECTION.
    DATA: mv_object_id   TYPE int4 VALUE 1,
          mv_folder_sort TYPE int4 VALUE 0,
          mv_tcode_sort  TYPE int4 VALUE 0.
ENDCLASS.

CLASS lcl_counter IMPLEMENTATION.
  METHOD: get_new_obj_id.
    ADD 1 TO mv_object_id.
    rv_id = mv_object_id.
  ENDMETHOD.

  METHOD: get_folder_sort.
    ADD 10 TO mv_folder_sort.
    rv_id = mv_folder_sort.
  ENDMETHOD.

  METHOD: get_tcode_sort.
    ADD 10 TO mv_tcode_sort.
    rv_id = mv_tcode_sort.
  ENDMETHOD.

  METHOD reset_tcode_sort.
    CLEAR: mv_tcode_sort.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_tool DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: is_tcode  IMPORTING iv_text TYPE string RETURNING VALUE(result) TYPE abap_bool.
    CLASS-METHODS: is_wd_app  IMPORTING iv_text TYPE string RETURNING VALUE(result) TYPE abap_bool.
    CLASS-METHODS: get_tcode IMPORTING iv_text TYPE smen_buffc-text RETURNING VALUE(result) TYPE smen_buffc-report.
    CLASS-METHODS: get_wd_app IMPORTING iv_text TYPE smen_buffc-text RETURNING VALUE(result) TYPE smen_buffc-report.
    CLASS-METHODS: set_tcode_list IMPORTING it_tcode TYPE tt_tcode.
    CLASS-METHODS: set_wd_app_list IMPORTING it_app TYPE tt_wd_app.

    CLASS-METHODS: get_tcode_description IMPORTING iv_tcode TYPE smen_buffc-report RETURNING VALUE(result) TYPE smen_buffc-text.
    CLASS-METHODS: get_app_description IMPORTING iv_app TYPE smen_buffc-text RETURNING VALUE(result) TYPE smen_buffc-text.
    CLASS-METHODS: get_menu_type IMPORTING is_menu TYPE ty_file RETURNING VALUE(result) TYPE int4.

    CONSTANTS: cv_wd_app_type   TYPE smen_buffc-reporttype VALUE 'OT',
               cv_wd_app_report TYPE smen_buffc-report VALUE 'WDY_APPLICATION',
               BEGIN OF cs_entry_type,
                 top_tcode    TYPE int4 VALUE 1,
                 folder       TYPE int4 VALUE 2,
                 child_tcode  TYPE int4 VALUE 3,
                 top_wd_app   TYPE int4 VALUE 4,
                 child_wd_app TYPE int4 VALUE 5,
                 invalid      TYPE int4 VALUE 6,
               END OF cs_entry_type.

  PRIVATE SECTION.
    CLASS-DATA: st_tcode  TYPE STANDARD TABLE OF tstct,
                st_wd_app TYPE STANDARD TABLE OF wdy_applicationt.
ENDCLASS.

CLASS lcl_tool IMPLEMENTATION.
  METHOD: is_tcode.
    IF iv_text CP '[*]'.
      result = abap_true.
    ELSE.
      result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD: is_wd_app.
    IF iv_text CP '(*)'.
      result = abap_true.
    ELSE.
      result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD: get_tcode.

    result = iv_text.
    REPLACE ALL OCCURRENCES OF REGEX `[\[\]]` IN result WITH space.

    CONDENSE result NO-GAPS.
  ENDMETHOD.

  METHOD: get_wd_app.

    result = iv_text.
    REPLACE ALL OCCURRENCES OF REGEX `[\(\)]` IN result WITH space.

    CONDENSE result NO-GAPS.
  ENDMETHOD.

  METHOD: set_tcode_list.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE st_tcode FROM tstct
      FOR ALL ENTRIES IN it_tcode WHERE sprsl = sy-langu AND tcode = it_tcode-table_line.

  ENDMETHOD.

  METHOD: set_wd_app_list.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE st_wd_app FROM wdy_applicationt
       FOR ALL ENTRIES IN it_app WHERE application_name = it_app-table_line AND langu = sy-langu.
  ENDMETHOD.

  METHOD: get_tcode_description.
    FIELD-SYMBOLS: <line> TYPE tstct.
    READ TABLE st_tcode ASSIGNING <line> WITH KEY tcode = iv_tcode.
    IF sy-subrc = 0.
      result = <line>-ttext.
    ENDIF.
  ENDMETHOD.

  METHOD: get_app_description.

    FIELD-SYMBOLS: <line> LIKE LINE OF st_wd_app.
    READ TABLE st_wd_app ASSIGNING <line> WITH KEY application_name = iv_app.
    IF sy-subrc = 0.
      result = <line>-description.
    ENDIF.
  ENDMETHOD.

  METHOD: get_menu_type.
    DATA: lv_is_tcode  TYPE abap_bool,
          lv_is_wd_app TYPE abap_bool.

    lv_is_tcode = is_tcode( CONV #( is_menu-text ) ).
    lv_is_wd_app = is_wd_app( CONV #( is_menu-text ) ).

    IF is_menu-text IS NOT INITIAL AND is_menu-tcode IS INITIAL.
      IF is_tcode( CONV #( is_menu-text ) ) = abap_true.
        result = cs_entry_type-top_tcode.
      ELSEIF is_wd_app( CONV #( is_menu-text ) ) = abap_true.
        result = cs_entry_type-top_wd_app.
      ELSE.
        result = cs_entry_type-folder.
      ENDIF.
    ELSEIF is_menu-tcode IS NOT INITIAL.
      IF is_tcode( CONV #( is_menu-tcode ) ) = abap_true.
        result = cs_entry_type-child_tcode.
      ELSEIF is_wd_app( CONV #( is_menu-tcode ) ) = abap_true.
        result = cs_entry_type-child_wd_app.
      ELSE.
        result = cs_entry_type-invalid.
      ENDIF.
    ELSE.
      result = cs_entry_type-invalid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA: gt_file     TYPE STANDARD TABLE OF ty_file,
        gt_tcodes   TYPE tt_tcode,
        gt_wd_app   TYPE tt_wd_app,
        lo_counter  TYPE REF TO lcl_counter,
        lv_filename TYPE localfile,
        lv_name_string type string.

  CALL FUNCTION 'NAVIGATION_FILENAME_HELP'
    EXPORTING
      default_path_long      = '*.*'
      mode                   = 'O'
    IMPORTING
      selected_filename = lv_filename.


  CHECK lv_filename IS NOT INITIAL.
  lv_name_string = lv_filename.
  CREATE OBJECT lo_counter.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_name_string
      filetype                = 'ASC'
      has_field_separator     = 'X'
    TABLES
      data_tab                = gt_file
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6                           "as of 4.6C
      OTHERS                  = 7.

  DELETE gt_file WHERE tcode IS INITIAL AND text IS INITIAL.

  DATA: ls_menu_entry     TYPE smen_buffc,
        lt_menu_entry     TYPE STANDARD TABLE OF smen_buffc,
        ls_web_link       TYPE smen_buffi,
        lt_web_link       TYPE STANDARD TABLE OF smen_buffi,
        lv_current_par_id TYPE smen_buffc-parent_id.

  FIELD-SYMBOLS: <entry> LIKE LINE OF gt_file,
                 <menu>  LIKE LINE OF lt_menu_entry,
                 <link>  TYPE smen_buffi.

  LOOP AT gt_file ASSIGNING <entry>.
    CLEAR: ls_menu_entry.
    ls_menu_entry-object_id = lo_counter->get_new_obj_id( ).
    ls_menu_entry-uname = 'LIKE2'.
    ls_menu_entry-mandt = sy-mandt.

    CASE lcl_tool=>get_menu_type( <entry> ).
      WHEN lcl_tool=>cs_entry_type-top_tcode.
        ls_menu_entry-reporttype = 'TR'.
        ls_menu_entry-parent_id = lcl_counter=>cv_root.
        ls_menu_entry-report = lcl_tool=>get_tcode( <entry>-text ).
        ls_menu_entry-menu_level = lcl_counter=>cv_level1.
        ls_menu_entry-sort_order = lo_counter->get_folder_sort( ).
        APPEND ls_menu_entry-report TO gt_tcodes.
      WHEN lcl_tool=>cs_entry_type-top_wd_app.
        ls_menu_entry-reporttype = 'OT'.
        ls_menu_entry-parent_id = lcl_counter=>cv_root.
        ls_menu_entry-report = lcl_tool=>cv_wd_app_report.
        ls_menu_entry-menu_level = lcl_counter=>cv_level1.
        ls_menu_entry-sort_order = lo_counter->get_folder_sort( ).
        ls_web_link-object_id = ls_menu_entry-object_id.
        APPEND ls_web_link TO lt_web_link.
        ls_menu_entry-text  = lcl_tool=>get_wd_app( <entry>-text ).
        APPEND ls_menu_entry-text  TO gt_wd_app.
      WHEN lcl_tool=>cs_entry_type-folder.
        ls_menu_entry-text = <entry>-text.
        ls_menu_entry-parent_id = lcl_counter=>cv_root.

        ls_menu_entry-sort_order = lo_counter->get_folder_sort( ).
        ls_menu_entry-menu_level = lcl_counter=>cv_level1.
        lv_current_par_id = ls_menu_entry-object_id.
        lo_counter->reset_tcode_sort( ).
      WHEN lcl_tool=>cs_entry_type-child_tcode.
        ls_menu_entry-reporttype = 'TR'.
        ls_menu_entry-report = lcl_tool=>get_tcode( CONV #( <entry>-tcode ) ).
        ls_menu_entry-parent_id = lv_current_par_id.
        ls_menu_entry-sort_order = lo_counter->get_tcode_sort( ).
        ls_menu_entry-menu_level = lcl_counter=>cv_level2.
        APPEND ls_menu_entry-report TO gt_tcodes.
      WHEN lcl_tool=>cs_entry_type-child_wd_app.
        ls_menu_entry-reporttype = 'OT'.
        ls_menu_entry-report = lcl_tool=>cv_wd_app_report.
        ls_menu_entry-parent_id = lv_current_par_id.
        ls_menu_entry-sort_order = lo_counter->get_tcode_sort( ).
        ls_menu_entry-menu_level = lcl_counter=>cv_level2.
        ls_menu_entry-text  = lcl_tool=>get_wd_app( CONV #( <entry>-tcode ) ).
        APPEND ls_menu_entry-text TO gt_wd_app.
        ls_web_link-object_id = ls_menu_entry-object_id.
        APPEND ls_web_link TO lt_web_link.
      WHEN OTHERS.
        WRITE: / 'Invalid record: ', <entry>-text, <entry>-tcode COLOR COL_NEGATIVE.
        RETURN.
    ENDCASE.
    APPEND ls_menu_entry TO lt_menu_entry.
  ENDLOOP.

  lcl_tool=>set_tcode_list( gt_tcodes ).
  lcl_tool=>set_wd_app_list( gt_wd_app ).

  LOOP AT lt_menu_entry ASSIGNING <menu> WHERE reporttype = 'TR'.
    <menu>-text = lcl_tool=>get_tcode_description( <menu>-report ).
  ENDLOOP.

  LOOP AT lt_web_link ASSIGNING <link>.
    <link>-mandt = sy-mandt.
    <link>-link_type = 'W'.
    <link>-uname = 'LIKE2'.
    READ TABLE lt_menu_entry INTO ls_menu_entry WITH KEY object_id = <link>-object_id.
    CHECK sy-subrc = 0.
    TRANSLATE ls_menu_entry-text TO LOWER CASE.
    <link>-url = '0E' && ls_menu_entry-text.
  ENDLOOP.

  LOOP AT lt_menu_entry ASSIGNING <menu> WHERE reporttype = 'OT'.
    <menu>-text = lcl_tool=>get_app_description( <menu>-text ).
  ENDLOOP.

  DELETE FROM smen_buffc WHERE uname = 'LIKE2'.
  DELETE FROM smen_buffi WHERE uname = 'LIKE2'.

  INSERT smen_buffc FROM TABLE lt_menu_entry.
  INSERT smen_buffi FROM TABLE lt_web_link.

  COMMIT WORK AND WAIT.

  WRITE: / 'Favorite list uploaded successfully, total entries: ', lines( lt_menu_entry ) COLOR COL_POSITIVE.