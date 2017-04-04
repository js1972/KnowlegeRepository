class ZCL_CCTV_DISABLE_WORDCONTROL definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_WD_BADI_DOMODIFYVIEW .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CCTV_DISABLE_WORDCONTROL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CCTV_DISABLE_WORDCONTROL->IF_WD_BADI_DOMODIFYVIEW~WDDOMODIFYVIEW
* +-------------------------------------------------------------------------------------------------+
* | [--->] FIRST_TIME                     TYPE        WDY_BOOLEAN
* | [--->] VIEW                           TYPE REF TO IF_WD_VIEW
* | [--->] WD_CONTEXT                     TYPE REF TO IF_WD_CONTEXT_NODE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_WD_BADI_DOMODIFYVIEW~WDDOMODIFYVIEW.

    DATA: lv_content TYPE xstring.

    DATA(lo_source) = wd_context->get_child_node( 'SOURCE' ).

    CHECK lo_source IS NOT INITIAL.
    lo_source->get_attribute( EXPORTING name = 'FULLSOURCE' IMPORTING value = lv_content ).
    CHECK lv_content IS NOT INITIAL.

    DATA:lv_ret       TYPE i,
         lx_temp      TYPE xstring,
         lv_msg       TYPE string,
         lt_parms     TYPE /ipro/tt_key_value_pair,
         ls_parm      LIKE LINE OF lt_parms.

   DATA(lo_docx) = cl_docx_document=>load_document( lv_content  ).
   DATA(lo_main_part) = lo_docx->get_maindocumentpart( ).
   DATA(lo_docx_settings) = lo_main_part->get_documentsettingspart( ).
   DATA(lx_settings) = lo_docx_settings->get_data( ).

   /ipro/cl_docx_utilities=>transform( EXPORTING  iv_input_xstring    = lx_settings
                                   iv_transform_name  = '/IPRO/DOCXCC_PROTECT'
                                   it_parameters      = lt_parms
                        IMPORTING  ev_result          = lx_temp
                                   ev_ret             = lv_ret
                                   ev_message         = lv_msg  ).
   lo_docx_settings->feed_data( lx_temp ).
   DATA(lx_docx_package) = lo_docx->get_package_data( ).
   lo_source->set_attribute( EXPORTING name = 'FULLSOURCE'  value = lx_docx_package ).
  endmethod.
ENDCLASS.