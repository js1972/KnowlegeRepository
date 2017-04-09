*&---------------------------------------------------------------------*
*& Report  ZFILL_TADIR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZFILL_TADIR.

INCLUDE zfill_data.
INCLUDE zfill_f01.
INCLUDE zfill_dir.
START-OF-SELECTION.
  PERFORM fill_trlist.
  PERFORM fill_data.
  PERFORM fill_tadir.

*&---------------------------------------------------------------------*
*&  Include           ZFILL_DATA
*&---------------------------------------------------------------------*
DATA: lt_trkorr TYPE TABLE OF scwbtrkorr,
      ls_trkorr LIKE LINE OF lt_trkorr,
      lt_trlist TYPE string_table,
      lt_e070 TYPE STANDARD TABLE OF SCWB_E070,
      lt_e070t TYPE STANDARD TABLE OF SCWB_E07T,
      lt_e070c TYPE STANDARD TABLE OF SCWB_E070C,
      lt_e071  TYPE STANDARD TABLE OF SCWB_E071,
      lt_e071k TYPE STANDARD TABLE OF SCWB_E071K,
      lt_e070a TYPE STANDARD TABLE OF SCWB_E070A,
      lt_tadir TYPE STANDARD TABLE OF ztadir,
      ls_tadir TYPE ztadir.

FIELD-SYMBOLS: <e071> LIKE LINE OF lt_e071,
               <e070> LIKE LINE OF lt_e070,
               <e070t> LIKE LINE OF lt_e070t.


*&---------------------------------------------------------------------*
*&  Include           ZFILL_F01
*&---------------------------------------------------------------------*

FORM add_tr USING name TYPE char12.
   DATA: lt_e070 TYPE STANDARD TABLE OF e070.

   FIELD-SYMBOLS:<line> TYPE e070.
   SELECT trkorr as4user INTO CORRESPONDING FIELDS OF TABLE lt_e070 FROM e070 WHERE as4user = name AND tarsystem = '/CRM_INF/'.

   LOOP AT lt_e070 ASSIGNING <line>.
      APPEND <line>-trkorr TO lt_trlist.
   ENDLOOP.
ENDFORM.

FORM fill_trlist.
   PERFORM add_tr USING 'WANGJER'.
ENDFORM.

FORM fill_data.

DATA: lv_tr TYPE string.

LOOP AT lt_trlist INTO lv_tr.
      ls_trkorr-trkorr  = lv_tr.
      ls_trkorr-srcsyst = space.
      APPEND ls_trkorr TO lt_trkorr.
      "read remote
      ls_trkorr-srcsyst = lv_tr(3).   "try with first 3 chars as system name
      APPEND ls_trkorr TO lt_trkorr.
ENDLOOP.

CALL FUNCTION 'SCWB_GET_COMPL_REQUESTS_REM_40'
      EXPORTING
        iv_merge_object_lists = ' '
      TABLES
        it_request_numbers    = lt_trkorr
        et_e070               = lt_e070
        et_e07t               = lt_e070t
        et_e070c              = lt_e070c
        et_e071               = lt_e071
        "et_e071k              = lt_e071k
        et_e070a              = lt_e070a   "time stamp + corr request
      EXCEPTIONS
        error_message         = 0.   "suppres

SORT lt_e070 BY trkorr.

LOOP AT lt_e071 ASSIGNING <e071> WHERE object <> 'CORR' AND object <> 'AVAS' AND object <> 'PDWS' AND object <> 'DLCS' AND object <> 'CDAT'
   AND object <> 'TDAT' AND object <> 'SMIM' AND object <> 'RELE' AND object <> 'MERG' AND object <> 'CLSD' AND object <> 'CPRO'
   AND object <> 'CPUB' AND object <> 'CPRI' AND object <> 'DOCU' AND object <> 'SICF' AND object <> 'MESS' AND object <> 'PIFA'
   AND object <> 'SHI6' AND object <> 'SHI3' AND object <> 'TABU' AND object <> 'VDAT'.

   CLEAR: ls_tadir.
   IF <e071>-object <> 'METH'.
       ls_tadir-obj_name = <e071>-obj_name.
   ELSE.
       PERFORM get_tech_name USING <e071>-obj_name CHANGING ls_tadir.
   ENDIF.
   READ TABLE lt_tadir WITH KEY obj_name = ls_tadir-obj_name TRANSPORTING NO FIELDS.
   CHECK sy-subrc = 4.
   APPEND ls_tadir TO lt_tadir.
ENDLOOP.

ENDFORM.

FORM get_tech_name USING name TYPE char120 CHANGING entry TYPE ztadir.
   DATA: lt_temp TYPE string_table.
   SPLIT name AT space INTO TABLE lt_temp.
   READ TABLE lt_temp INTO entry-obj_name INDEX 1.
ENDFORM.

*&---------------------------------------------------------------------*
*&  Include           ZFILL_DIR
*&---------------------------------------------------------------------*

FORM fill_tadir.
DATA: lt_g_tadir TYPE STANDARD TABLE OF tadir,
      lv_line TYPE i,
      ls_line TYPE string,
      ls_g_tadir TYPE tadir.

FIELD-SYMBOLS: <tadir> TYPE ztadir.

SELECT obj_name devclass INTO CORRESPONDING FIELDS OF TABLE lt_g_tadir FROM TADIR FOR ALL ENTRIES IN lt_tadir
  WHERE obj_name = lt_tadir-obj_name AND pgmid = 'R3TR'.

SORT lt_g_tadir BY obj_name.

LOOP AT lt_tadir ASSIGNING <tadir>.
   READ TABLE lt_g_tadir INTO ls_g_tadir WITH KEY obj_name = <tadir>-obj_name BINARY SEARCH.
   CHECK sy-subrc = 0.
   <tadir>-devclass = ls_g_tadir-devclass.
ENDLOOP.

DELETE FROM ztadir.
DELETE lt_tadir WHERE devclass = space.
lv_line = lines( lt_tadir ).
INSERT ztadir FROM TABLE lt_tadir.

WRITE: / 'total ' , lv_line , ' inserted!'.
COMMIT WORK AND WAIT.
ENDFORM.

