*&---------------------------------------------------------------------*
*& Report  ZFUN
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZFUN.

PARAMETERS: command TYPE string LOWER CASE.

DATA: commtext(120) ,
      itab(255) OCCURS 10 WITH HEADER LINE.
commtext = command.
CALL 'SYSTEM' ID 'COMMAND' FIELD commtext ID 'TAB' FIELD itab[].

LOOP AT itab.
  WRITE itab.
ENDLOOP.