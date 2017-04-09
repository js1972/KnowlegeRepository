REPORT Z_DEV_ENV_DEMO.
INCLUDE Z_DEV_CROSS_REF1.
PARAMETERS : p_pgmid     TYPE e071-pgmid DEFAULT 'R3TR',
           p_object    TYPE e071-object DEFAULT 'PROG',
           p_objnam  TYPE e071-obj_name DEFAULT 'BCALV_EDIT_08',
           p_regen AS CHECKBOX DEFAULT 'X'.

START-OF-SELECTION.
  IF p_object = 'PROG' AND p_regen = 'X'.
    SUBMIT saprseui
          WITH repname = p_objnam
          AND RETURN.
  ENDIF.
  DATA ls_object     TYPE lcl_dev_cross_ref=>type_s_e071_objkey.
  DATA lt_subobject  TYPE lcl_dev_cross_ref=>type_t_e071_key.
  FIELD-SYMBOLS <ls_subobject> TYPE lcl_dev_cross_ref=>type_s_e071_objkey.
  DATA lt_e071_key TYPE lcl_dev_cross_ref=>type_t_e071_rel.
  FIELD-SYMBOLS <ls_e071_key> TYPE lcl_dev_cross_ref=>type_s_e071_rel.
  ls_object-pgmid = p_pgmid.
  ls_object-object = p_object.
  ls_object-obj_name = p_objnam.
* List of subobjects of the requested object
  CALL METHOD lcl_dev_cross_ref=>get_subobj
    EXPORTING
      is_object    = ls_object
    IMPORTING
      et_subobject = lt_subobject.
  LOOP AT lt_subobject ASSIGNING <ls_subobject>.
    WRITE : / <ls_subobject>-pgmid, <ls_subobject>-object, <ls_subobject>-obj_name.
  ENDLOOP.

  ULINE.
* List of objects used by the requested object
  CALL METHOD lcl_dev_cross_ref=>get_reqobj
    EXPORTING
      is_e071_key = ls_object
    IMPORTING
      et_e071_key = lt_e071_key.
  LOOP AT lt_e071_key ASSIGNING <ls_e071_key>.
    WRITE : / <ls_e071_key>-subobject-pgmid, <ls_e071_key>-subobject-object,
          <ls_e071_key>-subobject-obj_name.
  ENDLOOP.