*&---------------------------------------------------------------------*
*& Report ZST22_ANALYZE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZST22_ANALYZE.

PARAMETERS errid TYPE snapt-errid.


CLASS write_dump DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
  PRIVATE SECTION.
    CLASS-METHODS write_section
      IMPORTING VALUE(errid) LIKE errid
                section      TYPE snapt-ttype.
ENDCLASS.

CLASS write_dump IMPLEMENTATION.
  METHOD main.
    WRITE / errid COLOR COL_HEADING.
    SKIP.
    WRITE / 'What happened?' COLOR COL_HEADING.
    write_section( errid = errid
                   section  = 'W' ).
    SKIP.
    WRITE / 'What can I do?' COLOR COL_HEADING.
    write_section( errid = errid
                   section  = 'T' ).
    SKIP.
    WRITE / 'Error analysis' COLOR COL_HEADING.
    write_section( errid = errid
                   section  = 'U' ).
    SKIP.
    WRITE / 'Hints for Error handling' COLOR COL_HEADING.
    write_section( errid = errid
                   section  = 'H' ).
    SKIP.
    WRITE / 'Internal notes' COLOR COL_HEADING.
    write_section( errid = errid
                   section  = 'I' ).
    SKIP.
  ENDMETHOD.
  METHOD write_section.
    DATA tline   TYPE snapt-tline.
    DATA sect    TYPE snapt-ttype.
    SELECT tline ttype
           FROM snapt INTO (tline,sect)
           WHERE langu = sy-langu AND
                 errid = errid AND
                 ttype = section
                 ORDER BY seqno.
      IF strlen( tline ) >= 8 AND
         tline(8) = '&INCLUDE'.
        REPLACE '&INCLUDE' IN tline WITH ``.
        CONDENSE tline.
        errid = tline.
        write_section( errid = errid
                       section = sect ).
      ELSE.
        WRITE / tline.
      ENDIF.
    ENDSELECT.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  write_dump=>main( ).