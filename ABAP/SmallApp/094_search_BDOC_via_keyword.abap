*&---------------------------------------------------------------------*
*& Report  ZSCAN_BDOC_VIA_KEYWORD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zscan_bdoc_via_keyword.

PARAMETERS: start TYPE smw3_bdoc-snd_date OBLIGATORY DEFAULT sy-datlo,
            end   TYPE smw3_bdoc-snd_date OBLIGATORY DEFAULT sy-datlo,
            keyword TYPE string LOWER CASE OBLIGATORY DEFAULT 'CRMA'.

DATA: lv_bdoc_id TYPE smw3_bdoc1-bdoc_id VALUE 'FA163E8EAB031EE496D7B1616132B3D2',
      lt_header  TYPE STANDARD TABLE OF smw3_bdoc,
      lv_xml     TYPE xstring,
      lv_count   TYPE i,
      lv_string  TYPE string.

START-OF-SELECTION.
  PERFORM main.
FORM main.

  SELECT * INTO TABLE lt_header FROM smw3_bdoc WHERE snd_date >= start AND snd_date <= end.
  IF sy-subrc <> 0.
    WRITE: / 'No BDOC exists for given time period.'.
    RETURN.
  ENDIF.

  lv_count = lines( lt_header ).
  LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<header>).
    PERFORM display_progress USING sy-tabix.
    PERFORM get_bdoc_ext_via_id USING <header>-bdoc_id CHANGING lv_xml.
    CALL FUNCTION 'ECATT_CONV_XSTRING_TO_STRING'
      EXPORTING
        im_xstring = lv_xml
      IMPORTING
        ex_string  = lv_string.
    FIND keyword IN lv_string.
    IF sy-subrc = 0.
       WRITE: / 'found search keyword in BDOC: ' , <header>-bdoc_id.
    ENDIF.
    CLEAR: lv_xml, lv_string.
  ENDLOOP.

ENDFORM.

FORM get_bdoc_ext_via_id USING iv_id TYPE smw3_bdoc1-bdoc_id CHANGING cv_xml TYPE any.
  DATA: wa_smw3_bdoc TYPE smw3_fhd,
        l_dtyp       TYPE smw3_ddic1,
        bdoc_ext     TYPE REF TO data.

  FIELD-SYMBOLS: <b_ext> TYPE any.

  CALL METHOD cl_smw_bdocstore=>get_bdoc
    EXPORTING
      bdoc_id         = iv_id
      get_bdoc_header = 'X'
    IMPORTING
      bdoc_header     = wa_smw3_bdoc
    EXCEPTIONS
      OTHERS          = 4.

  ASSERT sy-subrc = 0.

  IF wa_smw3_bdoc-ddic2 IS INITIAL.
    "MESSAGE s006(smw3).
    " No BDoc extension available (no messaging BDoc).
    WRITE: / 'Not BDOC extension avaible for BDOC id: ' , lv_bdoc_id.
    EXIT.
  ENDIF.

* create data refs
  l_dtyp = wa_smw3_bdoc-ddic2 .
  CREATE DATA bdoc_ext TYPE (l_dtyp).
  ASSIGN: bdoc_ext->*        TO <b_ext>.
  CLEAR: <b_ext>.

  CALL METHOD cl_smw_bdocstore=>get_bdoc
    EXPORTING
      bdoc_id           = iv_id
      get_bdoc_header   = ' '
      get_body_ext      = 'X'
    IMPORTING
      bdoc_body_ext     = <b_ext>
    EXCEPTIONS
      invalid_bdoc_id   = 1
      inconsistent_body = 2
      failed            = 3
      OTHERS            = 4.

  CHECK sy-subrc = 0.

  PERFORM get_xml_source USING <b_ext> CHANGING cv_xml.
  CLEAR: <b_ext>, bdoc_ext.

ENDFORM.

FORM display_progress USING iv_percent.
  DATA: lv_percent type i,
        lv_text TYPE string.

  lv_percent = iv_percent * 100 / lv_count.
  lv_text = 'In process... ' && lv_percent && '%'.

   CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
     EXPORTING
        PERCENTAGE = lv_percent
        text = lv_text.
eNDFORM.

FORM get_xml_source USING is_ext TYPE any CHANGING cv_xml TYPE xstring.


  DATA:
*    x_xml_tab        TYPE swr_t_html,
    lv_rc            TYPE sy-subrc,
    lref_document    TYPE REF TO if_ixml_document,
    lref_data_as_dom TYPE REF TO if_ixml_element.


*  Maps a ABAP variable into a DOM structure
  CALL FUNCTION 'SDIXML_DATA_TO_DOM'
    EXPORTING
      name         = 'MESSAGE'
      dataobject   = is_ext
*     CONTROL      =
    IMPORTING
      data_as_dom  = lref_data_as_dom
    CHANGING
      document     = lref_document
*     TYPE_HANDLE  =
    EXCEPTIONS
      illegal_name = 1
      OTHERS       = 2.

  ASSERT sy-subrc = 0.

  CALL METHOD lref_document->append_child
    EXPORTING
      new_child = lref_data_as_dom
    RECEIVING
      rval      = lv_rc.
  ASSERT sy-subrc = 0.

* SDIXML_DOM_TO_XML
  CALL FUNCTION 'SDIXML_DOM_TO_XML'
    EXPORTING
      document      = lref_document
    IMPORTING
      xml_as_string = cv_xml
    EXCEPTIONS
      OTHERS        = 1.
  ASSERT sy-subrc = 0.

ENDFORM.