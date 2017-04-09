*&---------------------------------------------------------------------*
*& Report  ZVIEW_SAVED_QUERY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zview_saved_query.

DATA: lt_saved_query TYPE STANDARD TABLE OF crmd_shortcut,
      ls_saved_query LIKE LINE OF lt_saved_query,
      ls_d_query     TYPE crmt_dyn_query,
      lv_guid        TYPE char4 VALUE 'guid',
      lv_type        TYPE char4 VALUE 'type',
      lv_app         TYPE char10 VALUE 'application',
      lv_desc        TYPE string VALUE 'description'.

START-OF-SELECTION.
  SELECT * INTO TABLE lt_saved_query FROM crmd_shortcut WHERE owner_key = sy-uname.

  WRITE: lv_guid COLOR COL_NEGATIVE, lv_type COLOR COL_POSITIVE, lv_app COLOR
  COL_GROUP, lv_desc COLOR COL_KEY.
  LOOP AT lt_saved_query INTO ls_saved_query.
    WRITE: / ls_saved_query-guid UNDER lv_guid, ls_saved_query-type,
    ls_saved_query-application, ls_saved_query-description.
    HIDE ls_saved_query-guid.
  ENDLOOP.

AT LINE-SELECTION.
  PERFORM display_detail USING ls_saved_query-guid.

FORM display_detail USING iv_guid TYPE crmd_shortcut-guid.
  READ TABLE lt_saved_query ASSIGNING FIELD-SYMBOL(<hit>)
    WITH KEY guid = iv_guid.
  ASSERT sy-subrc = 0.

  SELECT SINGLE * INTO ls_d_query FROM crmt_dyn_query
     WHERE query_id = <hit>-parameter_.

    ASSERT sy-subrc = 0.

    cl_demo_output=>display_xml( ls_d_query-selection_param ).
ENDFORM.