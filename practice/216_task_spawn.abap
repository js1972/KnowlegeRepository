*&---------------------------------------------------------------------*
*& Report ZTEST_W
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_W.
data: lv_total type int4 value 12,
      lv_current_index TYPE int4,
      lv_block type int4 value 4.

data: lt_total type table of int4.

DO lv_total TIMEs.
   APPEND sy-index TO lt_total.
ENDDO.
data(lv_additional) = lv_total mod lv_block.
data(lv_task_num) = lv_total div lv_block + lv_additional.

"IF lv_additional = 0.
   DO lv_task_num TIMES.
     WRITE: / 'index:' , sy-index, ' begin *************************'.

*     LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<task>) FROM sy-index TO ( sy-index + lv_per_task - 1 ).
*        WRITE: / <task>.
*     ENDLOOP.
     lv_current_index = 1 + lv_block * ( sy-index - 1 ).
     DO lv_block TIMES.
        read table lt_total ASSIGNING FIELD-SYMBOL(<task>) index lv_current_index.
        IF sy-subrc = 0.
          WRITE: / 'current task: ' , <task>.
          lv_current_index = lv_current_index + 1.
        ELSE.
          WRITE: / 'All task over ***************'.
          EXIT.
        ENDIF.
     ENDDO.
     WRITE: / 'index:' , sy-index, ' over *************************'.
     ULINE.
     NEW-LINE.
   ENDDO.


"ENDIF.