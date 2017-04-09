class ZCL_HKJC_TOOL definition
  public
  final
  create public .

public section.

  class-methods GET_BPINFO_COL_FOR_INIT
    returning
      value(RO_COL) type ref to IF_BOL_BO_COL .
  class-methods GET_DDLB_CATEOGRY
    importing
      !IV_DOM_NAME type DD07L-DOMNAME
      !IV_TYPE_NAME type ROLLNAME
    returning
      value(RO_DDLB_CATEGORY) type ref to CL_CRM_UIU_DDLB .
  class-methods REFRESH_AUTH_DETAIL
    importing
      !IO_AUTH_NODE_WRAPPER type ref to CL_BSP_WD_COLLECTION_WRAPPER
      !IO_BP_NODE_WRAPPER type ref to CL_BSP_WD_COLLECTION_WRAPPER .
  type-pools ABAP .
  class-methods IS_ASSIGN_BUTTON_ENABLED
    importing
      !IO_BP_NODE_WRAPPER type ref to CL_BSP_WD_COLLECTION_WRAPPER
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods ASSIGN_AUTH
    importing
      !IO_BPINFO_WRAPPER type ref to CL_BSP_WD_COLLECTION_WRAPPER
      !IO_MESSAGE_SERVICE type ref to CL_BSP_WD_MESSAGE_SERVICE .
  class-methods CHECK_AUTH
    returning
      value(RV_HAS_AUTH) type ABAP_BOOL .
  class-methods GET_DISABLE_ASSIGN_BLOCK
    importing
      !IO_MESSAGE_SERVICE type ref to CL_BSP_WD_MESSAGE_SERVICE
    returning
      value(RT_DISABLED_BLOCK) type BSP_DLC_OVW_STAT_VIEW_ATTACH_T .
  class-methods IS_DELETE_BUTTON_ENABLED
    importing
      !IO_BP_NODE_WRAPPER type ref to CL_BSP_WD_COLLECTION_WRAPPER
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods HANDLE_CLOSE_POPUP
    importing
      !IO_POPUP type ref to IF_BSP_WD_POPUP
      !IO_CONTEXT_NODE type ref to CL_ZVALUEHE_MAIN_CTXT .
  class-methods SET_DEFAULT_VALID_TO
    importing
      !IO_BPINFO_WRAPPER type ref to CL_BSP_WD_COLLECTION_WRAPPER .
  class-methods DELETE_AUTH
    importing
      !IO_BPINFO_WRAPPER type ref to CL_BSP_WD_COLLECTION_WRAPPER
      !IO_MESSAGE_SERVICE type ref to CL_BSP_WD_MESSAGE_SERVICE .
  class-methods GET_DISPLAY_TIME
    importing
      !IV_DB_TIME type ZHKJCAUTHO_ASSIG-VALID_FROM_TIME
    returning
      value(RV_RESULT) type ZDTHKTIME .
  class-methods CLASS_CONSTRUCTOR .
  class-methods GENERATE_QRCODE
    importing
      !IV_SOURCE type STRING
    returning
      value(RV_PDF) type XSTRING .
  class-methods SEND_MAIL
    importing
      !IT_SEND_TO type STRING_TABLE
      !IT_BODY type BCSY_TEXT
      !IV_SUBJECT type STRING
      !IV_PDF type XSTRING optional .
protected section.
private section.

  class-data:
    ST_DOM_LIST TYPE standard table of dd07v .

  class-methods GET_FULLNAME_BY_ID
    importing
      !IV_BP_ID type BU_PARTNER
    returning
      value(RV_FULLNAME) type BU_DESCRIP .
  class-methods GET_ID_BY_USER_NAME
    importing
      !IV_USER_NAME type SYUNAME
    returning
      value(RV_BP_ID) type BU_PARTNER .
  class-methods GET_FULLNAME_BY_NAME
    importing
      !IV_USER_NAME type SYUNAME
    returning
      value(RV_FULLNAME) type BU_DESCRIP .
  class-methods ADD_ATTACHMENT
    importing
      !IV_PDF type XSTRING
      !IO_DOCUMENT type ref to CL_DOCUMENT_BCS .
ENDCLASS.



CLASS ZCL_HKJC_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_HKJC_TOOL=>ADD_ATTACHMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PDF                         TYPE        XSTRING
* | [--->] IO_DOCUMENT                    TYPE REF TO CL_DOCUMENT_BCS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_attachment.
    DATA: lv_att_type TYPE soodk-objtp,
          lv_att_name TYPE sood-objdes,
          lv_att_size TYPE sood-objlen,
          lv_att_cont TYPE solix_tab.

    DATA: lt_pdf_content TYPE solix_tab.

    CHECK iv_pdf IS NOT INITIAL.
    lv_att_type = 'BIN'.
    lv_att_name = 'Membership_Updated_detail.pdf'.
    lv_att_size = xstrlen( iv_pdf ).
    lv_att_cont = cl_document_bcs=>xstring_to_solix( ip_xstring = iv_pdf ).

    io_document->add_attachment( i_attachment_type = lv_att_type
                                 i_attachment_subject = lv_att_name
                                 i_attachment_size = lv_att_size
                                 i_att_content_hex = lv_att_cont ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>ASSIGN_AUTH
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_BPINFO_WRAPPER              TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [--->] IO_MESSAGE_SERVICE             TYPE REF TO CL_BSP_WD_MESSAGE_SERVICE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method ASSIGN_AUTH.
    DATA: lo_node type ref to CL_BSP_WD_VALUE_NODE,
          lv_from_time TYPE ZHKJCAUTHO_ASSIG-valid_from_time,
          lv_to_time TYPE ZHKJCAUTHO_ASSIG-valid_to_time,
          lv_from_date TYPE CRMT_AUI_FROM,
          lv_to_date TYPE CRMT_AUI_TO,
          lt_domvalues     type standard table of dd07v,
          ls_domvalues LIKE LINE OF lt_domvalues,
          lv_bp_id TYPE  bu_partner.

    lo_node ?= io_bpinfo_wrapper->get_current( ).

    lo_node->get_property_as_value( EXPORTING iv_attr_name = 'VALID_TIME_FROM' IMPORTING ev_result = lv_from_time ).
    lo_node->get_property_as_value( EXPORTING iv_attr_name = 'VALID_TIME_TO' IMPORTING ev_result = lv_to_time ).
    lo_node->get_property_as_value( EXPORTING iv_attr_name = 'BP_ID' IMPORTING ev_result = lv_bp_id ).
    lo_node->get_property_as_value( EXPORTING iv_attr_name = 'FROM' IMPORTING ev_result = lv_from_date ).
    lo_node->get_property_as_value( EXPORTING iv_attr_name = 'TO' IMPORTING ev_result = lv_to_date ).

    DATA: lv_from_time_s TYPE string,
          lv_to_time_s TYPE string.
    READ TABLE st_dom_list INTO ls_domvalues WITH KEY domvalue_l = lv_from_time.
    CHECK sy-subrc = 0.
    lv_from_time_s = ls_domvalues-ddtext.

    READ TABLE st_dom_list INTO ls_domvalues WITH KEY domvalue_l = lv_to_time.
    CHECK sy-subrc = 0.
    lv_to_time_s = ls_domvalues-ddtext.

    DATA: ls_assign TYPE ZHKJCAUTHO_ASSIG.

    ls_assign-bp_id = lv_bp_id.
    ls_assign-valid_from_date = lv_from_date.
    ls_assign-valid_to_date = lv_to_date.
    REPLACE ALL OCCURRENCES OF ':' IN lv_from_time_s WITH space.
    ls_assign-valid_from_time = lv_from_time_s.

    REPLACE ALL OCCURRENCES OF ':' IN lv_to_time_s WITH space.
    ls_assign-valid_to_time = lv_to_time_s.
    ls_assign-assigned_by = sy-uname.

    INSERT ZHKJCAUTHO_ASSIG FROM ls_assign.

    io_message_service->add_message( iv_msg_type    = 'I'
                                     iv_msg_id      = 'ZHKJCMESSAGE'
                                     iv_msg_v1      = lv_bp_id
                                     iv_msg_number  = 000 ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>CHECK_AUTH
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_HAS_AUTH                    TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_auth.
    DATA: lv_timestamp TYPE timestamp.

    DATA: lv_local_date TYPE sy-datum, lv_local_time TYPE sy-timlo,
          lv_fulldate   TYPE string,
          lv_fulldate_i TYPE timestamp,
          lv_bp         TYPE bu_partner,
          ls_assign     TYPE zhkjcautho_assig.

    GET TIME STAMP FIELD lv_timestamp.
    CONVERT TIME STAMP lv_timestamp TIME ZONE sy-zonlo
    INTO DATE lv_local_date TIME lv_local_time.

    lv_fulldate = lv_local_date && lv_local_time.
    lv_fulldate_i = lv_fulldate.

    lv_bp = get_id_by_user_name( sy-uname ).

    SELECT SINGLE * INTO ls_assign FROM zhkjcautho_assig WHERE bp_id = lv_bp.
    CHECK sy-subrc = 0.

    REPLACE ALL OCCURRENCES OF ':' IN ls_assign-valid_from_time WITH space.
    REPLACE ALL OCCURRENCES OF ':' IN ls_assign-valid_to_time WITH space.

    DATA: lv_from_time_i TYPE timestamp,
          lv_to_time_i   TYPE timestamp.

    lv_from_time_i = ls_assign-valid_from_date && ls_assign-valid_from_time.
    lv_to_time_i = ls_assign-valid_to_date && ls_assign-valid_to_time.
    lv_fulldate_i = lv_fulldate.

    IF lv_fulldate_i >= lv_from_time_i AND lv_fulldate_i <= lv_to_time_i.
      rv_has_auth = abap_true.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CLASS_CONSTRUCTOR.
    call function 'DD_DOMVALUES_GET'
      exporting
        domname   = 'ZHKTIMEDOMAIN'
        text      = 'X'
        langu     = sy-langu
      tables
        dd07v_tab = st_dom_list
      exceptions
        others    = 0.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>DELETE_AUTH
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_BPINFO_WRAPPER              TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [--->] IO_MESSAGE_SERVICE             TYPE REF TO CL_BSP_WD_MESSAGE_SERVICE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method DELETE_AUTH.
    DATA: lo_node type ref to CL_BSP_WD_VALUE_NODE,
          lv_from_time TYPE ZHKJCAUTHO_ASSIG-valid_from_time,
          lv_to_time TYPE ZHKJCAUTHO_ASSIG-valid_to_time,
          lv_from_date TYPE CRMT_AUI_FROM,
          lv_to_date TYPE CRMT_AUI_TO,
          lt_domvalues     type standard table of dd07v,
          ls_domvalues LIKE LINE OF lt_domvalues,
          lv_bp_id TYPE  bu_partner.

    lo_node ?= io_bpinfo_wrapper->get_current( ).

    lo_node->get_property_as_value( EXPORTING iv_attr_name = 'BP_ID' IMPORTING ev_result = lv_bp_id ).

    CHECK lv_bp_id IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
         input  = lv_bp_id
      IMPORTING
         output = lv_bp_id.

    DELETE FROM ZHKJCAUTHO_ASSIG WHERE bp_id = lv_bp_id.

    io_message_service->add_message( iv_msg_type    = 'I'
                                     iv_msg_id      = 'ZHKJCMESSAGE'
                                     iv_msg_v1      = lv_bp_id
                                     iv_msg_number  = 001 ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>GENERATE_QRCODE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SOURCE                      TYPE        STRING
* | [<-()] RV_PDF                         TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GENERATE_QRCODE.
 DATA:
  ls_outputparams TYPE sfpoutputparams,
  ls_docparams    TYPE sfpdocparams,
  ls_pdf_file     TYPE fpformoutput,
  ls_post         TYPE crmd_soc_post,
  lv_fm_name      TYPE rs38l_fnam.

ls_outputparams-noprint   = 'X'.
ls_outputparams-nopributt = 'X'.
ls_outputparams-noarchive = 'X'.
ls_outputparams-nodialog  = 'X'.
ls_outputparams-preview   = 'X'.
ls_outputparams-getpdf    = 'X'.

CALL FUNCTION 'FP_JOB_OPEN'
  CHANGING
    ie_outputparams = ls_outputparams
  EXCEPTIONS
    cancel          = 1
    usage_error     = 2
    system_error    = 3
    internal_error  = 4
    OTHERS          = 5.

CHECK sy-subrc = 0.

TRY.
    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = 'ZPF_QRCODE'
      IMPORTING
        e_funcname = lv_fm_name.
  CATCH cx_fp_api_repository
        cx_fp_api_usage
        cx_fp_api_internal.
    RETURN.
ENDTRY.

ls_docparams-langu     = 'E'.
ls_docparams-country   = 'US'.

CALL FUNCTION lv_fm_name
  EXPORTING
    /1bcdwb/docparams  = ls_docparams
    qrcode_input       = iv_source
  IMPORTING
    /1bcdwb/formoutput = ls_pdf_file
  EXCEPTIONS
    usage_error        = 1
    system_error       = 2
    internal_error     = 3
    OTHERS             = 4.

CHECK sy-subrc = 0.
CALL FUNCTION 'FP_JOB_CLOSE'
  EXCEPTIONS
    usage_error    = 1
    system_error   = 2
    internal_error = 3
    OTHERS         = 4.

CHECK sy-subrc = 0.
rv_pdf = ls_pdf_file-pdf.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>GET_BPINFO_COL_FOR_INIT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RO_COL                         TYPE REF TO IF_BOL_BO_COL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_BPINFO_COL_FOR_INIT.
    TYPES: BEGIN OF ltype_attr_struct,
             BP_ID           TYPE BU_PARTNER,
             BP_NAME         TYPE STRING,
             from            TYPE CRMT_AUI_FROM, "Added by wizard
             to              TYPE CRMT_AUI_TO, "Added by wizard
             valid_time_from TYPE ZDTHKTIME, "Added by wizard
             valid_time_to   TYPE ZDTHKTIME, "Added by wizard
             duration        TYPE ZHKJCDURATION, "Added by wizard
    END OF ltype_attr_struct.

    DATA: lv_struct_ref TYPE REF TO ltype_attr_struct,
          lv_value_node TYPE REF TO cl_bsp_wd_value_node.

    CREATE DATA lv_struct_ref.
    lv_struct_ref->from = sy-datum.
    lv_struct_ref->to = sy-datum.
    CREATE OBJECT lv_value_node
      EXPORTING
        iv_data_ref = lv_struct_ref.
    CREATE OBJECT ro_col TYPE cl_crm_bol_bo_col.

    ro_col->add( lv_value_node ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>GET_DDLB_CATEOGRY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DOM_NAME                    TYPE        DD07L-DOMNAME
* | [--->] IV_TYPE_NAME                   TYPE        ROLLNAME
* | [<-()] RO_DDLB_CATEGORY               TYPE REF TO CL_CRM_UIU_DDLB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_DDLB_CATEOGRY.
data: ls_domvalue      type dd07v,
      ls_value         type bsp_wd_dropdown_line,
      ls_value_group   type bsp_wd_dropdown_line,
      lt_domvalues     type standard table of dd07v,
      lt_ddlb          type bsp_wd_dropdown_table.

    create object ro_ddlb_category
        exporting
          iv_source_type = 'T'.

*    call function 'DD_DOMVALUES_GET'
*      exporting
*        domname   = iv_dom_name
*        text      = 'X'
*        langu     = sy-langu
*      tables
*        dd07v_tab = lt_domvalues
*      exceptions
*        others    = 0.
*    loop at lt_domvalues into ls_domvalue.
*      ls_value-key   = ls_domvalue-domvalue_l.
*      ls_value-value = ls_domvalue-ddtext.
*      append ls_value to lt_ddlb.
*    endloop.

    ro_ddlb_category->set_data_element( IV_DATA_ELEMENT = iv_type_name )."#EC_NOTEXT

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>GET_DISABLE_ASSIGN_BLOCK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_MESSAGE_SERVICE             TYPE REF TO CL_BSP_WD_MESSAGE_SERVICE
* | [<-()] RT_DISABLED_BLOCK              TYPE        BSP_DLC_OVW_STAT_VIEW_ATTACH_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_DISABLE_ASSIGN_BLOCK.
   data: ls_view TYPE bsp_dlc_ovw_stat_view_attach.
   ls_view-viewid = 'CUMSHMA.LOY102H_MSH/MSHMemberActivities'.
   APPEND ls_view TO rt_disabled_block.

   DATA(lv_bp_id) = zcl_hkjc_tool=>get_id_by_user_name( sy-uname ).

    io_message_service->add_message( iv_msg_type    = 'W'
                                     iv_msg_id      = 'ZHKJCMESSAGE'
                                     iv_msg_v1      = lv_bp_id
                                     iv_msg_number  = 002 ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>GET_DISPLAY_TIME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DB_TIME                     TYPE        ZHKJCAUTHO_ASSIG-VALID_FROM_TIME
* | [<-()] RV_RESULT                      TYPE        ZDTHKTIME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_DISPLAY_TIME.
    "iv_db_time: "030000"
   CHECK iv_db_time IS NOT INITIAL.

   data: lv_time_s TYPE string,
         lv_search TYPE ddtext.

   lv_time_s = iv_db_time.

   lv_search = lv_time_s+0(2) && ':' && lv_time_s+2(2).

   READ TABLE st_dom_list ASSIGNING FIELD-SYMBOL(<item>) WITH KEY ddtext = lv_search.
   CHECK sy-subrc = 0.

   rv_result = <item>-domvalue_l.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_HKJC_TOOL=>GET_FULLNAME_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BP_ID                       TYPE        BU_PARTNER
* | [<-()] RV_FULLNAME                    TYPE        BU_DESCRIP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_FULLNAME_BY_ID.

    CALL FUNCTION 'CRM_BUPA_DESCRIPTION_READ'
      EXPORTING
         iv_partner          = iv_bp_id
      IMPORTING
         ev_description_name = rv_fullname
      EXCEPTIONS
         no_partner_specified  = 1
         no_valid_record_found = 2
         OTHERS                = 3.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_HKJC_TOOL=>GET_FULLNAME_BY_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_USER_NAME                   TYPE        SYUNAME
* | [<-()] RV_FULLNAME                    TYPE        BU_DESCRIP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_FULLNAME_BY_NAME.
    DATA: lv_id TYPE bu_partner.

    lv_id = GET_ID_BY_USER_NAME( iv_user_name ).
    rv_fullname = GET_FULLNAME_BY_ID( lv_id ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_HKJC_TOOL=>GET_ID_BY_USER_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_USER_NAME                   TYPE        SYUNAME
* | [<-()] RV_BP_ID                       TYPE        BU_PARTNER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_ID_BY_USER_NAME.
    DATA: ls_user_name TYPE BAPIBNAME.

    CHECK iv_user_name IS NOT INITIAL.
    ls_user_name-BAPIBNAME = iv_user_name.
    CALL FUNCTION 'COM_BPUS_BUPA_FOR_USER_GET'
    EXPORTING
      is_username           = ls_user_name
    IMPORTING
      ev_businesspartner    = rv_bp_id
    EXCEPTIONS
      no_central_person     = 1
      no_business_partner   = 2
      no_id                 = 3
      no_user               = 4
      no_alias              = 5
      alias_and_user_differ = 6
      internal_error        = 7
      OTHERS                = 8.

    CHECK sy-subrc = 0.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = rv_bp_id
      IMPORTING
        output = rv_bp_id.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>HANDLE_CLOSE_POPUP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_POPUP                       TYPE REF TO IF_BSP_WD_POPUP
* | [--->] IO_CONTEXT_NODE                TYPE REF TO CL_ZVALUEHE_MAIN_CTXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method HANDLE_CLOSE_POPUP.
    DATA: lv_target_node TYPE REF TO cl_bsp_wd_context_node.
  DATA: lr_node      TYPE REF TO cl_bsp_wd_context_node,
        lr_entity    TYPE REF TO if_bol_bo_property_access,
        lr_entity_bp TYPE REF TO if_bol_bo_property_access,
        lv_bp_id    TYPE bu_partner.

  lr_entity ?= io_context_node->bpinfo->collection_wrapper->get_current( ).

  ASSERT lr_entity IS NOT INITIAL.

  ASSERT io_popup IS BOUND.

  lr_node = io_popup->get_context_node( 'PARTNER' ).
  CHECK lr_node IS BOUND.

  lr_entity_bp = lr_node->collection_wrapper->get_current( ).
  CHECK lr_entity IS BOUND AND lr_entity_bp IS BOUND.

  lv_bp_id = lr_entity_bp->get_property_as_string( 'BP_NUMBER' ). "#EC NOTEXT
  CHECK lv_bp_id IS NOT INITIAL.

  lr_entity->set_property( iv_attr_name = 'BP_ID' iv_value     = lv_bp_id ).

  lr_entity->set_property( iv_attr_name = 'BP_NAME' iv_value = get_fullname_by_id( lv_bp_id ) ).

  DATA: lr_assignment TYPE REF TO CL_BSP_WD_VALUE_NODE.

  io_context_node->assignment->collection_wrapper->clear_collection( ).

  TYPES: BEGIN OF ltype_attr_struct,
             BP_ID            TYPE BU_PARTNER,
             VALID_FROM_DATE  TYPE CRMT_AUI_FROM,
             VALID_FROM_TIME  TYPE ZDTHKTIME,
             VALID_TO_DATE    TYPE CRMT_AUI_TO,
             VALID_TO_TIME    TYPE ZDTHKTIME,
             ASSIGNED_BY      TYPE BU_PARTNER,
             ASSIGNED_BY_NAME TYPE CHAR20,

           END OF ltype_attr_struct.

  DATA: lv_struct_ref TYPE REF TO ltype_attr_struct,
        ls_assignment TYPE ZHKJCAUTHO_ASSIG,
        lv_value_node TYPE REF TO cl_bsp_wd_value_node,
        lv_bo_coll    TYPE REF TO if_bol_bo_col.

    SELECT SINGLE * INTO ls_assignment FROM ZHKJCAUTHO_ASSIG WHERE bp_id = lv_bp_id.

    CREATE DATA lv_struct_ref.
    lv_struct_ref->bp_id = ls_assignment-bp_id.
    lv_struct_ref->valid_from_date = ls_assignment-valid_from_date.
    lv_struct_ref->valid_from_time = ls_assignment-valid_from_time.
    lv_struct_ref->valid_to_date = ls_assignment-valid_to_date.
    lv_struct_ref->valid_to_time = ls_assignment-valid_to_time.
    lv_struct_ref->assigned_by = ls_assignment-assigned_by.
    "lv_struct_ref->assigned_by_name = ls_assignment-assigned_by_name.

    CREATE OBJECT lv_value_node
      EXPORTING
        iv_data_ref = lv_struct_ref.

    CREATE OBJECT lv_bo_coll TYPE cl_crm_bol_bo_col.

    lv_bo_coll->add( lv_value_node ).

    io_context_node->assignment->collection_wrapper->set_collection( lv_bo_coll ).


  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>IS_ASSIGN_BUTTON_ENABLED
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_BP_NODE_WRAPPER             TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [<-()] RV_RESULT                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IS_ASSIGN_BUTTON_ENABLED.
    DATA: lo_entity TYPE REF TO CL_BSP_WD_VALUE_NODE,
          ls_assignment TYPE ZHKJCAUTHO_ASSIG,
          lv_bp_id TYPE bu_partner.

    lo_entity ?= io_bp_node_wrapper->get_current( ).

    CHECK lo_entity IS NOT INITIAL.

    lo_entity->get_property_as_value( EXPORTING iv_attr_name = 'BP_ID' IMPORTING ev_result = lv_bp_id ).
    CHECK lv_bp_id IS NOT INITIAL.

    SELECT SINGLE * INTO ls_assignment FROM ZHKJCAUTHO_ASSIG WHERE bp_id = lv_bp_id.
    IF sy-subrc = 4. " assignment already exists
      rv_result = abap_true.
    ENDIF.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>IS_DELETE_BUTTON_ENABLED
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_BP_NODE_WRAPPER             TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [<-()] RV_RESULT                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IS_DELETE_BUTTON_ENABLED.
    DATA: lo_entity TYPE REF TO CL_BSP_WD_VALUE_NODE,
          ls_assignment TYPE ZHKJCAUTHO_ASSIG,
          lv_bp_id TYPE bu_partner.

    rv_result = abap_false.
    lo_entity ?= io_bp_node_wrapper->get_current( ).

    CHECK lo_entity IS NOT INITIAL.

    lo_entity->get_property_as_value( EXPORTING iv_attr_name = 'BP_ID' IMPORTING ev_result = lv_bp_id ).
    CHECK lv_bp_id IS NOT INITIAL.

    SELECT SINGLE * INTO ls_assignment FROM ZHKJCAUTHO_ASSIG WHERE bp_id = lv_bp_id.
    IF sy-subrc = 0. " assignment already exists
      rv_result = abap_true.
    ENDIF.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>REFRESH_AUTH_DETAIL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_AUTH_NODE_WRAPPER           TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [--->] IO_BP_NODE_WRAPPER             TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method REFRESH_AUTH_DETAIL.
    DATA: lv_partner TYPE bu_partner,
          lo_entity TYPE REF TO CL_BSP_WD_VALUE_NODE,
          lo_bp LIKE lo_entity,
          lv_bp TYPE bu_partner.

    DATA: ls_assignment TYPE ZHKJCAUTHO_ASSIG.

    lo_bp ?= io_bp_node_wrapper->get_current( ).
    CHECK lo_bp IS NOT INITIAL.
    lo_bp->get_property_as_value( EXPORTING iv_attr_name = 'BP_ID' IMPORTING ev_result = lv_bp ).
    CHECK lv_bp IS NOT INITIAL.
    lo_entity ?= io_auth_node_wrapper->get_current( ).

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_bp
      IMPORTING
        output = lv_bp.

    SELECT SINGLE * INTO ls_assignment FROM ZHKJCAUTHO_ASSIG WHERE bp_id = lv_bp.

    lo_entity->set_property( EXPORTING iv_attr_name = 'BP_ID' iv_value = ls_assignment-bp_id ).

    lo_entity->set_property( EXPORTING iv_attr_name = 'VALID_FROM_DATE' iv_value = ls_assignment-valid_from_date ).

    lo_entity->set_property( EXPORTING iv_attr_name = 'VALID_TO_DATE' iv_value = ls_assignment-valid_to_date ).

    DATA: lv_from_display TYPE ZDTHKTIME,
          lv_to_display TYPE ZDTHKTIME.

    lv_from_display = zcl_hkjc_tool=>get_display_time( ls_assignment-valid_from_time ).
    lv_to_display = zcl_hkjc_tool=>get_display_time( ls_assignment-valid_to_time ).

    lo_entity->set_property( EXPORTING iv_attr_name = 'VALID_FROM_TIME' iv_value = lv_from_display ).

    lo_entity->set_property( EXPORTING iv_attr_name = 'VALID_TO_TIME' iv_value = lv_to_display ).

    lo_entity->set_property( EXPORTING iv_attr_name = 'ASSIGNED_BY' iv_value = ls_assignment-assigned_by ).

    lo_entity->set_property( EXPORTING iv_attr_name = 'ASSIGNED_BY_NAME'
                                       iv_value = get_fullname_by_name( ls_assignment-assigned_by ) ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>SEND_MAIL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_SEND_TO                     TYPE        STRING_TABLE
* | [--->] IT_BODY                        TYPE        BCSY_TEXT
* | [--->] IV_SUBJECT                     TYPE        STRING
* | [--->] IV_PDF                         TYPE        XSTRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD send_mail.
    DATA: lo_recipient TYPE REF TO cl_cam_address_bcs.
    TRY.
        DATA(lo_send_request) = cl_bcs=>create_persistent( ).
        DATA: lv_len TYPE so_obj_len VALUE 0.
        LOOP AT it_body ASSIGNING FIELD-SYMBOL(<line>).
          lv_len = lv_len + strlen( <line> ).
        ENDLOOP.

        DATA(lo_document) = cl_document_bcs=>create_document(
                        i_type    = 'RAW'
                        i_text    = it_body
                        i_length  = lv_len
                        i_subject = CONV #( iv_subject ) ).

        add_attachment( io_document = lo_document iv_pdf = iv_pdf ).
        lo_send_request->set_document( lo_document ).

        DATA(lo_sender) = cl_cam_address_bcs=>create_internet_address( 'LoyaltyAdministrator@hkjc.com' ).
        lo_send_request->set_sender( lo_sender ).

        LOOP AT it_send_to ASSIGNING FIELD-SYMBOL(<lv_send_to>).
          lo_recipient = cl_cam_address_bcs=>create_internet_address( conv #( <lv_send_to> ) ).
          lo_send_request->set_send_immediately( i_send_immediately = 'X' ).

          lo_send_request->add_recipient( i_recipient = lo_recipient i_express   = 'X' ).
        ENDLOOP.
        lo_send_request->send( i_with_error_screen = 'X' ).

        COMMIT WORK AND WAIT.

      CATCH cx_bcs INTO DATA(lo_bcs_exception).
        DATA(lv_message) = lo_bcs_exception->get_text( ).
        WRITE:/ lv_message.
        RETURN.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_HKJC_TOOL=>SET_DEFAULT_VALID_TO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_BPINFO_WRAPPER              TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method SET_DEFAULT_VALID_TO.
  CONSTANTS: cv_default TYPE ZDTHKTIME VALUE '2'.
  data: lo_entity TYPE REF TO CL_BSP_WD_VALUE_NODE.

  lo_entity ?= io_bpinfo_wrapper->get_current( ).

  lo_entity->set_property( EXPORTING iv_attr_name = 'VALID_TIME_TO' iv_value = cv_default ).
  endmethod.
ENDCLASS.