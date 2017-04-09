REPORT zsi_get_app_transportable.

DATA: lv_application TYPE  cmst_application VALUE 'SI'.

DATA :  ls_app_prf       TYPE cmst_lo_app_prf,
        lt_e071          TYPE tr_objects,
        ls_e071          TYPE e071,
        ls_request       TYPE trwbo_request_header,
        lv_pos           TYPE ddposition VALUE 0,
        lv_program       TYPE progname,
        lv_function_pool
          TYPE rs38l_area,
        lt_selscr        TYPE cmst_lo_scr_map_tab,
        ls_selscr        TYPE cmst_lo_scr_map.

CONSTANTS : lc_cust_namespace TYPE namespace VALUE '/0CUST/',
            lc_sap_namespace  TYPE namespace VALUE '/0SAP/'.
CONSTANTS:

  gc_pgmid_r3tr  TYPE pgmid      VALUE 'R3TR',
  gc_object_prog TYPE cmst_param_value VALUE 'PROG',
  gc_object_fugr TYPE trobjtype  VALUE 'FUGR',
  gc_object_ttyp TYPE trobjtype  VALUE 'TTYP',
  gc_object_enqu TYPE trobjtype  VALUE 'ENQU',
  gc_object_tabl TYPE trobjtype  VALUE 'TABL',
  gc_object_doma TYPE trobjtype  VALUE 'DOMA',
  gc_object_dtel TYPE trobjtype  VALUE 'DTEL',
  gc_object_devc TYPE trobjtype  VALUE 'DEVC',
  gc_type        TYPE e071-object VALUE 'Type',
  gc_name        TYPE e071-obj_name VALUE 'Name'.

DATA : lv_repname     TYPE progname,
       lv_namespace   TYPE namespace,
       lv_flag        TYPE trparflag,
       lv_change_devc TYPE boolean VALUE space.

CLEAR ls_app_prf.
CALL FUNCTION 'CMS_LO_APPL_ATTRIBUTES_GET'
  EXPORTING
    iv_application     = lv_application
  IMPORTING
    es_appl_attributes = ls_app_prf.

IF ls_app_prf IS NOT INITIAL.

  CALL FUNCTION 'CMS_LO_COLLECT_APP_PRF_OBJECTS'
    EXPORTING
      is_app_prf       = ls_app_prf
    CHANGING
      ct_e071          = lt_e071
      cv_no_of_objects = lv_pos.

* Profile qualifier objects
  CALL FUNCTION 'CMS_LO_COLLECT_APP_QUAL_OBJ'
    EXPORTING
      iv_application   = lv_application
    CHANGING
      ct_e071          = lt_e071
      cv_no_of_objects = lv_pos.

* Status objects
  CALL FUNCTION 'CMS_LO_COLLECT_APP_STATUS_OBJ'
    EXPORTING
      iv_application   = lv_application
    CHANGING
      ct_e071          = lt_e071
      cv_no_of_objects = lv_pos.
ENDIF.

* Application objects
* TABL types
ls_e071-pgmid    = gc_pgmid_r3tr.
ls_e071-object   = gc_object_tabl.
* Header intf str
IF ls_app_prf-intf_str_h IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-intf_str_h.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* Item intf str
IF ls_app_prf-intf_str_i IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-intf_str_i.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* Exec str
IF ls_app_prf-exec_str IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-exec_str.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* Index str
IF ls_app_prf-indx_str IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-indx_str.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* BSP Index str
IF ls_app_prf-bsp_indx_str IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-bsp_indx_str.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* Index table
IF ls_app_prf-indx_table IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-indx_table.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* BSP Header str
IF ls_app_prf-bsp_str_h IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-bsp_str_h.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* BSP Item str
IF ls_app_prf-bsp_str_i IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-bsp_str_i.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* Enq str
IF ls_app_prf-enq_str IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-enq_str.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* BW str
IF ls_app_prf-bw_str IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-bw_str.
  INSERT ls_e071 INTO TABLE lt_e071.

* BW_C str
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  CONCATENATE ls_app_prf-bw_str
              '_C'
              INTO ls_e071-obj_name.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* TTYP types
CLEAR ls_e071.
ls_e071-pgmid    = gc_pgmid_r3tr.
ls_e071-object   = gc_object_ttyp.

IF ls_app_prf-intf_tty_h IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-intf_tty_h.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

IF ls_app_prf-intf_tty_i IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-intf_tty_i.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

IF ls_app_prf-indx_tty IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-indx_tty.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* BSP Index str
IF ls_app_prf-bsp_indx_tty IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-bsp_indx_tty.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

IF ls_app_prf-exec_tty IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-exec_tty.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

IF ls_app_prf-bsp_tty_h IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-bsp_tty_h.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

IF ls_app_prf-bsp_tty_i IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-bsp_tty_i.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

IF ls_app_prf-bw_tty IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-bw_tty.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.
IF ls_app_prf-enq_str IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  CONCATENATE ls_app_prf-enq_str'_TAB' INTO ls_e071-obj_name.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* ENQU types
CLEAR ls_e071.
ls_e071-pgmid    = gc_pgmid_r3tr.
ls_e071-object   = gc_object_enqu.

IF ls_app_prf-enq_obj IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = ls_app_prf-enq_obj.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* Generated routines
CLEAR ls_e071.
ls_e071-pgmid    = gc_pgmid_r3tr.
ls_e071-object   = gc_object_prog.

CALL FUNCTION 'CMS_LO_MAPPING_PROGRAM_GET'
  EXPORTING
    iv_application = lv_application
  IMPORTING
    ev_program     = lv_program.
IF lv_program IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = lv_program.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* Function groups
CLEAR ls_e071.
ls_e071-pgmid    = gc_pgmid_r3tr.
ls_e071-object   = gc_object_fugr.

CALL FUNCTION 'CMS_LO_APPL_FUNCPOOL_NAME_GET'
  EXPORTING
    iv_application     = lv_application
    iv_appl_package    = ls_app_prf-appl_package
  IMPORTING
    ev_functionpool    = lv_function_pool
  EXCEPTIONS
    namespace_mismatch = 1
    OTHERS             = 2.
IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
IF lv_function_pool IS NOT INITIAL.
  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-obj_name = lv_function_pool.
  INSERT ls_e071 INTO TABLE lt_e071.
ENDIF.

* Selection Screens
CALL FUNCTION 'CMS_LO_APPL_SELSCR_GET_CB'
  EXPORTING
    iv_application = lv_application
  IMPORTING
    et_selscr      = lt_selscr.

LOOP AT lt_selscr INTO ls_selscr.
  CALL FUNCTION 'CMS_LO_SELECTION_REP_NAME_GET'
    EXPORTING
      iv_application = lv_application
      iv_screen_id   = ls_selscr-screen_id
    IMPORTING
      ev_repname     = lv_repname
      ev_namespace   = lv_namespace.

  lv_pos = lv_pos + 1.
  ls_e071-as4pos = lv_pos.
  ls_e071-pgmid  = gc_pgmid_r3tr.
  ls_e071-object = gc_object_prog.
  ls_e071-obj_name = lv_repname.
  INSERT ls_e071 INTO TABLE lt_e071.

  CLEAR : lv_flag, lv_change_devc.
  CALL FUNCTION 'TR_CHECK_OBJECT_LOCAL'
    EXPORTING
      iv_e071_pgmid         = ls_e071-pgmid
      iv_e071_object        = ls_e071-object
      iv_e071_obj_name      = ls_e071-obj_name
    IMPORTING
      ev_object_local       = lv_flag
    EXCEPTIONS
      tadir_entry_not_found = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
    lv_change_devc = 'X'.
  ELSE.
    IF sy-subrc EQ 0 AND
      lv_flag NE space.
      lv_change_devc = 'X'.
    ENDIF.
  ENDIF.
ENDLOOP.

WRITE: / gc_type, gc_name COLOR COL_NEGATIVE.
LOOP AT lt_e071 ASSIGNING FIELD-SYMBOL(<item>).
  WRITE: / <item>-object UNDER gc_type COLOR COL_TOTAL, <item>-obj_name UNDER gc_name COLOR COL_GROUP.
ENDLOOP.