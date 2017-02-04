*&---------------------------------------------------------------------*
*& Report ZFAKE_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfake_test.

data: lv_data TYPE string.

CALL FUNCTION 'SSFC_BASE64_ENCODE'
   EXPORTING
      BINDATA = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
   IMPORTING
      B64DATA = lv_data.

WRITE:/ lv_data.

data: lv_raw TYPE xstring.

CALL FUNCTION 'SSFC_BASE64_DECODE'
   EXPORTING
      B64DATA = lv_data
   IMPORTING
      BINDATA = lv_raw.

TRY.
" runtinme error: type error
CALL FUNCTION 'SSFC_BASE64_ENCODE'
   EXPORTING
      BINDATA = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345'
   IMPORTING
      B64DATA = lv_data.
WRITE:/ lv_data.
CATCH cx_root INTO data(cx_rooT).
  WRITE:/ cx_root->get_text( ).
ENDTRY.

TRY.
   data: lv_xstring type xstring.

   lv_xstring = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'.
   WRITE: / lv_xstring.

   lv_xstring = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345'.
   WRITE: / lv_xstring.

CATCH CX_ROOT INTO data(cx_rooT2).
  WRITE:/ cx_root2->get_text( ).
ENDTRY.
BREAK-POINT.
* string to xstring:
*x: 
*The characters in the source field are interpreted as the representation of the value of a half-byte in hexadecimal representation. If the valid characters "0" to "9" and "A" to "F" appear, the corresponding half-byte values are passed left-justified to the memory of the target field. If the target field is longer than the number of half-bytes passed, it is padded on the right with hexadecimal 0. If it is too short, the number is truncated on the right. The first invalid character terminates the conversion from the position of this character and the half-bytes not filled up to that point are padded with hexadecimal 0.
*xstring:
*The same conversion rules apply as to a field of type x. Half-bytes are passed to the target field, and the length of the target field is determined by the number of valid characters in the source field. If number of valid characters in the source field is odd, the last remaining half-byte in the target field is padded with hexadecimal 0.
