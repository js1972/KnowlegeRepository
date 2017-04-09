*&---------------------------------------------------------------------*
*& Report ZTEST_TABLE1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_TABLE1.

TYPES: BEGIN OF ty_structure,
    name TYPE string,
    score TYPE int4,
    skill TYPE int4,
    rank TYPe int4,
    END OF ty_structure,

   BEGIN OF ty_structure2,
    name TYPE char10,
    score TYPE int4,
    skill TYPE int4,
    rank TYPe int4,
    END OF ty_structure2.

START-OF-SELECTION.
     DATA(ls1) = value ty_structure( name = 'Jerry' score = 100 skill = 1 rank = 1 ).
     DATA(ls2) = value ty_structure2( name = 'Sean' score = 101 skill = 2 rank = 1 ).

     "DATA(lv1) = ls1(3). Accessing part of a field is not allowed for internal tables, 
     " deep structures, or references.
     DATA(lv1) = ls2(3).
     WRITE: / lv1.
     DATA(lv2) = ls2(4).
     WRITE: / lv2.

     "DATA(lv3) = ls2(20)." The specified length "20" exceeds the length of the character-like
     "initial part (=10) of the structure. This is not allowed in Unicode programs
     "WRITE: / lv3.