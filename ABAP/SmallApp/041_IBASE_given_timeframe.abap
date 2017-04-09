REPORT ZIBASE_LIST.

PARAMETERS: use TYPE sy-uname OBLIGATORY DEFAULT sy-uname,
            fromt TYPE sy-datum OBLIGATORY DEFAULT sy-datum,
            tot TYPE sy-datum OBLIGATORY DEFAULT sy-datum.


DATA: lt_ib TYPE STANDARD TABLE OF ibib,
      from_Time TYPE ICRTS,
      to_time TYPE ICRTS.

CONVERT DATE fromt INTO TIME STAMP from_time TIME ZONE 'UTC'.
CONVERT DATE tot INTO TIME STAMP to_time TIME ZONE 'UTC'.

SELECT * INTO TABLE lt_ib FROM ibib WHERE crnam = use AND crtim BETWEEN from_Time AND to_time.

LOOP AT lt_ib ASSIGNING FIELD-SYMBOL(<ibase>).
   WRITE: / 'IBASE ID: ', <ibase>-ibase COLOR COL_GROUP, 'IBASE type: ', <ibase>-ibtyp COLOR COL_NEGATIVE.
ENDLOOP.