*&---------------------------------------------------------------------*
*& Report  ZDISPLAY_APP
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdisplay_app.

PARAMETERS: id TYPE if_fdt_types=>id OBLIGATORY DEFAULT
'FA163E8EAB031EE48B847A9EF751D5F0'.

START-OF-SELECTION.
  TYPES: BEGIN OF ty_code,
           code TYPE if_fdt_types=>object_type,
           text TYPE string,
         END OF ty_code.
  DATA:      lo_instance TYPE REF TO if_fdt_admin_data,
             lo_app      TYPE REF TO cl_fdt_application,
             lt_all      TYPE if_fdt_types=>ts_object_id,
             lv_unknown  TYPE boolean,
             lt_map      TYPE STANDARD TABLE OF ty_code WITH KEY code.

  CALL METHOD cl_fdt_factory=>get_instance_generic
    EXPORTING
      iv_id         = id
    IMPORTING
      eo_instance   = lo_instance
      ev_id_unknown = lv_unknown.

  lo_app ?= lo_instance.

  lo_app->if_fdt_application_objects~get_all( IMPORTING ets_object_id = lt_all ).

  LOOP AT lt_all ASSIGNING FIELD-SYMBOL(<id>).
    PERFORM display USING <id>.
  ENDLOOP.

FORM display USING id TYPE if_fdt_types=>id.

  CALL METHOD cl_fdt_factory=>get_instance_generic
    EXPORTING
      iv_id         = id
    IMPORTING
      eo_instance   = lo_instance
      ev_id_unknown = lv_unknown.

  IF lv_unknown = abap_true.
    WRITE: / 'ID Unknown.' COLOR COL_NEGATIVE.
    EXIT.
  ENDIF.

  DATA(lo_object) = cl_abap_classdescr=>describe_by_object_ref( lo_instance ).
  DATA(lv_type) = lo_object->get_relative_name( ).
  WRITE: / lv_type COLOR COL_NEGATIVE.
  PERFORM display_by_type USING lo_instance lv_type.

ENDFORM.

FORM display_by_type USING io_obj TYPE REF TO if_fdt_admin_data
                            iv_type TYPE string.

  DATA: lv_type_full TYPE string,
        lv_text      TYPE string,
        lt_dt_all    TYPE if_fdt_types=>ts_object_id,
        lt_fo_all    LIKE lt_dt_all.
  CASE iv_type.
    WHEN 'CL_FDT_ELEMENT'.
      DATA(lo_element) = CAST cl_fdt_element( io_obj ).
      lv_text = lo_element->if_fdt_admin_data~get_name( ).
      DATA(lv_type) = lo_element->if_fdt_admin_data~get_object_type( ).
      PERFORM get_type USING lv_type CHANGING lv_type_full.
      WRITE: / 'element text: ', lv_text, ' type: ', lv_type_full COLOR COL_POSITIVE.
    WHEN 'CL_FDT_DECISION_TABLE'.
      DATA(lo_dt) = CAST cl_fdt_decision_table( io_obj ).
      lv_text = lo_dt->if_fdt_admin_data~get_name( ).
      WRITE: / 'Decision table name: ', lv_text COLOR COL_GROUP.
      CLEAR: lt_dt_all.
      lo_dt->if_fdt_admin_data~get_referenced_objects( IMPORTING ets_object_id = lt_dt_all ).
      WRITE: / 'Below elements are within decision table' COLOR COL_POSITIVE.
      LOOP AT lt_dt_all ASSIGNING FIELD-SYMBOL(<dt_id>).
        PERFORM display USING <dt_id>.
      ENDLOOP.
      WRITE: / 'Decision table element display finished' COLOR COL_POSITIVE.
    WHEN 'CL_FDT_FORMULA'.
      DATA(lo_fo) = CAST cl_fdt_formula( io_obj ).
      lv_text = lo_fo->if_fdt_admin_data~get_name( ).
      WRITE: / 'Formula name: ' , lv_text COLOR COL_KEY.
      lo_fo->if_fdt_admin_data~get_referenced_objects( IMPORTING ets_object_id = lt_fo_all ).
      LOOP AT lt_fo_all ASSIGNING FIELD-SYMBOL(<fo_id>).
        WRITE: / 'Below elements are within formula' COLOR COL_POSITIVE.
        PERFORM display USING <fo_id>.
        WRITE: / 'formula element display finished' COLOR COL_POSITIVE.
      ENDLOOP.

  ENDCASE.
ENDFORM.

FORM get_type USING iv_code TYPE if_fdt_types=>object_type CHANGING cv_type TYPE string.
  DATA: ls_posttype TYPE ty_code,
        lv_code     TYPE dd07l-domvalue_l,
        lv_result   TYPE dd07v.

  READ TABLE lt_map WITH KEY code = iv_code INTO ls_posttype.
  IF sy-subrc = 0.
    cv_type = ls_posttype-text.
  ELSE.
    CLEAR ls_posttype.
    lv_code = iv_code.
    CALL FUNCTION 'DD_DOMVALUE_TEXT_GET'
      EXPORTING
        domname  = 'FDT_OBJECT_TYPE'
        value    = lv_code
      IMPORTING
        dd07v_wa = lv_result.

    ls_posttype-code = iv_code.
    ls_posttype-text = lv_result-ddtext.
    APPEND ls_posttype TO lt_map.

    cv_type = lv_result-ddtext.
  ENDIF.

ENDFORM.