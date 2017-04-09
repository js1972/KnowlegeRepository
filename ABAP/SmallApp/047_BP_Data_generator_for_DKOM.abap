REPORT ZBP_DATA_GENERATOR.

PARAMETERS: test TYPE char1 AS CHECKBOX DEFAULT 'X'.

DATA: lt_data TYPE STANDARD TABLE OF BUT000,
      lv_title_id TYPE BUT000-title,
      lt_title_map TYPE string_table,
      lv_title_size TYPE int4,
      lv_firstname TYPE but000-name_first,
      lt_first_map TYPE string_table,
      lt_last_map TYPE string_table,
      lv_first_Size type int4,
      lv_last_size type int4,
      lv_last_name TYPE but000-name_last,
      lv_ac_title_size TYPE int4,
      lt_ac_title_map TYPE string_table,
      lv_birth TYPE but000-birthdt,
      lv_ac_title_id TYPE but000-title_aca1.

INITIALIZATION.
   PERFORM init.

START-OF-SELECTION.

SELECT * INTO TABLE lt_data FROM but000 WHERE type = '1'. " Individual account

LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<bp>).
   IF <bp>-title IS INITIAL.
      PERFORM generate_title_id USING sy-tabix CHANGING lv_title_id.
      <bp>-title = lv_title_id.
   ENDIF.

   IF <bp>-title_aca1 IS INITIAL.
      PERFORM generate_actitle_id USING sy-tabix CHANGING lv_ac_title_id.
      <bp>-title_aca1 = lv_ac_title_id.
   ENDIF.

   IF <bp>-name_first IS INITIAL.
      PERFORM generate_first_name USING sy-tabix CHANGING lv_firstname.
      <bp>-name_first = lv_firstname.
      <bp>-mc_name1 = lv_firstname.
      TRANSLATE <bp>-mc_name1 TO UPPER CASE.
   ENDIF.

   IF <bp>-name_last IS INITIAL.
      PERFORM generate_last_name USING sy-tabix CHANGING lv_last_name.
      <bp>-name_last = lv_last_name.
      <bp>-mc_name2 = lv_last_name.
      TRANSLATE <bp>-mc_name2 TO UPPER CASE.
   ENDIF.

   IF <bp>-birthdt IS INITIAL.
      PERFORM generate_birth USING sy-tabix CHANGING lv_birth.
      <bp>-birthdt = lv_birth.
   ENDIF.

ENDLOOP.

BREAK-POINT.

IF test = abap_false.
   UPDATE but000 FROM TABLE lt_data.
   COMMIT WORK AND WAIT.
   ASSERT sy-subrc = 0.
   WRITE: / 'Number of updated entries: ' COLOR COL_NEGATIVE, sy-dbcnt  COLOR COL_TOTAL.
ENDIF.

FORM generate_title_id USING iv_index CHANGING cv_title_id TYPE but000-title.
   DATA(lv_index) = iv_index MOD lv_title_size.
   IF lv_index = 0.
      lv_index = 1.
   ENDIF.
   READ TABLE lt_title_map ASSIGNING FIELD-SYMBOL(<entry>) INDEX lv_index.
   cv_title_id = <entry>.
ENDFORM.

FORM generate_actitle_id USING iv_index CHANGING cv_actitle_id TYPE but000-title_aca1.
   DATA(lv_index) = iv_index MOD lv_ac_title_size.
   IF lv_index = 0.
      lv_index = 1.
   ENDIF.
   READ TABLE lt_ac_title_map ASSIGNING FIELD-SYMBOL(<entry>) INDEX lv_index.
   cv_actitle_id = <entry>.
ENDFORM.

FORM generate_first_name USING iv_index CHANGING cv_firstname TYPE but000-name_first.
   DATA(lv_index) = iv_index MOD lv_first_size.
   IF lv_index = 0.
      lv_index = 1.
   ENDIF.
   READ TABLE lt_first_map ASSIGNING FIELD-SYMBOL(<entry>) INDEX lv_index.
   cv_firstname = <entry>.
ENDFORM.

FORM generate_last_name USING iv_index CHANGING cv_lastname TYPE but000-name_last.
   DATA(lv_index) = iv_index MOD lv_last_size.
   IF lv_index = 0.
      lv_index = 1.
   ENDIF.
   READ TABLE lt_last_map ASSIGNING FIELD-SYMBOL(<entry>) INDEX lv_index.
   cv_lastname = <entry>.
ENDFORM.

FORM generate_birth USING iv_index CHANGING cv_birth TYPE but000-birthdt.
   cv_birth = sy-datum - iv_index.
ENDFORM.

FORM init.
   PERFORM init_title.
   PERFORM init_first_name.
   PERFORM init_last_name.
   PERFORM init_ac_title.
ENDFORM.

FORM init_title.
   APPEND '0001' TO lt_title_map. "Ms."
   APPEND '0002' TO lt_title_map. "Mr."
   APPEND '0003' TO lt_title_map. "Company
   APPEND '0004' TO lt_title_map. "Mr & Ms
   lv_title_size = lines( lt_title_map ).
ENDFORM.

FORM init_first_name.
   APPEND 'Jerry' TO lt_first_map.
   APPEND 'Derry' TO lt_first_map.
   APPEND 'Kate' TO lt_first_map.
   APPEND 'Bille' TO lt_first_map.
   APPEND 'Jeanne' TO lt_first_map.
   APPEND 'Thomas' TO lt_first_map.
   APPEND 'Ian' TO lt_first_map.
   APPEND 'Patrick' TO lt_first_map.
   APPEND 'Evan' TO lt_first_map.
   APPEND 'Poseidon' TO lt_first_map.
   APPEND 'Chris' TO lt_first_map.
   APPEND 'Bob' TO lt_first_map.
   APPEND 'Tim' TO lt_first_map.
   APPEND 'George' TO lt_first_map.
   APPEND 'Tracy' TO lt_first_map.
   APPEND 'Cathy' TO lt_first_map.
   APPEND 'Fred' TO lt_first_map.
   lv_first_size = lines( lt_first_map ).
ENDFORM.

FORM init_last_name.
   APPEND 'Carsten' TO lt_last_map.
   APPEND 'Manfred' TO lt_last_map.
   APPEND 'Gerhard' TO lt_last_map.
   APPEND 'Zahradníček' TO lt_last_map.
   APPEND 'Wouter' TO lt_last_map.
   APPEND 'Orlando' TO lt_last_map.
   APPEND 'Frank' TO lt_last_map.
   APPEND 'Shwetha' TO lt_last_map.
   APPEND 'Klisak' TO lt_last_map.
   APPEND 'Linda' TO lt_last_map.
   APPEND 'Harry' TO lt_last_map.
   APPEND 'Daniel' TO lt_last_map.
   APPEND 'Andrew' TO lt_last_map.

   lv_last_size = lines( lt_last_map ).
 ENDFORM.

 FORM init_ac_title.
    APPEND '0001' TO lt_ac_title_map. "Dr
    APPEND '0002' TO lt_ac_title_map. "Professor
    APPEND '0003' TO lt_ac_title_map. "Professor Dr
    APPEND '0004' TO lt_ac_title_map. "Bachelor of Art
    APPEND '0005' TO lt_ac_title_map. "MBA
    APPEND '0006' TO lt_ac_title_map. "Dr of Philosophy

    lv_ac_title_size = lines( lt_ac_title_map ).
 ENDFORM.