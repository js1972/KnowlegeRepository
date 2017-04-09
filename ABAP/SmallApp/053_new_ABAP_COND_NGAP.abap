*&---------------------------------------------------------------------*
*& Report ZCOND
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCOND.

DATA: lv_string TYPE string,
      lv_count TYPE int4 value 1.

lv_string = 'Jerry' &&  COND #( WHEN lv_count = 1 THEN ' Hello' ELSE 'default'  ).

WRITE:/ lv_string.

RETURN.
cl_demo_output=>display(
  VALUE string_table(
    FOR i = 1 WHILE i <= 100 (
" COND string: line type is string
" LET: define local variable r3 and r5 - local auxiliary fields. 
      COND string( LET r3 = i MOD 3 
                       r5 = i MOD 5 IN
                   WHEN r3 = 0 AND r5 = 0 THEN |FIZZBUZZ|
                   WHEN r3 = 0            THEN |FIZZ|
                   WHEN r5 = 0            THEN |BUZZ|
                   ELSE i ) ) ) ).
* another example
cl_demo_output=>display( 

COND #( LET t = '120000' IN 
          WHEN sy-timlo < t THEN 
            |{ sy-timlo TIME = ISO } AM| 
          WHEN sy-timlo > t AND sy-timlo < '240000' THEN 
            |{ CONV t( sy-timlo - 12 * 3600 ) TIME = ISO } PM| 
          WHEN sy-timlo = t THEN 
            |High Noon| 
          ELSE 
            THROW cx_cant_be( ) ) ). 