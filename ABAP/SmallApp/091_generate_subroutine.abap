*&---------------------------------------------------------------------*
*& Report  ZSUBROUTINE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZSUBROUTINE.

DATA: prog  TYPE string,
      tab  TYPE STANDARD TABLE OF string,
      mess TYPE string,
      sid  TYPE string.

APPEND 'PROGRAM subpool.'                        TO tab.
APPEND `DATA spfli_tab TYPE TABLE OF spfli.`     TO tab.
APPEND `LOAD-OF-PROGRAM.`                        TO tab.
APPEND `  SELECT *` &
       `         FROM spfli` &
       `         INTO TABLE spfli_tab.`          TO tab.
APPEND `FORM loop_at_tab.`                       TO tab.
APPEND `  DATA spfli_wa TYPE spfli.`             TO tab.
APPEND `  LOOP AT spfli_tab INTO spfli_wa.`      TO tab.
APPEND `    PERFORM evaluate_wa USING spfli_wa.` TO tab.
APPEND `  ENDLOOP.`                              TO tab.
APPEND `ENDFORM.`                                TO tab.
APPEND `FORM evaluate_wa USING l_wa TYPE spfli.` TO tab.
APPEND `  WRITE: / l_wa-carrid, l_wa-connid.`    TO tab.
APPEND `ENDFORM.`                                TO tab.

GENERATE SUBROUTINE POOL tab NAME prog
         MESSAGE mess
         SHORTDUMP-ID sid.

IF sy-subrc = 0.
  PERFORM ('LOOP_AT_TAB') IN PROGRAM (prog) IF FOUND.
ELSEIF sy-subrc = 4.
  MESSAGE mess TYPE 'I'.
ELSEIF sy-subrc = 8.
  MESSAGE sid TYPE 'I'.
ENDIF.