REPORT zdoc_test.
* probably written in 2014 Summer when I was responsible for CRM ticket processing 
START-OF-SELECTION.

  DATA: lo_document TYPE REF TO cl_docx_document,
        lv_content  TYPE xstring.

  PERFORM get_doc_binary USING 'C:\Users\i042416\Desktop\test.docx' CHANGING lv_content.

  lo_document = cl_docx_document=>load_document( lv_content ).
  CHECK lo_document IS NOT INITIAL.
*  DATA(lo_core_part) = lo_document->get_corepropertiespart( ).
*  DATA(lv_core_data) = lo_core_part->get_data( ).

  DATA(lo_main_part) = lo_document->get_maindocumentpart( ).
  DATA(lv_main_data) = lo_main_part->get_data( ).

  DATA(lo_image_parts) = lo_main_part->get_imageparts( ).
  DATA(lv_image_count) = lo_image_parts->get_count( ).

  DO lv_image_count TIMES.
    DATA(lo_image_part) = lo_image_parts->get_part( sy-index - 1 ).
    DATA(lv_image_data) = lo_image_part->get_data( ).
  ENDDO.

*  DATA(lo_header_parts) = lo_main_part->get_headerparts( ).
*  DATA(lv_header_count) = lo_header_parts->get_count( ).
*
*  DO lv_header_count TIMES.
*    DATA(lo_header_part) = lo_header_parts->get_part( sy-index - 1 ).
*    DATA(lv_header_data) = lo_header_part->get_data( ).
*  ENDDO.

  DATA(lo_new_image_part) = lo_main_part->add_imagepart( iv_content_type = cl_oxml_imagepart=>co_content_type_png ).

  DATA: lv_new_pic TYPE xstring.

  PERFORM get_doc_binary USING 'C:\Users\i042416\Desktop\clipboard.png' CHANGING lv_new_pic.

  lo_new_image_part->feed_data( lv_new_pic ).

  lo_image_parts->append_part( lo_new_image_part ).

  lo_main_part->add_part( lo_new_image_part ).

  lv_main_data = lo_main_part->get_data( ).

  DATA(modified_doc) = lo_document->get_package_data( ).

  BREAK-POINT.

FORM get_doc_binary USING iv_path TYPE string CHANGING cv_binary TYPE xstring.
  CONSTANTS c_linelen TYPE i VALUE 255.
  DATA: wa_data(c_linelen) TYPE x,
        lt_data            LIKE TABLE OF wa_data,
        converter          TYPE REF TO cl_abap_conv_in_ce,
        lv_length          TYPE i.

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = iv_path
      filetype                = 'BIN'
    IMPORTING
      filelength              = lv_length
    CHANGING
      data_tab                = lt_data
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = lv_length
    IMPORTING
      buffer       = cv_binary
    TABLES
      binary_tab   = lt_data
    EXCEPTIONS
      failed       = 1
      OTHERS       = 2.
  IF sy-subrc  <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.