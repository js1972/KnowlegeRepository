START-OF-SELECTION.
  DATA: lv_1 TYPE int4 VALUE 20,
        lv_2 TYPE int4 VALUE 50.
* Approach 1
  DATA(a) =  CONV xstring( lv_1 ) BIT-XOR CONV xstring( lv_2 ) .
  DATA(b) = a BIT-XOR CONV xstring( lv_2 ).
  a = a BIT-XOR b.
  WRITE: / CONV int4( a ), " 50
           CONV int4( b ). " 20
* Approach2 - Jerry: potential Overflow!!!!!!!!!!!
* and there are lots of variants in the internet - the main idea is the
* arithmeti operation
  lv_1 = lv_2 - lv_1.
  lv_2 = lv_2 - lv_1.
  lv_1 = lv_2 + lv_1.

  WRITE: / lv_1, lv_2.

* Approach 3
*  push eax
*  mov eax,ebx
*  pop ebx