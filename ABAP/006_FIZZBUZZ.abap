*&---------------------------------------------------------------------*
*& Report ZCOND
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCOND.

cl_demo_output=>display(
  VALUE string_table(
    FOR i = 1 WHILE i <= 100 (
      COND string( LET r3 = i MOD 3
                       r5 = i MOD 5 IN
                   WHEN r3 = 0 AND r5 = 0 THEN |FIZZBUZZ|
                   WHEN r3 = 0            THEN |FIZZ|
                   WHEN r5 = 0            THEN |BUZZ|
                   ELSE i )  " end of COND string
                             ) " end of () 
     )" end of value table
      ). " end of display call 