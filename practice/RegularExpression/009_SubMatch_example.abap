*&---------------------------------------------------------------------*
*& Report ztest_association
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_association.

DATA: lv_origin_url1 TYPE STRING value 'http://ww2.sinaimg.cn/large/d19bb9dfgw1ebdk3zbk3rj20ch0a5jrv.jpg',

      lv_thumbnail_2 TYPE STRING value 'http://ww3.sinaimg.cn/thumbnail/d19bb9dfgw1ebdk3zp82mj20bi07omxx.jpg',

      lv_result2 TYPE string.

"use regular expression

DATA(reg_pattern) = '(http://)([\.\w]+)/(\w+)/([\.\w]+)'.

DATA(lo_regex) = NEW cl_abap_regex( pattern = reg_pattern ).

DATA(lo_matcher) = lo_regex->create_matcher( EXPORTING text = lv_thumbnail_2 ).

CHECK lo_matcher->match( ) = abap_true.

DATA(lt_reg_match_result) = lo_matcher->find_all( ).

READ TABLE lt_reg_match_result ASSIGNING FIELD-SYMBOL(<reg_entry>) INDEX 1.

LOOP AT <reg_entry>-submatches ASSIGNING FIELD-SYMBOL(<match>).
  WRITE: / lv_thumbnail_2+<match>-offset(<match>-length).
ENDLOOP.