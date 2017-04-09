REPORT zuser_com.

TYPES: tt_user_info TYPE STANDARD TABLE OF uinfo.
DATA: BEGIN OF ls_user_info.
INCLUDE STRUCTURE uinfo AS info.
DATA dest TYPE rfchosts-rfcdest.

DATA END OF ls_user_info.

DATA: lt_usr_liste TYPE tt_user_info,
      lt_total     LIKE STANDARD TABLE OF ls_user_info,
      lt_rfchosts  TYPE STANDARD TABLE OF rfchosts.

CONSTANTS: gc_user_name TYPE uinfo-bname VALUE 'User Name',
           gc_tcode     TYPE uinfo-tcode VALUE 'Tcode',
           gc_term      TYPE uinfo-term VALUE 'Terminal',
           gc_logon     TYPE uinfo-zeit VALUE 'Time'.

CALL FUNCTION 'RFC_GET_LOCAL_DESTINATIONS'
  TABLES
    localdest = lt_rfchosts.

CALL FUNCTION 'THUSRINFO'
  TABLES
    usr_tabl              = lt_usr_liste
  EXCEPTIONS
    communication_failure = 17.

ASSERT sy-subrc = 0.

PERFORM fill_dest USING lt_usr_liste 'NONE'.

LOOP AT lt_rfchosts ASSIGNING FIELD-SYMBOL(<rfc>).
  CLEAR: lt_usr_liste.
  CALL FUNCTION 'THUSRINFO' DESTINATION <rfc>-rfcdest
    TABLES
      usr_tabl              = lt_usr_liste
    EXCEPTIONS
      communication_failure = 17.

  PERFORM fill_dest USING lt_usr_liste <rfc>-rfcdest.

ENDLOOP.

DELETE lt_total WHERE mandt <> sy-mandt.

SORT lt_total BY bname.

WRITE: / gc_user_name, gc_tcode, gc_term,  gc_logon.

LOOP AT lt_total INTO DATA(user).
  WRITE: / user-bname UNDER gc_user_name COLOR COL_NEGATIVE,
      user-tcode UNDER gc_tcode COLOR COL_POSITIVE,
      user-term UNDER gc_term COLOR COL_KEY,
      user-zeit UNDER gc_logon COLOR COL_TOTAL.

  HIDE user-bname.
  HIDE user-dest.
ENDLOOP.


AT LINE-SELECTION.
  DATA: lv_message TYPE sm04dic-popupmsg VALUE 'hello world, this text is sent via ABAP'.

  CALL FUNCTION 'TH_POPUP'
    DESTINATION user-dest
    EXPORTING
      client         = sy-mandt
      user           = user-bname
      message        = lv_message
      message_len    = strlen( lv_message )
    EXCEPTIONS
      user_not_found = 1
      OTHERS         = 2.

FORM fill_dest USING it_user_info_raw TYPE tt_user_info iv_dest TYPE rfchosts-rfcdest.
  LOOP AT it_user_info_raw ASSIGNING FIELD-SYMBOL(<user1>).
    CLEAR: ls_user_info.
    MOVE-CORRESPONDING <user1> TO ls_user_info.
    ls_user_info-dest = iv_dest.
    APPEND ls_user_info TO lt_total.
  ENDLOOP.
ENDFORM.