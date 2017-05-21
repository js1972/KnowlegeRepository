*&---------------------------------------------------------------------*
*& Report  ZABAPDOC v2.1
*&
*&---------------------------------------------------------------------*
*& This report generate HTML files containing the API information about
*& the selected function modules.
*& SDN http://www.sdn.sap.com/irj/scn/weblogs?blog=/pub/wlg/17971
*& This program has been developed via the ABAP Eclipse Editor
*&---------------------------------------------------------------------*
*& Release 2.1 alpha
*&
*& Changes to fill requirements for ABAP101 documentation.
*&---------------------------------------------------------------------*

REPORT  zabapdoc MESSAGE-ID eu.

TYPE-POOLS:
  sscr,
  seoc.

TABLES:
  tadir,
  tlibt,
  trdir,
  seoclass.

TYPES:
BEGIN OF ts_objects,
    pgmid          TYPE pgmid,
    object  TYPE trobjtype,
    obj_name  TYPE sobj_name,
END OF ts_objects.

CLASS:
  lcl_source_scan DEFINITION DEFERRED.

DATA:
  lo_sscan   TYPE REF TO lcl_source_scan,
  lv_appl    TYPE taplt-appl,
  tofolder_string TYPE string,
  texttr     TYPE string VALUE `/~`,
  filename   TYPE string,
  gv_project type char255.

SELECTION-SCREEN: BEGIN OF BLOCK a11 WITH FRAME TITLE a11.
SELECT-OPTIONS:      funcgrp  FOR tlibt-area .
SELECTION-SCREEN: END OF BLOCK a11,
                   BEGIN OF BLOCK a12 WITH FRAME TITLE a12.
SELECT-OPTIONS:        clazz  FOR seoclass-clsname.
SELECTION-SCREEN: END OF BLOCK a12,
                   BEGIN OF BLOCK a13 WITH FRAME TITLE a13.
SELECT-OPTIONS:       devclass FOR tadir-devclass.
SELECTION-SCREEN: END OF BLOCK a13,
                  BEGIN OF BLOCK a20 WITH FRAME TITLE a20.
PARAMETERS:           tofolder    TYPE char255 DEFAULT 'C:\TEMP'.
SELECTION-SCREEN: END OF BLOCK a20.
SELECTION-SCREEN: BEGIN OF BLOCK a21 WITH FRAME TITLE a21.
PARAMETERS:           project    TYPE char255 LOWER CASE DEFAULT 'ABAP101 Labs - '.
SELECTION-SCREEN: END OF BLOCK a21.


*----------------------------------------------------------------------*
*       CLASS lcx_scan_exceptions DEFINITION
*----------------------------------------------------------------------*
*       Exceptions for source scanning
*----------------------------------------------------------------------*
CLASS lcx_scan_exceptions DEFINITION INHERITING FROM cx_static_check.
ENDCLASS.                    "lcx_scan_exceptions DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_source_scan DEFINITION
*----------------------------------------------------------------------*
*       ABAP source scanner
*----------------------------------------------------------------------*
CLASS lcl_source_scan DEFINITION.
  PUBLIC SECTION.
    METHODS:
      constructor,

      f4_class
        CHANGING
          cv_class_name TYPE clike,

      f4_function_group
        IMPORTING
          iv_group_name TYPE clike,

      f4_repname
        CHANGING
          cv_repname TYPE clike,

      start.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF ty_ls_objname,
        report TYPE sy-repid,
        dynnr  TYPE sy-dynnr,
      END OF ty_ls_objname.

    TYPES:
      BEGIN OF ts_comment_tab,
        report TYPE sy-repid,
        source TYPE abaptxt255,
      END OF ts_comment_tab.


    DATA:
      gv_hit_count  TYPE i,
      gv_sstring    TYPE string,
      gv_dynp_found TYPE xfeld,
      gv_vers_found TYPE xfeld,
      gt_object     TYPE STANDARD TABLE OF ts_objects,
      gt_vrsd       TYPE HASHED TABLE OF vrsd
                      WITH UNIQUE KEY objname versno,
      gt_results    TYPE TABLE OF ts_comment_tab,
      gt_mtdkey     TYPE  seocpdkey
                      .


    CONSTANTS:
      gc_x TYPE xfeld VALUE 'X'.

    METHODS:

      display,

      get_version_numbers
        IMPORTING
          iv_report TYPE clike
          iv_dynpro TYPE clike OPTIONAL
        RETURNING value(rt_vrsd) LIKE gt_vrsd,

      get_source_names,

      get_source_by_version
        IMPORTING
          iv_report TYPE clike
          iv_dynpro TYPE clike OPTIONAL
          iv_versno TYPE vrsd-versno
        RETURNING value(rt_abap) TYPE abaptxt255_tab,

      get_report_names,
      get_function_names,
      get_includes,

      get_method_includes
        IMPORTING
          iv_class_name TYPE clike
          iv_where      TYPE i,

      search_abap_source   RAISING lcx_scan_exceptions,

      search_source
        IMPORTING
          it_source TYPE abaptxt255_tab
          iv_report TYPE clike
          iv_dynpro TYPE clike OPTIONAL
        RAISING lcx_scan_exceptions,

      generateindex,

      generateinfopage
          IMPORTING
              iv_fm TYPE rs38l_fnam
              iv_report TYPE progname OPTIONAL,

      generateinfomethpage
          IMPORTING
              iv_incl TYPE sobj_name
              iv_class TYPE seoclsname
              iv_meth TYPE seocpdname
              ,

      generateinfoclasspage
          IMPORTING
              iv_class TYPE sobj_name
              ,

      get_parametertype
          IMPORTING
              is_eparameter TYPE rsexp OPTIONAL
              is_iparameter TYPE rsimp OPTIONAL
              is_cparameter TYPE rscha OPTIONAL
              is_tparameter TYPE rstbl OPTIONAL
          RETURNING value(rl_type) TYPE string,

      get_parametertypename
          IMPORTING
              is_eparameter TYPE rsexp OPTIONAL
              is_iparameter TYPE rsimp OPTIONAL
              is_cparameter TYPE rscha OPTIONAL
              is_tparameter TYPE rstbl OPTIONAL
          RETURNING value(rl_type) TYPE string,

      get_parameterdecltype
         IMPORTING
           is_type TYPE seopardecl
         RETURNING value(rv_type) TYPE string,

      get_attdecltype
         IMPORTING
           is_type TYPE seopardecl
         RETURNING value(rv_type) TYPE string,

      get_parametertyptype
         IMPORTING
           is_type TYPE seotyptype
         RETURNING value(rv_type) TYPE string.


ENDCLASS.                    "lcl_source_scan DEFINITION


*----------------------------------------------------------------------*
*       CLASS lcl_source_scan IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_source_scan IMPLEMENTATION.

  METHOD constructor.
    DATA:
      ls_restrict    TYPE sscr_restrict,
      ls_opt_list    TYPE sscr_opt_list,
      ls_association TYPE sscr_ass.

    ls_opt_list-name       = 'RESTRICT'.
    ls_opt_list-options-cp = gc_x.
    ls_opt_list-options-eq = gc_x.

    APPEND ls_opt_list TO ls_restrict-opt_list_tab.

    ls_association-kind    = 'S'.
    ls_association-name    = 'SSTRING'.
    ls_association-sg_main = 'I'.
    ls_association-op_main = ls_association-op_addy = 'RESTRICT'.

    APPEND ls_association TO ls_restrict-ass_tab.

    CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
      EXPORTING
        program                = sy-repid
        restriction            = ls_restrict
      EXCEPTIONS
        too_late               = 1
        repeated               = 2
        selopt_without_options = 3
        selopt_without_signs   = 4
        invalid_sign           = 5
        empty_option_list      = 6
        invalid_kind           = 7
        repeated_kind_a        = 8
        OTHERS                 = 9.

  ENDMETHOD.                    "constructor

  METHOD f4_repname.
    CALL FUNCTION 'REPOSITORY_INFO_SYSTEM_F4'
      EXPORTING
        object_type          = 'PROG'
        object_name          = cv_repname
        suppress_selection   = 'X'
      IMPORTING
        object_name_selected = cv_repname
      EXCEPTIONS
        cancel               = 1.
  ENDMETHOD.                                                "f4_repname

  METHOD f4_function_group.
    DATA:
      lv_fname TYPE dynfnam.

    lv_fname = iv_group_name.

    CALL FUNCTION 'RS_HELP_HANDLING'
      EXPORTING
        dynpfield                 = lv_fname
        dynpname                  = sy-dynnr
        object                    = 'FG  '
        progname                  = sy-repid
        suppress_selection_screen = 'X'.

  ENDMETHOD.                    "f4_function_group

  METHOD f4_class.
    CALL FUNCTION 'F4_DD_ALLTYPES'
      EXPORTING
        object               = cv_class_name
        suppress_selection   = gc_x
        display_only         = space
        only_types_for_clifs = gc_x
      IMPORTING
        RESULT               = cv_class_name.
  ENDMETHOD.                                                "f4_class

  METHOD display.
    DATA lv_filename TYPE string.

    WRITE: / 'API information files have been generated.'.
    CONCATENATE tofolder '\abapdoc_index.html' INTO lv_filename.
    WRITE: / 'Open',  lv_filename, 'in your browser to view the ABAPdoc.'.

  ENDMETHOD.                    "display


  METHOD get_source_by_version.
    DATA:
      lv_object_name TYPE versobjnam,
      ls_object_name TYPE ty_ls_objname,
      lt_trdir       TYPE STANDARD TABLE OF trdir,
      lt_d022s       TYPE STANDARD TABLE OF d022s.

    IF iv_dynpro IS INITIAL.
      lv_object_name = iv_report.

      CALL FUNCTION 'SVRS_GET_REPS_FROM_OBJECT'
        EXPORTING
          object_name                  = lv_object_name
          object_type                  = 'REPS'
          versno                       = iv_versno
          iv_no_release_transformation = 'X'
        TABLES
          repos_tab                    = rt_abap
          trdir_tab                    = lt_trdir
        EXCEPTIONS
          no_version                   = 1
          OTHERS                       = 2.
    ELSE.
      ls_object_name-report = iv_report.
      ls_object_name-dynnr  = iv_dynpro.

      lv_object_name = ls_object_name.

      CALL FUNCTION 'SVRS_GET_VERSION_DYNP_40'
        EXPORTING
          object_name = lv_object_name
          versno      = iv_versno
        TABLES
          d022s_tab   = lt_d022s
        EXCEPTIONS
          no_version  = 01
          OTHERS      = 02.

      CHECK sy-subrc IS INITIAL AND lt_d022s IS NOT INITIAL.

      APPEND LINES OF lt_d022s TO rt_abap.

    ENDIF.
  ENDMETHOD.                    "get_source_by_version

  METHOD get_version_numbers.
    DATA:
      ls_objname TYPE ty_ls_objname,
      lv_objtype TYPE vrsd-objtype,
      lv_objname TYPE versobjnam,
      lv_versno  TYPE versno,
      lt_vrsn    TYPE STANDARD TABLE OF vrsn,
      lt_vrsd    TYPE STANDARD TABLE OF vrsd.

    ls_objname-report = iv_report.
    ls_objname-dynnr  = iv_dynpro.
    lv_objname        = ls_objname.

    IF iv_dynpro IS INITIAL.
      lv_objtype = 'REPS'.
    ELSE.
      lv_objtype = 'DYNP'.
    ENDIF.

    CALL FUNCTION 'SVRS_GET_VERSION_DIRECTORY_46'
      EXPORTING
        objname                = lv_objname
        objtype                = lv_objtype
      TABLES
        lversno_list           = lt_vrsn
        version_list           = lt_vrsd
      EXCEPTIONS
        no_entry               = 1
        communication_failure_ = 2
        system_failure         = 3
        OTHERS                 = 4.

    CHECK sy-subrc IS INITIAL .

    SORT lt_vrsd BY objname versno.
    DELETE ADJACENT DUPLICATES FROM lt_vrsd COMPARING objname versno.

    rt_vrsd = lt_vrsd.

    DELETE TABLE rt_vrsd WITH TABLE KEY objname = lv_objname
                                        versno  = lv_versno.

    SORT rt_vrsd.

    CHECK iv_dynpro IS NOT INITIAL.
*   For dynpros we need to save the version information for the version display
*   this is not required for source code
    INSERT LINES OF rt_vrsd INTO TABLE gt_vrsd.

  ENDMETHOD.                    "get_version_Numbers

  METHOD search_abap_source.
    DATA:
      lt_abap TYPE abaptxt255_tab.

    FIELD-SYMBOLS:
     <lv_obj> TYPE ts_objects.

    LOOP AT gt_object ASSIGNING <lv_obj>.
      READ REPORT <lv_obj>-obj_name INTO lt_abap.
      IF sy-subrc IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      search_source( it_source = lt_abap
                     iv_report = <lv_obj>-obj_name ).

    ENDLOOP.

    "FREE gt_object.

  ENDMETHOD.                    "search_abap_source

  METHOD search_source.
    DATA:
      lt_source       TYPE abaptxt255_tab,
      lt_source_vers  TYPE abaptxt255_tab,
      lt_vrsd         TYPE STANDARD TABLE OF vrsd,
      ls_vrsd         LIKE LINE OF lt_vrsd,
      lv_number       TYPE i,
      lv_index        TYPE i.

    lt_source = it_source.

    lv_number = 1.

    DO lv_number TIMES.

      IF sy-index = 1.
        CLEAR ls_vrsd.
      ELSE.
        lv_index = sy-index - 1.
        READ TABLE lt_vrsd INDEX lv_index INTO ls_vrsd.
        CHECK sy-subrc IS INITIAL.

        lt_source_vers = get_source_by_version( iv_report = iv_report
                                                iv_dynpro = iv_dynpro
                                                iv_versno = ls_vrsd-versno ).

        IF lt_source_vers IS NOT INITIAL.
          lt_source = lt_source_vers.
        ELSE.
          CONTINUE.
        ENDIF.
      ENDIF.

      DATA: tokens       TYPE TABLE OF stokesx,
            token        TYPE stokesx,
            tokenource   TYPE stokesx,
            statement    TYPE sstmnt,
            statements   TYPE TABLE OF sstmnt,
            selectsource TYPE string,
            mat_res      TYPE ts_comment_tab,
            lv_line      TYPE abaptxt255.

      LOOP AT lt_source INTO lv_line.
        IF ( sy-tabix = 1 AND lv_line(8) = 'FUNCTION' ).
          CONTINUE.
        ELSEIF ( sy-tabix = 1 AND lv_line(6) = 'METHOD' ).
          CONTINUE.
        ELSEIF ( sy-tabix > 1 AND lv_line(1) = '*' ).
          mat_res-source = lv_line.
          mat_res-report = iv_report.
          INSERT mat_res INTO TABLE gt_results.
        ELSEIF ( sy-tabix > 1 AND lv_line = '' ).
          mat_res-source = lv_line.
          mat_res-report = iv_report.
          INSERT mat_res INTO TABLE gt_results.
        ELSE.
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDDO.
  ENDMETHOD.                    "search_source

  METHOD get_includes.
    DATA:
     lt_inc     TYPE STANDARD TABLE OF ts_objects,
     lt_inc_tmp TYPE STANDARD TABLE OF sobj_name,
     lv_inc_tmp LIKE LINE OF lt_inc_tmp,
     lv_inc     LIKE LINE OF lt_inc,
     lv_program TYPE sy-repid,
     lv_counter TYPE i.

    FIELD-SYMBOLS:
      <lv_obj> TYPE ts_objects.

    LOOP AT gt_object ASSIGNING <lv_obj>.
      lv_counter = sy-tabix + 1.

      IF <lv_obj>-object = 'CLAS'.
        me->get_method_includes( iv_class_name = <lv_obj>-obj_name iv_where = lv_counter ).

      ELSE.

        REFRESH lt_inc_tmp.

        lv_program = <lv_obj>-obj_name.

        CALL FUNCTION 'RS_GET_ALL_INCLUDES'
          EXPORTING
            program      = lv_program
          TABLES
            includetab   = lt_inc_tmp
          EXCEPTIONS
            not_existent = 1
            no_program   = 2
            OTHERS       = 3.

        CHECK sy-subrc IS INITIAL.

        LOOP AT lt_inc_tmp INTO lv_inc_tmp.
          CLEAR lv_inc.
          lv_inc-obj_name = lv_inc_tmp.
          APPEND lv_inc TO lt_inc.
        ENDLOOP.

      ENDIF.
    ENDLOOP.

    SORT lt_inc.
    DELETE ADJACENT DUPLICATES FROM lt_inc.

    APPEND LINES OF lt_inc TO gt_object.

  ENDMETHOD.                    "get_includes

  METHOD get_method_includes.
    DATA: lo_name     TYPE REF TO cl_oo_include_naming,
          lo_name_tmp TYPE REF TO if_oo_clif_incl_naming,
          lt_method   TYPE seop_methods_w_include,
          lv_obj      TYPE ts_objects.

    FIELD-SYMBOLS:
     <ls_method> LIKE LINE OF lt_method.

    CALL METHOD cl_oo_include_naming=>get_instance_by_name
      EXPORTING
        name           = iv_class_name
      RECEIVING
        cifref         = lo_name_tmp
      EXCEPTIONS
        no_objecttype  = 1
        internal_error = 2
        OTHERS         = 3.

    CHECK sy-subrc IS INITIAL.

    lo_name ?= lo_name_tmp.

    CALL METHOD lo_name->if_oo_class_incl_naming~get_all_method_includes
      RECEIVING
        methods_w_include           = lt_method
      EXCEPTIONS
        internal_class_not_existing = 1
        OTHERS                      = 2.

    LOOP AT lt_method ASSIGNING <ls_method>.
      lv_obj-object = 'METH'.
      lv_obj-obj_name = <ls_method>-incname.
      INSERT lv_obj INTO gt_object INDEX iv_where.
    ENDLOOP.
  ENDMETHOD.                    "get_method_includes

  METHOD get_report_names.
    SELECT pgmid object obj_name INTO TABLE gt_object
      FROM tadir
      WHERE pgmid  = 'R3TR'
      AND   object = 'PROG'
      AND   devclass IN devclass.                     "#EC CI_SGLSELECT
  ENDMETHOD.                    "get_report_names

  METHOD get_function_names.
    DATA:
      lt_obj     TYPE STANDARD TABLE OF ts_objects,
      lv_obj     TYPE ts_objects,
      lv_fgroup  TYPE rs38l-area,
      lv_program TYPE progname.

    FIELD-SYMBOLS:
      <lv_obj> LIKE LINE OF lt_obj.

    IF NOT funcgrp[] IS INITIAL OR NOT devclass IS INITIAL.

      SELECT pgmid object obj_name INTO TABLE lt_obj
        FROM tadir
        WHERE pgmid  = 'R3TR'
        AND   object = 'FUGR'
        AND   devclass IN devclass
        AND   obj_name IN funcgrp.                    "#EC CI_SGLSELECT

      LOOP AT lt_obj ASSIGNING <lv_obj>.
        lv_fgroup = <lv_obj>-obj_name.
        CLEAR lv_program.

        CALL FUNCTION 'FUNCTION_INCLUDE_INFO'
         IMPORTING
*           FUNCTAB                   =
*           NAMESPACE                 =
           pname                     = lv_program
         CHANGING
*           FUNCNAME                  =
            group                     = lv_fgroup
*           INCLUDE                   =
         EXCEPTIONS
           function_not_exists       = 1
           include_not_exists        = 2
           group_not_exists          = 3
           no_selections             = 4
           no_function_include       = 5
           OTHERS                    = 6
                  .

        CHECK sy-subrc IS INITIAL AND lv_program IS NOT INITIAL.

        lv_obj-obj_name = lv_program.
        APPEND lv_obj TO gt_object.
      ENDLOOP.
    ENDIF.

    IF NOT clazz IS INITIAL OR NOT devclass IS INITIAL.

      SELECT pgmid object obj_name APPENDING TABLE gt_object
        FROM tadir
        WHERE pgmid  = 'R3TR'
        AND   object = 'CLAS'
        AND   devclass IN devclass
        AND   obj_name IN clazz.                      "#EC CI_SGLSELECT

    ENDIF.
  ENDMETHOD.                    "get_function_names

  METHOD get_source_names.

    IF NOT devclass[] IS INITIAL OR NOT clazz[] IS INITIAL OR NOT funcgrp[] IS INITIAL.
      "get_report_names( ).
      get_function_names( ).
    ENDIF.

  ENDMETHOD.                    "get_source_names

  METHOD start.

    get_source_names( ).
    get_includes( ).

    TRY.
        search_abap_source( ).
      CATCH lcx_scan_exceptions.
        RETURN.
    ENDTRY.

    generateindex( ).

    display( ).
  ENDMETHOD.                    "start
  METHOD generateindex.
    DATA: lv_string   TYPE string,
          lt_string   TYPE TABLE OF string,
          lv_funcname TYPE  rs38l_fnam,
          lv_include  TYPE  progname,
          lv_filename TYPE string,
          lv_obj TYPE ts_objects,
          lv_objclass TYPE ts_objects.

*   Generate HTML index file.
    CONCATENATE '<HTML><HEAD><TITLE>' gv_project '</TITLE></HEAD>' INTO lv_string.
    APPEND lv_string TO lt_string.
    APPEND '<FRAMESET cols="20%,80%">' TO lt_string.
    APPEND '<FRAME src="abapdoc_all-frame.html" name="packageFrame">' TO
lt_string.
    APPEND '<FRAME src="abapdoc_main.html" name="classFrame">' TO lt_string.
    APPEND '</FRAMESET></HTML>' TO lt_string.

    CONCATENATE tofolder '\abapdoc_index.html' INTO lv_filename.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename = lv_filename
        filetype = 'ASC'
      TABLES
        data_tab = lt_string.
    IF sy-subrc <> 0.
    ENDIF.

    CLEAR lt_string.

*   Generate HTML index file.
    CONCATENATE '<HTML><HEAD><TITLE>' gv_project '</TITLE></HEAD><BODY><br/><CENTER><B>' INTO lv_string.
    APPEND lv_string TO lt_string.
    APPEND gv_project TO lt_string.
    APPEND '</B></CENTER></BODY></HTML>' TO lt_string.

    CONCATENATE tofolder '\abapdoc_main.html' INTO lv_filename.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename = lv_filename
        filetype = 'ASC'
      TABLES
        data_tab = lt_string.
    IF sy-subrc <> 0.
    ENDIF.

    CLEAR lt_string.

    APPEND '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN""http://www.w3.org/TR/REC-html40/frameset.dtd"><HTML><HEAD>'
TO lt_string.

    IF NOT funcgrp IS INITIAL.
      APPEND '<TITLE>All Function Modules of ' TO lt_string.
      APPEND funcgrp TO lt_string.
      APPEND '</TITLE>' TO lt_string.
    ENDIF.
    "append '<TITLE>All Function Modules of ' to lt_string.

    APPEND '<STYLE>body.allclasses { background-color: #4C4C4C; font-family: arial, sans-serif; font-size: 9pt; letter-spacing: 1px; font-weight: 500; color: white; }' TO lt_string.
    APPEND 'a { font-family: arial, sans-serif; font-size: 9pt;letter-spacing: 1px; font-weight: 500; color: white; }</STYLE>' TO
lt_string.
    APPEND '</HEAD><BODY CLASS="allclasses">' TO lt_string.


    IF NOT funcgrp IS INITIAL.
      APPEND '<FONT CLASS="FrameHeadingFont"><B>' TO lt_string.
      APPEND 'All Function Modules of ' TO lt_string.
      APPEND funcgrp+3 TO lt_string.
      APPEND '</B></FONT><BR/><BR/><BR/>' TO lt_string.
    ELSEIF NOT devclass IS INITIAL.
      APPEND '<FONT CLASS="FrameHeadingFont"><B>' TO lt_string.
      APPEND 'All Function Modules and Classes of package ' TO lt_string.
      APPEND devclass+3 TO lt_string.
      APPEND '</B></FONT><BR/><BR/><BR/>' TO lt_string.
    ENDIF.

    LOOP AT gt_object INTO lv_obj.

      IF lv_obj-object = 'METH'.

        CALL FUNCTION 'SEO_METHOD_GET_NAME_BY_INCLUDE'
          EXPORTING
            progname = lv_obj-obj_name
          IMPORTING
            mtdkey   = gt_mtdkey.

        filename = lv_obj-obj_name.
        TRANSLATE filename USING texttr.
        CONCATENATE '- <A HREF="abapdoc_' filename '.html" TARGET="classFrame">' gt_mtdkey-cpdname '</A><br/>' INTO lv_string.
        APPEND lv_string TO lt_string.
        generateinfomethpage( iv_incl = lv_obj-obj_name iv_class = gt_mtdkey-clsname iv_meth = gt_mtdkey-cpdname ).
      ELSEIF lv_obj-object = 'CLAS'..
        APPEND '<BR/><FONT CLASS="FrameHeadingFont"><B>' TO lt_string.
        APPEND 'Class '  TO lt_string.
        filename = lv_obj-obj_name.
        TRANSLATE filename USING texttr.
        CONCATENATE '<A HREF="abapdoc_' filename '.html" TARGET="classFrame">' lv_obj-obj_name '</A><br/>' INTO lv_string.
        APPEND lv_string TO lt_string.
        APPEND '</B></FONT><BR/>' TO lt_string.
        generateinfoclasspage( iv_class = lv_obj-obj_name ).
        lv_objclass = lv_obj.
      ELSE.
        lv_include = lv_obj-obj_name.
        CLEAR lv_funcname.
        CALL FUNCTION 'FUNCTION_INCLUDE_INFO'
          CHANGING
            funcname            = lv_funcname
            include             = lv_include
          EXCEPTIONS
            function_not_exists = 1
            include_not_exists  = 2
            group_not_exists    = 3
            no_selections       = 4
            no_function_include = 5
            OTHERS              = 6.
        IF sy-subrc = 0 AND lv_funcname IS NOT INITIAL.
          filename = lv_funcname.
          TRANSLATE filename USING texttr.
          CONCATENATE '<A HREF="abapdoc_' filename '.html" TARGET="classFrame">' lv_funcname '</A><br/>' INTO lv_string.
          APPEND lv_string TO lt_string.
          generateinfopage( iv_fm = lv_funcname iv_report = lv_include ).
        ENDIF.

      ENDIF.

    ENDLOOP.

    APPEND '</BODY></HTML>' TO lt_string.

    CONCATENATE tofolder '\abapdoc_all-frame.html' INTO lv_filename.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename = lv_filename
        filetype = 'ASC'
      TABLES
        data_tab = lt_string.
    IF sy-subrc <> 0.
    ENDIF.


  ENDMETHOD.                    "generateindex
  METHOD generateinfomethpage.
    DATA: filename            TYPE string,
          lv_string           TYPE string,
          lt_string           TYPE TABLE OF string,
          lv_method           TYPE  vseomethod,
          lt_parameters       TYPE  seos_parameters_r,
          lv_parameter        TYPE  seos_parameter_r,
          lt_exceps           TYPE  seos_exceptions_r,
          lv_key              TYPE  seocpdkey.

    lv_key-cpdname = iv_meth.
    lv_key-clsname = iv_class.

    CALL FUNCTION 'SEO_COMPONENT_SIGNATURE_GET'
      EXPORTING
        cpdkey             = lv_key
        version            = seoc_version_active
*       STATE              = 1
     IMPORTING
       PARAMETERS         = lt_parameters
       exceps             = lt_exceps
       method             = lv_method
*       EVENT              =
     EXCEPTIONS
       not_existing       = 1
       is_type            = 2
       is_attribute       = 3
       OTHERS             = 4
              .
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    APPEND '<HTML><HEAD><TITLE>ABAPdoc</TITLE></HEAD>' TO lt_string.
    APPEND '<STYLE> body {font-family: arial, sans-serif; font-size: 9pt;} table{ border-collapse: collapse; } td, th{ border: 1px solid #CCCCCC; font-family: arial, sans-serif; font-size: 9pt; } tr.top { background-color: #EAFDFF; } </STYLE>' TO
lt_string.

    CONCATENATE '<BODY><table width="100%" bgcolor="#EEEEFF"><tr><td>Method: <B>' iv_meth '</B></td></tr></table><BR/>' INTO lv_string.
    APPEND lv_string TO lt_string.

    CONCATENATE '<BR/>Description: <b>' lv_method-descript '</B><BR/>' INTO lv_string SEPARATED BY space.
    APPEND lv_string TO lt_string.
    IF lv_method-exposure = '0'.
      APPEND 'Visibility: <b>Private </B><BR/>' TO lt_string.
    ELSEIF lv_method-exposure = '1'.
      APPEND 'Visibility: <b>Protected </B><BR/>' TO lt_string.
    ELSEIF lv_method-exposure = '2'.
      APPEND 'Visibility: <b>Public </B><BR/>' TO lt_string.
    ENDIF.
    IF lv_method-mtddecltyp = '0'.
      APPEND 'Method declaration level: <b>Instance method </B><BR/>' TO lt_string.
    ELSEIF lv_method-mtddecltyp = '1'.
      APPEND 'Method declaration level: <b>Static method </B><BR/>' TO lt_string.
    ENDIF.

    APPEND '<BR/><B>Import Parameters:</B><BR/>' TO lt_string.
    APPEND '<TABLE width="100%" border=0><TR class="top"><TD width="20%">Parameter</TD><td>Type</td><TD width="5%">Pass by Value</TD><TD>Optional</TD><TD width="5%">Typing Method</TD>' TO lt_string.
    APPEND '<TD width="5%">Associated Type</TD><TD width="5%">Default value</TD><TD width="20%">Description</TD></TR>' TO lt_string.
    LOOP AT lt_parameters INTO lv_parameter.
      APPEND '<TR><TD>' TO lt_string.
      APPEND lv_parameter-sconame TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parameterdecltype( is_type = lv_parameter-pardecltyp ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      IF NOT lv_parameter-parpasstyp = '1'.
        lv_string = 'X'.
        APPEND lv_string TO lt_string.
      ENDIF.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_parameter-paroptionl TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertyptype( is_type = lv_parameter-typtype  ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_parameter-type TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_parameter-parvalue TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_parameter-descript TO lt_string.
      APPEND '</TD></TR>' TO lt_string.
    ENDLOOP.
    APPEND '</TABLE>' TO lt_string.

*   Report top comment
    DATA: lv_com_results    TYPE ts_comment_tab.
    APPEND '<BR/><B>Method documentation header: </B><BR/>' TO lt_string.
    LOOP AT gt_results INTO lv_com_results WHERE report = iv_incl.
      APPEND lv_com_results-source+1(200) TO lt_string.
      APPEND '<BR/>' TO lt_string.
    ENDLOOP.

    APPEND '</HTML>' TO lt_string.

    CONCATENATE tofolder '\abapdoc_' iv_incl '.html' INTO filename.
    TRANSLATE filename USING texttr.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename = filename
        filetype = 'ASC'
      TABLES
        data_tab = lt_string.
    IF sy-subrc <> 0.
    ENDIF.

  ENDMETHOD.                    "generateinfomethpage
  METHOD generateinfoclasspage.
    DATA: filename            TYPE string,
          lv_string           TYPE string,
          lt_string           TYPE TABLE OF string,
          lv_method           TYPE  vseomethod,
          lt_parameters       TYPE  seos_parameters_r,
          lv_parameter        TYPE  seos_parameter_r,
          lt_exceps           TYPE  seos_exceptions_r,
          lv_key              TYPE  seoclskey,
          lv_class            TYPE  vseoclass,
          lt_attributes       TYPE  seoo_attributes_r,
          lv_attribute        TYPE  seoo_attribute_r.

    lv_key-clsname = iv_class.

    CALL FUNCTION 'SEO_CLASS_TYPEINFO_GET'
      EXPORTING
        clskey                              = lv_key
        version                             = seoc_version_active
*       STATE                               = '1'
        with_descriptions                   = seox_true
*       RESOLVE_EVENTHANDLER_TYPEINFO       = SEOX_FALSE
*       WITH_MASTER_LANGUAGE                = SEOX_FALSE
*       WITH_ENHANCEMENTS                   = SEOX_FALSE
*       READ_ACTIVE_ENHA                    = SEOX_FALSE
*       ENHA_ACTION                         = SEOX_FALSE
*       IGNORE_SWITCHES                     = 'X'
      IMPORTING
       class                               = lv_class
       attributes                          = lt_attributes
*       METHODS                             =
*       EVENTS                              =
*       TYPES                               =
*       PARAMETERS                          =
*       EXCEPS                              =
*       IMPLEMENTINGS                       =
*       INHERITANCE                         =
*       REDEFINITIONS                       =
*       IMPL_DETAILS                        =
*       FRIENDSHIPS                         =
*       TYPEPUSAGES                         =
*       CLSDEFERRDS                         =
*       INTDEFERRDS                         =
*       EXPLORE_INHERITANCE                 =
*       EXPLORE_IMPLEMENTINGS               =
*       ALIASES                             =
*       ENHANCEMENT_METHODS                 =
*       ENHANCEMENT_ATTRIBUTES              =
*       ENHANCEMENT_EVENTS                  =
*       ENHANCEMENT_IMPLEMENTINGS           =
*     EXCEPTIONS
*       NOT_EXISTING                        = 1
*       IS_INTERFACE                        = 2
*       MODEL_ONLY                          = 3
*       OTHERS                              = 4
              .
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


    APPEND '<HTML><HEAD><TITLE>ABAPdoc</TITLE></HEAD>' TO lt_string.
    APPEND '<STYLE> body {font-family: arial, sans-serif; font-size: 9pt;} table{ border-collapse: collapse; } td, th{ border: 1px solid #CCCCCC; font-family: arial, sans-serif; font-size: 9pt; } tr.top { background-color: #EAFDFF; } </STYLE>' TO
lt_string.

    CONCATENATE '<BODY><table width="100%" bgcolor="#EEEEFF"><tr><td>Class: <B>' lv_class-clsname '</B></td></tr></table><BR/>' INTO lv_string.
    APPEND lv_string TO lt_string.

    CONCATENATE '<BR/>Description: <b>' lv_class-descript '</B><BR/>' INTO lv_string SEPARATED BY space.
    APPEND lv_string TO lt_string.
    IF lv_class-exposure = '0'.
      APPEND 'Visibility: <b>Private </B><BR/>' TO lt_string.
    ELSEIF lv_class-exposure = '1'.
      APPEND 'Visibility: <b>Protected </B><BR/>' TO lt_string.
    ELSEIF lv_class-exposure = '2'.
      APPEND 'Visibility: <b>Public </B><BR/>' TO lt_string.
    ENDIF.

    APPEND '<BR/><B>Attributes:</B><BR/>' TO lt_string.
    APPEND '<TABLE width="100%" border=0><TR class="top"><TD width="20%">Attribute</TD><td>Level</td><TD width="20%">Visibility</TD><TD>Read-Only</TD><TD width="5%">Typing</TD>' TO lt_string.
    APPEND '<TD width="5%">Associated Type</TD><TD width="5%">Description</TD><TD width="20%">Initial value</TD></TR>' TO lt_string.
    LOOP AT lt_attributes INTO lv_attribute.
      APPEND '<TR><TD>' TO lt_string.
      APPEND lv_attribute-cmpname TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_attdecltype( is_type = lv_attribute-attdecltyp ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_attribute-attexpvirt TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_attribute-attrdonly TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertyptype( is_type = lv_attribute-typtype  ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_attribute-type TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_attribute-descript TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_attribute-attvalue TO lt_string.
      APPEND '</TD></TR>' TO lt_string.
    ENDLOOP.
    APPEND '</TABLE>' TO lt_string.

    APPEND '</HTML>' TO lt_string.

    CONCATENATE tofolder '\abapdoc_' iv_class '.html' INTO filename.

    TRANSLATE filename USING texttr.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename = filename
        filetype = 'ASC'
      TABLES
        data_tab = lt_string.
    IF sy-subrc <> 0.
    ENDIF.

  ENDMETHOD.                    "generateinfoclasspage
  METHOD generateinfopage.
    DATA: filename            TYPE string,
          lv_string           TYPE string,
          lt_string           TYPE TABLE OF string,
          lv_funcname         TYPE  rs38l_fnam,
          lv_include          TYPE  progname,
          lv_remote_call      TYPE rs38l-remote,
          lv_update_task      TYPE rs38l-utask,
          lv_exception_list   TYPE rsexc,
          lv_export_parameter TYPE rsexp,
          lv_import_parameter TYPE rsimp,
          lv_changing_parameter TYPE rscha,
          lv_tables_parameter TYPE rstbl,
          lv_p_docu           TYPE funct,
          lt_exception_list   TYPE TABLE OF rsexc,
          lt_export_parameter TYPE TABLE OF rsexp,
          lt_import_parameter TYPE TABLE OF rsimp,
          lt_changing_parameter TYPE TABLE OF rscha,
          lt_tables_parameter TYPE TABLE OF rstbl,
          lt_p_docu           TYPE TABLE OF funct,
          lv_stext            TYPE rs38l_ftxt.

    lv_funcname = iv_fm.

    CALL FUNCTION 'FUNCTION_IMPORT_DOKU'
      EXPORTING
        funcname                 = lv_funcname
        language                 = sy-langu
     IMPORTING
*       GLOBAL_FLAG              =
        remote_call              = lv_remote_call
        update_task              = lv_update_task
        short_text               = lv_stext
*       FREEDATE                 =
*       EXCEPTION_CLASS          =
      TABLES
        dokumentation            = lt_p_docu
        exception_list           = lt_exception_list
        export_parameter         = lt_export_parameter
        import_parameter         = lt_import_parameter
        changing_parameter       = lt_changing_parameter
        tables_parameter         = lt_tables_parameter
     EXCEPTIONS
       error_message            = 1
       function_not_found       = 2
       invalid_name             = 3
       OTHERS                   = 4
              .

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    APPEND '<HTML><HEAD><TITLE>ABAPdoc</TITLE></HEAD>' TO lt_string.
    APPEND '<STYLE> body {font-family: arial, sans-serif; font-size: 9pt;} table{ border-collapse: collapse; } td, th{ border: 1px solid #CCCCCC; font-family: arial, sans-serif; font-size: 9pt; } tr.top { background-color: #EAFDFF; } </STYLE>' TO
lt_string.

    CONCATENATE '<BODY><table width="100%" bgcolor="#EEEEFF"><tr><td>Function Module: <B>' iv_fm '</B></td></tr></table><BR/>' INTO lv_string.
    APPEND lv_string TO lt_string.

    CONCATENATE 'Description:' lv_stext '</B><BR/>' INTO lv_string
SEPARATED BY space.
    APPEND lv_string TO lt_string.

    IF lv_remote_call = 'R'.
      APPEND 'This is a remote function module<BR/>' TO lt_string.
    ENDIF.

    IF lv_update_task = 'X'.
      APPEND 'This is a update task<BR/>' TO lt_string.
    ENDIF.

    APPEND '<BR/><B>Import Parameters:</B><BR/>' TO lt_string.
    APPEND '<TABLE width="100%" border=0><TR class="top"><TD width="20%">Parameter Name</TD><td>Typing</td><TD width="20%">Associated Type</TD><TD>Default value</TD><TD width="5%">Optional</TD>' TO lt_string.
    APPEND '<TD width="5%">Pass Value</TD><TD width="20%">Short text</TD></TR>' TO lt_string.
    LOOP AT lt_import_parameter INTO lv_import_parameter.
      APPEND '<TR><TD>' TO lt_string.
      APPEND lv_import_parameter-parameter TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertype( is_iparameter = lv_import_parameter ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertypename( is_iparameter =
lv_import_parameter ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_import_parameter-default TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_import_parameter-optional TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      IF lv_import_parameter-reference = ''.
        APPEND 'Yes' TO lt_string.
      ENDIF.
      APPEND '</TD><TD>' TO lt_string.
      READ TABLE lt_p_docu INTO lv_p_docu WITH KEY parameter =
lv_import_parameter-parameter.
      IF sy-subrc = 0.
        APPEND lv_p_docu-stext TO lt_string.
      ENDIF.
      APPEND '</TD></TR>' TO lt_string.
    ENDLOOP.
    APPEND '</TABLE>' TO lt_string.

*   Export Parameters
    APPEND '<BR/><B>Export Parameters:</B><BR/>' TO lt_string.
    APPEND '<TABLE width="100%" border=0><TR class="top"><TD width="30%">Parameter Name</TD><TD width="10%">Typing</TD><TD width="30%">Associated Type</TD><TD width="10%">Pass Value</TD><TD width="20%">Short text</TD></TR>' TO lt_string.
    LOOP AT lt_export_parameter INTO lv_export_parameter.
      APPEND '<TR><TD>' TO lt_string.
      APPEND lv_export_parameter-parameter TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertype( is_eparameter = lv_export_parameter ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertypename( is_eparameter =
lv_export_parameter ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      IF lv_export_parameter-reference = ''.
        APPEND 'Yes' TO lt_string.
      ENDIF.
      APPEND '</TD><TD>' TO lt_string.
      READ TABLE lt_p_docu INTO lv_p_docu WITH KEY parameter =
lv_export_parameter-parameter.
      IF sy-subrc = 0.
        APPEND lv_p_docu-stext TO lt_string.
      ENDIF.
      APPEND '</TD></TR>' TO lt_string.
    ENDLOOP.
    APPEND '</TABLE>' TO lt_string.

*   Changing Parameters
    APPEND '<BR/><B>Changing Parameters:</B><BR/>' TO lt_string.
    APPEND '<TABLE width="100%" border=0><TR class="top"><TD width="30%">Parameter Name</TD><TD width="10%">Typing</TD><TD width="30%">Associated Type</TD><TD>Default value</TD><TD>Optional</TD><TD>Pass Value</TD><TD width="20%">Short text</TD></TR>'
    TO lt_string.
    LOOP AT lt_changing_parameter INTO lv_changing_parameter.
      APPEND '<TR><TD>' TO lt_string.
      APPEND lv_changing_parameter-parameter TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertype( is_cparameter = lv_changing_parameter ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertypename( is_cparameter =
lv_changing_parameter ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_changing_parameter-default TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_changing_parameter-optional TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      IF lv_changing_parameter-reference = ''.
        APPEND 'Yes' TO lt_string.
      ENDIF.
      APPEND '</TD><TD>' TO lt_string.
      READ TABLE lt_p_docu INTO lv_p_docu WITH KEY parameter =
lv_changing_parameter-parameter.
      IF sy-subrc = 0.
        APPEND lv_p_docu-stext TO lt_string.
      ENDIF.
      APPEND '</TD></TR>' TO lt_string.
    ENDLOOP.
    APPEND '</TABLE>' TO lt_string.

*   Tables
    APPEND '<BR/><B>Table Parameters:</B><BR/>' TO lt_string.
    APPEND '<TABLE width="100%" border=0><TR class="top"><TD width="30%">Parameter Name</TD><TD width="10%">Typing</TD><TD width="30%">Associated Type</TD><TD>Optional</TD><TD width="20%">Short text</TD></TR>'
    TO lt_string.
    LOOP AT lt_tables_parameter INTO lv_tables_parameter.
      APPEND '<TR><TD>' TO lt_string.
      APPEND lv_tables_parameter-parameter TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertype( is_tparameter = lv_tables_parameter ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      lv_string = get_parametertypename( is_tparameter =
lv_tables_parameter ).
      APPEND lv_string TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      APPEND lv_tables_parameter-optional TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      READ TABLE lt_p_docu INTO lv_p_docu WITH KEY parameter =
lv_tables_parameter-parameter.
      IF sy-subrc = 0.
        APPEND lv_p_docu-stext TO lt_string.
      ENDIF.
      APPEND '</TD></TR>' TO lt_string.
    ENDLOOP.
    APPEND '</TABLE>' TO lt_string.

*   Tables
    APPEND '<BR/><B>Exceptions:</B><BR/>' TO lt_string.
    APPEND '<TABLE width="100%" border=0><TR class="top"><TD width="30%">Exception</TD><TD width="20%">Short text</TD></TR>'
    TO lt_string.
    LOOP AT lt_exception_list INTO lv_exception_list.
      APPEND '<TR><TD>' TO lt_string.
      APPEND lv_exception_list-exception TO lt_string.
      APPEND '</TD><TD>' TO lt_string.
      READ TABLE lt_p_docu INTO lv_p_docu WITH KEY parameter =
lv_exception_list-exception.
      IF sy-subrc = 0.
        APPEND lv_p_docu-stext TO lt_string.
      ENDIF.
      APPEND '</TD></TR>' TO lt_string.
    ENDLOOP.
    APPEND '</TABLE>' TO lt_string.

*   Report top comment
    DATA: lv_com_results    TYPE ts_comment_tab.
    APPEND '<BR/><B>Function module comment header:</B><BR/>' TO lt_string.
    LOOP AT gt_results INTO lv_com_results WHERE report = iv_report.
      APPEND lv_com_results-source TO lt_string.
      APPEND '<BR/>' TO lt_string.
    ENDLOOP.
    APPEND '</TABLE>' TO lt_string.

    APPEND '</HTML>' TO lt_string.


    CONCATENATE tofolder '\abapdoc_' iv_fm '.html' INTO filename.
    TRANSLATE filename USING texttr.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename = filename
        filetype = 'ASC'
      TABLES
        data_tab = lt_string.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.                    "generateindex
  METHOD get_parametertype.
    DATA ls_iparameter TYPE rsimp.
    IF NOT is_eparameter IS INITIAL.
      MOVE-CORRESPONDING is_eparameter TO ls_iparameter.
    ELSEIF NOT is_iparameter IS INITIAL.
      MOVE-CORRESPONDING is_iparameter TO ls_iparameter.
    ELSEIF NOT is_cparameter IS INITIAL.
      MOVE-CORRESPONDING is_cparameter TO ls_iparameter.
    ELSEIF NOT is_tparameter IS INITIAL.
      MOVE-CORRESPONDING is_tparameter TO ls_iparameter.
    ENDIF.
    IF ls_iparameter-types = 'X' OR ls_iparameter-reference = 'X'.
      rl_type = 'TYPE'.
      RETURN.
    ENDIF.
    IF NOT ls_iparameter-dbfield IS INITIAL.
      rl_type = 'LIKE'.
      RETURN.
    ENDIF.
    rl_type = 'TYPE'.
  ENDMETHOD.                    "get_parametertype
  METHOD get_parametertypename.
    DATA ls_iparameter TYPE rsimp.
    IF NOT is_eparameter IS INITIAL.
      MOVE-CORRESPONDING is_eparameter TO ls_iparameter.
    ELSEIF NOT is_iparameter IS INITIAL.
      MOVE-CORRESPONDING is_iparameter TO ls_iparameter.
    ELSEIF NOT is_cparameter IS INITIAL.
      MOVE-CORRESPONDING is_cparameter TO ls_iparameter.
    ELSEIF NOT is_tparameter IS INITIAL.
      rl_type = is_tparameter-dbstruct.
      RETURN.
    ENDIF.

    IF NOT ls_iparameter-typ IS INITIAL.
      rl_type = ls_iparameter-typ.
    ELSEIF NOT ls_iparameter-dbfield IS INITIAL.
      rl_type = ls_iparameter-dbfield.
    ENDIF.
  ENDMETHOD.                    "get_parametertype
  METHOD get_parameterdecltype.
    IF is_type = '0'.
      rv_type = 'Importing'.
    ELSEIF is_type = '1'.
      rv_type = 'Exporting'.
    ELSEIF is_type = '2'.
      rv_type = 'Changing'.
    ELSEIF is_type = '3'.
      rv_type = 'Returning'.
    ENDIF.
  ENDMETHOD.                    "get_parameterdecltype
  METHOD get_attdecltype.
    IF is_type = '0'.
      rv_type = 'Static Atribute'.
    ELSEIF is_type = '1'.
      rv_type = 'Instance Attribute'.
    ENDIF.
  ENDMETHOD.                    "get_attdecltype
  METHOD get_parametertyptype.
    IF is_type = '0'.
      rv_type = 'Like'.
    ELSEIF is_type = '1'.
      rv_type = 'Type'.
    ELSEIF is_type = '3'.
      rv_type = 'Type Ref To'.
    ENDIF.
  ENDMETHOD.                    "get_parametertyptype
ENDCLASS.                    "lcl_source_scan IMPLEMENTATION

INITIALIZATION.
  CREATE OBJECT lo_sscan.

  a11 = 'Function Module Selection'(a11).
  a12 = 'Class Selection'(a12).
  a13 = 'Package Selection'(a12).
  a20 = 'Generate ABAPdoc settings'(a20).
  a21 = 'Project Name'(a21).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR funcgrp-low.
  lo_sscan->f4_function_group( 'FUNCGRP-LOW' ).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR funcgrp-high.
  lo_sscan->f4_function_group( 'FUNCGRP-HIGH' ).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR tofolder.
  tofolder_string = tofolder.
  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title         = 'Select a folder'
      initial_folder       = tofolder_string
    CHANGING
      selected_folder      = tofolder_string
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc = 0.
    tofolder = tofolder_string.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR clazz-low.
  lo_sscan->f4_class( CHANGING cv_class_name = clazz-low ).


START-OF-SELECTION.

  gv_project = project.
  lo_sscan->start( ).