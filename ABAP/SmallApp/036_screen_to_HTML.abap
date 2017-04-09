REPORT ZSCREEN_TO_HTML.
        .
PARAMETERS : P_PROG     LIKE d020s-prog OBLIGATORY.
PARAMETERS : P_DYNNR(4) TYPE C          OBLIGATORY.
SET LANGUAGE 'EN'.

CALL FUNCTION 'RS_SCRP_PRINT_IN_LIST'
  EXPORTING
    ATTRIBS         = ' '
    DYNNR           = P_DYNNR
    FIELDS          = ' '
    FULLSCR         = 'X'
    LOGIC           = ' '
    PROGNAME        = P_PROG
*   TRANS           = ' '
* EXCEPTIONS
*   CANCELLED       = 1
*   NOT_FOUND       = 2
*   OTHERS          = 3
          .
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.