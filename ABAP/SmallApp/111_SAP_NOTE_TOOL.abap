*&---------------------------------------------------------------------*
*& Report ZNOTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT znote.

PARAMETERS: note TYPE cwbntkeylg-numm OBLIGATORY DEFAULT '2184333'.
DATA: lv_insta           TYPE cwbntinsta,
      ls_note_key        TYPE cwbntkeylg,
      lv_full_length     TYPE i,
      lt_comp            TYPE abap_compdescr_tab,
      lv_data_bin        TYPE xstring,
      lv_code_delta_bin  TYPE xstring,
      lt_object_data_bin TYPE cwbci_t_objdelta,
      lv_rfcmsg          LIKE scwbrfcmsg-text,
      lv_key             TYPE hash160,
      lv_check_key       TYPE hash160,
      lv_offset          TYPE i,
      lv_max_length      TYPE i,
      lv_data            TYPE xstring,
      lv_chunk_data      TYPE xstring,
      lv_unzipped_size   TYPE i,
      lt_cwbnthead       LIKE cwbnthead OCCURS 0,
      lt_cwbntstxt       LIKE cwbntstxt OCCURS 0,
      lt_cwbntdata       TYPE bcwbn_note_text OCCURS 0,
      lt_cwbntdata_html  TYPE bcwbn_notehtml_text OCCURS 0,
      lt_cwbntvalid      LIKE cwbntvalid OCCURS 0,
      lt_cwbntci         LIKE cwbntci OCCURS 0,
      lt_cwbntfixed      LIKE cwbntfixed OCCURS 0,
      lt_cwbntgattr      LIKE cwbntgattr OCCURS 0,
      lt_cwbcihead       LIKE cwbcihead OCCURS 0,
      lt_cwbcidata       TYPE bcwbn_cinst_delta OCCURS 0,
      lt_cwbcidata_ref   TYPE cwb_deltas,
      lt_cwbcivalid      LIKE cwbcivalid OCCURS 0,
      lt_cwbciinvld      LIKE cwbciinvld OCCURS 0,
      lt_cwbcifixed      LIKE cwbcifixed OCCURS 0,
      lt_cwbcidpndc      LIKE cwbcidpndc OCCURS 0,
      lt_cwbciobj        LIKE cwbciobj OCCURS 0,
      lt_cwbcmpnt        LIKE cwbcmpnt OCCURS 0,
      lt_cwbcmtext       LIKE cwbcmtext OCCURS 0,
      lt_cwbcmlast       LIKE cwbcmlast OCCURS 0,
      lt_cwbdehead       LIKE cwbdehead OCCURS 0,
      lt_cwbdeprdc       LIKE cwbdeprdc OCCURS 0,
      lt_cwbdetrack      LIKE cwbdetrack OCCURS 0,
      lt_cwbdeequiv      LIKE cwbdeequiv OCCURS 0,
      lt_cwbcinstattr    TYPE cwbci_t_attr.

START-OF-SELECTION.
  PERFORM main.
FORM main.

  ls_note_key-langu = 'E'.
  ls_note_key-numm = note.

  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
    IMPORTING
      license_number = lv_insta.

  CALL FUNCTION 'BHREM_SAPNOTE_RFC_GET_CHUNKED' DESTINATION 'SAPSNOTE'
    EXPORTING
      is_note_key_lg        = ls_note_key
      iv_check_status       = 'X'
      iv_insta_cust         = lv_insta
      iv_na_fmt_id          = 3
    IMPORTING
      ev_full_length        = lv_full_length
      ev_chunk_data         = lv_chunk_data
    CHANGING
      cv_key                = lv_key
      cv_chunk_offset       = lv_offset
      cv_chunk_max_length   = lv_max_length
    EXCEPTIONS
      system_failure        = 1 MESSAGE lv_rfcmsg
      communication_failure = 2 MESSAGE lv_rfcmsg
      note_not_exist        = 3
      note_not_released     = 4
      note_langu_not_exist  = 5
      pack_error            = 6
      note_incomplete       = 7
      note_format_error     = 8
      protocol_error        = 9
      OTHERS                = 10.

  IF sy-subrc <> 0.
    WRITE: / 'note download failed: ', lv_rfcmsg.
    RETURN.
  ENDIF.

  WRITE: / 'size ( compressed ):', lv_full_length.

  lv_data = lv_chunk_data.

  CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
    EXPORTING
      alg            = 'SHA1'
      data           = lv_data
    IMPORTING
      hash           = lv_check_key
    EXCEPTIONS
      unknown_alg    = 1
      param_error    = 2
      internal_error = 3
      OTHERS         = 4.
  IF lv_check_key <> lv_key.
    WRITE:/ 'note key verification failed.'.
    RETURN.
  ENDIF.

  cl_abap_gzip=>decompress_binary( EXPORTING gzip_in   = lv_data
                                   IMPORTING raw_out   = lv_data ).

  CALL TRANSFORMATION id SOURCE XML lv_data
                         RESULT xml_data_bin         = lv_data_bin
                                xml_code_delta_bint  = lv_code_delta_bin
                                xml_object_data_bin  = lt_object_data_bin.

  CALL FUNCTION 'SCWN_NOTE_UNPACK_XML'
    EXPORTING
      iv_data_bin           = lv_data_bin
      iv_code_delta_bin     = lv_code_delta_bin
      it_object_data_bin    = lt_object_data_bin
    IMPORTING
      et_cwbnthead          = lt_cwbnthead
      et_cwbntstxt          = lt_cwbntstxt
      et_htmltext           = lt_cwbntdata_html
      et_cwbntdata          = lt_cwbntdata
      et_cwbntvalid         = lt_cwbntvalid
      et_cwbntci            = lt_cwbntci
      et_cwbntfixed         = lt_cwbntfixed
      et_cwbntgattr         = lt_cwbntgattr
      et_cwbcihead          = lt_cwbcihead
      et_cwbcidata          = lt_cwbcidata
      et_cwbcidata_ref      = lt_cwbcidata_ref
      et_cwbcivalid         = lt_cwbcivalid
      et_cwbciinvld         = lt_cwbciinvld
      et_cwbcifixed         = lt_cwbcifixed
      et_cwbcidpndc         = lt_cwbcidpndc
      et_cwbciobj           = lt_cwbciobj
      et_cwbcmpnt           = lt_cwbcmpnt
      et_cwbcmtext          = lt_cwbcmtext
      et_cwbcmlast          = lt_cwbcmlast
      et_cwbdehead          = lt_cwbdehead
      et_cwbdeprdc          = lt_cwbdeprdc
      et_cwbdetrack         = lt_cwbdetrack
      et_cwbdeequiv         = lt_cwbdeequiv
      et_cwbcinstattr       = lt_cwbcinstattr
    EXCEPTIONS
      corrupt_data_file     = 1
      incompatible_versions = 2
      OTHERS                = 3.

  PERFORM cal_obj_data_bin_size USING lt_object_data_bin CHANGING lv_unzipped_size.
  WRITE: / 'uncompressed size: (byte): ' , lv_unzipped_size.
  BREAK-POINT.

ENDFORM.

FORM cal_obj_data_bin_size USING it_obj_data TYPE cwbci_t_objdelta CHANGING iv_total_size TYPE i.
  DATA(lo_tab_type) = CAST cl_abap_tabledescr( cl_abap_typedescr=>describe_by_name( 'CWBCI_T_OBJDELTA' ) ).

  DATA(lo_line_type) = CAST cl_abap_structdescr( lo_tab_type->get_table_line_type( ) ).
  lt_comp = lo_line_type->components.
  LOOP AT it_obj_data ASSIGNING FIELD-SYMBOL(<obj_data_bin>).
    PERFORM calculate_line_size USING <obj_data_bin> CHANGING iv_total_size.
  ENDLOOP.
ENDFORM.

FORM calculate_line_size USING is_line_data TYPE cwbciobjdelta CHANGING iv_total_size TYPE i.
  DO.
    ASSIGN COMPONENT sy-index OF STRUCTURE is_line_data TO FIELD-SYMBOL(<data>).
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    READ TABLE lt_comp ASSIGNING FIELD-SYMBOL(<line_type>) INDEX sy-index.
    CASE <line_type>-type_kind.

      WHEN cl_abap_typedescr=>typekind_char OR cl_abap_typedescr=>typekind_num.
        iv_total_size = iv_total_size + strlen( <data> ) * 2.
      WHEN cl_abap_typedescr=>typekind_xstring.
        iv_total_size = iv_total_size + xstrlen( <data> ).
      WHEN OTHERS.
        ASSERT 1 = 0.
    ENDCASE.

  ENDDO.
ENDFORM.