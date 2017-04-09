REPORT zactivate.

PARAMETERS: purl TYPE string OBLIGATORY LOWER CASE.

DATA: lv_content TYPE string,
      lt_node    TYPE zcl_jerry_tool=>tt_sorted_node,
      lv_number  TYPE int4,
      lv_size    TYPE int4,
      lv_index   TYPE int4 VALUE 1,
      lt_pic     TYPE string_table.
"test by Jerry
CONSTANTS: folder TYPE string VALUE 'C:\Users\i042416\Pictures\pic\clipboard'.

START-OF-SELECTION.
  DATA: lv_url TYPE string.

  lv_url = 'http://note.youdao.com/yws/public/note/' && purl && '?keyfrom=public'.
  lv_content = zcl_crm_cm_tool=>get_text_by_url( lv_url ).

  CALL METHOD zcl_jerry_tool=>parse_json_to_internal_table
    EXPORTING
      iv_json        = lv_content
    IMPORTING
      et_node        = lt_node
      ev_node_number = lv_number.

  ASSERT lv_number = 1.

  READ TABLE lt_node ASSIGNING FIELD-SYMBOL(<node>) WITH KEY attribute = 'content'.

  ASSERT sy-subrc = 0.

  SPLIT <node>-value AT space INTO TABLE DATA(lt_result).

  LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<entry>) WHERE table_line CS 'src='.
    lv_number = strlen( <entry> ) - 6.
    DATA(url) = <entry>+5(lv_number).
    REPLACE ALL OCCURRENCES OF `"` IN url WITH space.
    CONDENSE url.
    APPEND url TO lt_pic.
  ENDLOOP.

  DATA(lv_total) = lines( lt_pic ).
  LOOP AT lt_pic ASSIGNING FIELD-SYMBOL(<pic>).
    DATA(lv_name) = folder && lv_index && '.png'.
    DATA(lv_text) = 'Downloading file: ' && lv_name.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
         PERCENTAGE = lv_index * 100 / lv_total
         text = lv_text.

    DATA(binary) = zcl_crm_cm_tool=>get_data_by_url( <pic> ).

    zcl_crm_cm_tool=>download_locally( iv_local_path = lv_name iv_binary = binary ).
    ADD 1 TO lv_index.
  ENDLOOP.

  WRITE: / 'totally ', lv_total, ' pictures downloaded successfully!' COLOR COL_NEGATIVE.