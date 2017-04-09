class ZCL_CRM_ATTACHMENT_TOOL definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF lty_object_key,
      instid   TYPE sibfboriid,
      typeid   TYPE sibftypeid,
    END OF lty_object_key .
  types:
    ltty_object_key TYPE TABLE OF lty_object_key .

  methods PREFILL_ATTACHMENT_TAB
    importing
      !IV_NUM type INT4
    changing
      !CT_BP1 type ZCRM_BP_ATTACHMENT_T
      !CT_BP2 type ZCRM_BP_ATTACHMENT_T
      !CT_TASK1 type ZCRM_TASK_ATTACHMENT_T
      !CT_TASK2 type ZCRM_TASK_ATTACHMENT_T .
  methods COMPARE_BP
    importing
      !IT_BP1 type ZCRM_BP_ATTACHMENT_T
      !IT_BP2 type ZCRM_BP_ATTACHMENT_T
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods COMPARE_READ_RESULT
    importing
      !IT_ORIGIN type CRMT_ODATA_TASK_ATTACHMENTT
      !IT_JERRY type CRMT_ODATA_TASK_ATTACHMENTT
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods GET_ATTACHMENTS_ORIGIN
    importing
      !IT_OBJECTS type LTTY_OBJECT_KEY
    returning
      value(RT_ATTACHMENTS) type CRMT_ODATA_TASK_ATTACHMENTT .
  methods GET_STORAGE_BY_FM .
  methods GET_ATTACHMENT_BY_TASK_GUID
    importing
      !IV_TASK_GUID type CRMT_OBJECT_GUID
    returning
      value(RT_TASK_EXPAND) type CRMT_ODATA_TASK_HDR_EXPANDED .
  methods START .
  methods STOP
    importing
      !IV_MESSAGE type STRING optional .
  methods GET_ATTACHMENTS_BY_BP_WAY
    importing
      !IT_OBJECTS type LTTY_OBJECT_KEY
    returning
      value(RT_LINKS_A) type OBL_T_LINK .
  methods GET_ATTACHMENTS_BY_JERRY_WAY
    importing
      !IT_OBJECTS type LTTY_OBJECT_KEY
    returning
      value(RT_ATTACHMENTS) type CRMT_ODATA_TASK_ATTACHMENTT .
  methods COMPARE_LINK
    importing
      !IT_BP type OBL_T_LINK
      !IT_JERRY type OBL_T_LINK
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods GET_STORAGE_BY_REGULAR .
  methods GET_IOS_BY_KEY
    importing
      !IV_KEY type SIBFBORIID
    returning
      value(RS_IOS) type SKWF_IO .
  methods PASS_BY_REF
    exporting
      !ES_RESULT type TADIR .
  methods PASS_BY_VALUE
    returning
      value(RS_RESULT) type TADIR .
  methods COMPARE_VALUE_REF .
  methods CREATE_DOC
    importing
      !IV_TEXT type STRING
      !IV_BOR_TYPE type STRING
      !IV_GUID type CRMT_OBJECT_GUID
      !IV_FILE_NAME type STRING .
  methods SEQUENTIAL_READ
    importing
      !IV_LOOP_TIME type INT4
      !IT_ORDERS type LTTY_OBJECT_KEY
    returning
      value(RT_ATTACHMENTS) type CRMT_ODATA_TASK_ATTACHMENTT .
  methods PARALLEL_READ
    importing
      !IV_GROUP_NUMBER type INT4
      !IT_ORDERS type LTTY_OBJECT_KEY
    returning
      value(RT_ATTACHMENTS) type CRMT_ODATA_TASK_ATTACHMENTT .
  methods READ_FINISHED
    importing
      !P_TASK type CLIKE .
  methods CONSTRUCTOR .
  methods GET_TESTDATA
    returning
      value(RT_DATA) type CRMT_OBJECT_KEY_T .
  methods DYNAMIC_FILL_APPROACH1
    changing
      !CT_TABLE type ANY TABLE .
  methods DYNAMIC_FILL_APPROACH2
    changing
      !CT_TABLE type ANY TABLE .
  methods COMPARE_TASK
    importing
      !IT_TASK1 type ZCRM_TASK_ATTACHMENT_T
      !IT_TASK2 type ZCRM_TASK_ATTACHMENT_T
    returning
      value(RV_EQUAL) type ABAP_BOOL .
protected section.
private section.

  types:
    BEGIN OF ty_order_atta_link,
      order_guid   TYPE sibfboriid,
      order_bortype   TYPE sibftypeid,
      atta_type      TYPE skwf_ioty,
      attid_lo     TYPE sdok_docid,
      attid_ph     TYPE sdok_docid,
      END OF ty_order_atta_link .
  types:
    BEGIN OF ty_user_name,
             user_name TYPE bapibname-bapibname,
             fullname TYPE AD_NAMTEXT,
          END OF ty_user_name .
  types:
    tt_user_name TYPE STANDARD TABLE OF ty_user_name WITH KEY user_name .
  types:
    tt_order_atta_link TYPE STANDARD TABLE OF ty_order_atta_link .

  data MT_ATTACHMENT_RESULT type CRMT_ODATA_TASK_ATTACHMENTT .
  data MT_GUID_FOR_TEST type CRMT_OBJECT_GUID_TAB .
  data MT_BP_TEST_DATA type LTTY_OBJECT_KEY .
  data MV_FINISHED type INT4 .
  data MT_USER_NAME type TT_USER_NAME .
  data MT_ORDER_ATTA_LINK type TT_ORDER_ATTA_LINK .
  data MV_START type I .
  data MV_END type I .
  data MV_REGULAR_TEST_NUM type INT4 value 10000 ##NO_TEXT.

  methods GENERATE_TEST_GUID
    importing
      !IV_NUM type INT4 .
  methods GET_GUID_BY_INDEX
    importing
      !IV_INDEX type SYINDEX
    returning
      value(RV_GUID) type CRMT_OBJECT_GUID .
  methods GET_CREATED_BY
    importing
      !IV_USER_NAME type BAPIBNAME-BAPIBNAME
    returning
      value(RV_FULLNAME) type AD_NAMTEXT .
  methods GET_ALL_IOS_WITH_PROPERTIES
    importing
      !IT_LINKS type OBL_T_LINK
    exporting
      !ET_PROPERTY_RESULT type CRM_KW_PROPST
      !ET_FILE_ACCESS_INFO type SKWF_CPPRPS
      !ET_IP_LINKS type SDOKLOGPHYS .
  methods GET_LINKS
    importing
      !IT_OBJECTS type LTTY_OBJECT_KEY
    returning
      value(RT_LINKS_A) type OBL_T_LINK .
  methods GET_URL
    importing
      !IS_PROPERTIES type CRM_KW_PROPS
    returning
      value(RV_URL) type STRING .
  methods HANDLE_FOLDER
    importing
      !IT_FOLDERS type SKWF_IOS
    changing
      !CT_LOIOS type SKWF_IOS .
ENDCLASS.



CLASS ZCL_CRM_ATTACHMENT_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->COMPARE_BP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_BP1                         TYPE        ZCRM_BP_ATTACHMENT_T
* | [--->] IT_BP2                         TYPE        ZCRM_BP_ATTACHMENT_T
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method COMPARE_BP.
    LOOP AT it_bp1 ASSIGNING FIELD-SYMBOL(<bp1>).
       READ TABLE it_bp2 ASSIGNING FIELD-SYMBOL(<bp2>) WITH KEY header_guid = <bp1>-header_guid.
       IF sy-subrc <> 0.
          RETURN.
       ENDIF.

       LOOP AT <bp1>-attachment ASSIGNING FIELD-SYMBOL(<atta1>).
          READ TABLE <bp2>-attachment ASSIGNING FIELD-SYMBOL(<atta2>) WITH KEY
           documentid = <atta1>-documentid.

          IF sy-subrc <> 0.
             RETURN.
          ENDIF.

          IF <atta1>-created_by <> <atta2>-created_by.
            RETURN.
          ENDIF.

          IF <atta1>-name <> <atta2>-name.
             RETURN.
          ENDIF.
       ENDLOOP.
    ENDLOOP.

    rv_equal = abap_true.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->COMPARE_LINK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_BP                          TYPE        OBL_T_LINK
* | [--->] IT_JERRY                       TYPE        OBL_T_LINK
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method COMPARE_LINK.
    CHECK lines( it_bp ) = lines( it_jerry ).

    LOOP AT it_bp ASSIGNING FIELD-SYMBOL(<bp>).
       READ TABLE it_jerry ASSIGNING FIELD-SYMBOL(<jerry>) WITH KEY brelguid = <bp>-brelguid.
       IF sy-subrc <> 0.
          RETURN.
       ENDIF.

       IF <bp>-instid_a <> <jerry>-instid_a OR <bp>-instid_b <> <jerry>-instid_b
          OR <bp>-utctime <> <jerry>-utctime.
          RETURN.
       ENDIF.
    ENDLOOP.

    rv_equal = abap_true.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->COMPARE_READ_RESULT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ORIGIN                      TYPE        CRMT_ODATA_TASK_ATTACHMENTT
* | [--->] IT_JERRY                       TYPE        CRMT_ODATA_TASK_ATTACHMENTT
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method COMPARE_READ_RESULT.
    CHECK lines( it_origin ) = lines( it_jerry ).

    LOOP AT it_origin ASSIGNING FIELD-SYMBOL(<origin>).
      READ TABLE it_jerry ASSIGNING FIELD-SYMBOL(<jerry>) WITH KEY
        documentid = <origin>-documentid.

      IF <jerry> <> <origin>.
         RETURN.
      ENDIF.
    ENDLOOP.

    rv_equal = abap_true.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->COMPARE_TASK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TASK1                       TYPE        ZCRM_TASK_ATTACHMENT_T
* | [--->] IT_TASK2                       TYPE        ZCRM_TASK_ATTACHMENT_T
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method COMPARE_task.
    LOOP AT it_task1 ASSIGNING FIELD-SYMBOL(<task1>).
       READ TABLE it_task2 ASSIGNING FIELD-SYMBOL(<task2>) WITH KEY header_guid = <task1>-header_guid.
       IF sy-subrc <> 0.
          RETURN.
       ENDIF.

       LOOP AT <task1>-attachment ASSIGNING FIELD-SYMBOL(<atta1>).
          READ TABLE <task2>-attachment ASSIGNING FIELD-SYMBOL(<atta2>) WITH KEY
           documentid = <atta1>-documentid.

          IF sy-subrc <> 0.
             RETURN.
          ENDIF.

          IF <atta1>-created_by <> <atta2>-created_by.
            RETURN.
          ENDIF.

          IF <atta1>-name <> <atta2>-name.
             RETURN.
          ENDIF.
       ENDLOOP.
    ENDLOOP.

    rv_equal = abap_true.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->COMPARE_VALUE_REF
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method COMPARE_VALUE_REF.
    DATA: ls_result TYPE tadir,
          lv_num TYPE int4 value 1000.

    start( ).
    DO lv_num TIMES.
       pass_by_ref( IMPORTING es_result = ls_result ).
    ENDDO.
    stop( 'Pass by reference: ' ).

    start( ).
    DO lv_num TIMES.
       ls_result = pass_by_value( ).
    ENDDO.
    stop( 'Pass by value: ' ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CONSTRUCTOR.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->CREATE_DOC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TEXT                        TYPE        STRING
* | [--->] IV_BOR_TYPE                    TYPE        STRING
* | [--->] IV_GUID                        TYPE        CRMT_OBJECT_GUID
* | [--->] IV_FILE_NAME                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CREATE_DOC.
    DATA:ls_bo              TYPE sibflporb,
         ls_prop            TYPE LINE OF sdokproptys,
         lt_prop            TYPE sdokproptys,
         lt_properties_attr TYPE crmt_attr_name_value_t,
         ls_file_info       TYPE sdokfilaci,
         lt_file_info       TYPE sdokfilacis,
         lt_file_content    TYPE sdokcntbins,
         lv_length          TYPE i,
         lv_file_xstring    TYPE xstring,
         ls_loio            TYPE skwf_io,
         ls_phio            TYPE skwf_io,
         ls_error           TYPE skwf_error.

    ls_prop-name = 'DESCRIPTION'.
    ls_prop-value = 'created by Tool'.
    APPEND ls_prop TO lt_prop.

    ls_prop-name = 'KW_RELATIVE_URL'.
    ls_prop-value = iv_file_name.
    APPEND ls_prop TO lt_prop.

    ls_prop-name = 'LANGUAGE'.
    ls_prop-value = sy-langu.
    APPEND ls_prop TO lt_prop.

    CALL FUNCTION 'ECATT_CONV_STRING_TO_XSTRING'
       EXPORTING
          IM_STRING = iv_text
       IMPORTING
          EX_XSTRING = lv_file_xstring.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_file_xstring
      IMPORTING
        output_length = lv_length
      TABLES
        binary_tab    = lt_file_content.

    ls_file_info-binary_flg = 'X'.
    ls_file_info-file_name = iv_file_name.
    ls_file_info-file_size = lv_length.
    ls_file_info-mimetype = 'text/html'."'image/jpeg'.
    APPEND ls_file_info TO lt_file_info.

    ls_bo-INSTID = iv_guid.
    ls_bo-typeid = iv_bor_type.
    ls_bo-catid = 'BO'.

    CALL METHOD cl_crm_documents=>create_with_table
      EXPORTING
        business_object     = ls_bo
        properties          = lt_prop
        properties_attr     = lt_properties_attr
        file_access_info    = lt_file_info
        file_content_binary = lt_file_content
        raw_mode            = 'X'
      IMPORTING
        loio                = ls_loio
        phio                = ls_phio
        error               = ls_error.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->DYNAMIC_FILL_APPROACH1
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_TABLE                       TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD dynamic_fill_approach1.
    DATA: lr_ref     TYPE REF TO data,
          ls_task    TYPE crmt_odata_attachment,
          ls_bp      TYPE crmt_bp_odata_attachment,
          lt_task    TYPE crmt_odata_attachment_t,
          lv_is_task TYPE abap_bool VALUE abap_true,
          lt_bp      TYPE crmt_bp_odata_attachment_t.

    FIELD-SYMBOLS: <detect> TYPE zcrm_task_attachment_t,
                   <task_t> TYPE crmt_odata_attachment_t,
                   <bp_t>   TYPE crmt_bp_odata_attachment_t.

    GET REFERENCE OF ct_table INTO lr_ref.
    TRY.
        ASSIGN lr_ref->* TO <detect> CASTING.
      CATCH cx_root.
        lv_is_task = abap_false.
    ENDTRY.

    LOOP AT ct_table ASSIGNING FIELD-SYMBOL(<task_item>).
      IF lv_is_task = abap_true.
        ASSIGN COMPONENT 'ATTACHMENT' OF STRUCTURE <task_item> TO <task_t>.
      ls_task-name = sy-index.
      ls_task-created_by = sy-uname.
      ls_task-mime_type = 'text/html'.
      ls_task-documentid = ls_task-header_guid = get_guid_by_index( sy-tabix ).
      APPEND ls_task TO <task_t>.
      ELSE.
        ASSIGN COMPONENT 'ATTACHMENT' OF STRUCTURE <task_item> TO <bp_t>.
        ls_bp-name = sy-index.
        ls_bp-created_by = sy-uname.
        ls_bp-mime_type = 'text/html'.
        ls_bp-documentid = get_guid_by_index( sy-tabix ).
        APPEND ls_bp TO <bp_t>.
      ENDIF.
    ENDLOOP.
*    DO iv_num TIMES.
*
*      IF <task_t> IS ASSIGNED.
*        CLEAR: ls_task.
*        ls_task-name = sy-index.
*        ls_task-created_by = sy-uname.
*        ls_task-mime_type = 'text/html'.
*        ls_task-documentid = ls_task-header_guid = get_guid_by_index( sy-index ).
** Jerry 2016-01-29 15:10PM this is used to simulate that every task has an internal table
** to store multiple attachments
*        APPEND ls_task TO lt_task.
*        APPEND LINES OF lt_task TO <task_t>.
*      ELSE.
*        CLEAR: lt_bp.
*        ls_bp-name = sy-index.
*        ls_bp-created_by = sy-uname.
*        ls_bp-mime_type = 'text/html'.
*        ls_bp-documentid = get_guid_by_index( sy-index ).
*        APPEND ls_bp TO lt_bp.
*        APPEND LINES OF lt_bp TO <bp_t>.
*      ENDIF.
*    ENDDO.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->DYNAMIC_FILL_APPROACH2
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_TABLE                       TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD dynamic_fill_approach2.
    DATA:lr_attachment TYPE REF TO data,
         ls_task       TYPE crmt_odata_attachment,
         lt_task       TYPE crmt_odata_attachment_t.

    FIELD-SYMBOLS: <task_t>   TYPE crmt_odata_attachment_t,
                   <result>   TYPE ANY TABLE,
                   <att_data> TYPE ANY TABLE.

    CREATE DATA lr_attachment LIKE lt_task.
    ASSIGN lr_attachment->* TO <att_data>.

    LOOP AT ct_table ASSIGNING FIELD-SYMBOL(<task_item>).
      ASSIGN COMPONENT 'ATTACHMENT' OF STRUCTURE <task_item> TO <result>.
      CLEAR: lt_task.
      ls_task-name = sy-index.
      ls_task-created_by = sy-uname.
      ls_task-mime_type = 'text/html'.
      ls_task-documentid = ls_task-header_guid = get_guid_by_index( sy-tabix ).
      APPEND ls_task TO lt_task.
* Jerry 2016-01-29 15:10PM this is used to simulate that every task has an internal table
* to store multiple attachments
      <att_data> = lt_task.
      MOVE-CORRESPONDING <att_data> TO <result>.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_ATTACHMENT_TOOL->GENERATE_TEST_GUID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NUM                         TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD generate_test_guid.
    DATA: lv_guid TYPE crmt_object_guid.
    DO iv_num TIMES.
      CALL FUNCTION 'SYSTEM_UUID_CREATE'
        IMPORTING
          uuid = lv_guid.
      INSERT lv_guid INTO TABLE mt_guid_for_test.
    ENDDO.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_ATTACHMENT_TOOL->GET_ALL_IOS_WITH_PROPERTIES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_LINKS                       TYPE        OBL_T_LINK
* | [<---] ET_PROPERTY_RESULT             TYPE        CRM_KW_PROPST
* | [<---] ET_FILE_ACCESS_INFO            TYPE        SKWF_CPPRPS
* | [<---] ET_IP_LINKS                    TYPE        SDOKLOGPHYS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_all_ios_with_properties.

    DATA: lt_ios                  TYPE skwf_ios,
          lt_ios_auth             LIKE lt_ios,
          ls_ios                  LIKE LINE OF lt_ios,
          lt_loios                TYPE skwf_ios,
          lt_folders              TYPE TABLE OF skwf_io,
          ls_sdok_io              TYPE sdokobject,
          lt_sdok_loios           TYPE TABLE OF sdokobject,
          lt_phios                TYPE TABLE OF skwf_io,
          lt_phioloios            TYPE skwf_lpios,
          ls_ios_file_access_info TYPE skwf_cpprp.

    FIELD-SYMBOLS: <link>                 TYPE LINE OF obl_t_link,
                   <order_att_link>       LIKE LINE OF mt_order_atta_link,
                   <io>                   LIKE LINE OF lt_ios,
                   <phio>                 TYPE sdoklogphy,
                   <phiolo>               LIKE LINE OF lt_phioloios.

    LOOP AT it_links ASSIGNING <link>.
      ls_ios = get_ios_by_key( <link>-instid_b ).
      APPEND ls_ios TO lt_ios.

      APPEND INITIAL LINE TO mt_order_atta_link ASSIGNING <order_att_link>.
      <order_att_link>-order_guid = <link>-instid_a.
      <order_att_link>-order_bortype = <link>-typeid_a.
      <order_att_link>-atta_type = ls_ios-objtype.
      <order_att_link>-attid_lo = ls_ios-objid.
    ENDLOOP.

    CALL FUNCTION 'SKWF_AUTH_OBJECTS_CHECK'
      EXPORTING
        activity     = '03'
      TABLES
        objects      = lt_ios
        objects_auth = lt_ios_auth.

    lt_ios = lt_ios_auth.

    LOOP AT lt_ios ASSIGNING <io>.
      CASE <io>-objtype.
        WHEN 'L'.
          APPEND <io> TO lt_loios.
        WHEN 'F'.
          APPEND <io> TO lt_folders.
      ENDCASE.
    ENDLOOP.

*   I042416: 1. For all folders: read all documents in subtree
*   2.adjust ID-mapping (currently order_guid<->folder key are present in mapping and need
*   to be replaced by objid of single document)

    IF lt_folders IS NOT INITIAL.
      handle_folder( EXPORTING it_folders = lt_folders CHANGING ct_loios = lt_loios ).
    ENDIF.

*   Now get all phios (property-records, object-type "P") to all loios
*   (object-type "L")
    SORT mt_order_atta_link BY attid_lo.
    LOOP AT lt_loios ASSIGNING <io>.
      ls_sdok_io = <io>-object.
      APPEND ls_sdok_io TO lt_sdok_loios.
    ENDLOOP.
    CALL FUNCTION 'SDOK_LOIOS_PHIOS_GET'
      EXPORTING
        x_reduce_to_one  = 'X'
      TABLES
        object_list      = lt_sdok_loios
        physical_objects = et_ip_links.

    LOOP AT et_ip_links ASSIGNING <phio>.

      APPEND INITIAL LINE TO lt_phios ASSIGNING <io>.
      <io>-class  = <phio>-class_ph.
      <io>-objid  = <phio>-objid_ph.
      <io>-objtype = 'P'.

      APPEND INITIAL LINE TO lt_phioloios ASSIGNING <phiolo>.
      <phiolo>-classph   = <phio>-class_ph.
      <phiolo>-objidph   = <phio>-objid_ph.
      <phiolo>-objtypeph = 'P'.
      <phiolo>-classlo   = <phio>-class_lo.
      <phiolo>-objidlo   = <phio>-objid_lo.
      <phiolo>-objtypelo = 'L'.
    ENDLOOP.

    APPEND LINES OF lt_loios TO lt_ios.
    APPEND LINES OF lt_phios TO lt_ios.

    CALL FUNCTION 'CRM_KW_PROPERTIES_GET'
      EXPORTING
        ios                   = lt_ios
      IMPORTING
        ios_properties_result = et_property_result.

    LOOP AT lt_phios INTO ls_ios_file_access_info-io WHERE class <> 'CRM_P_URL'.
      APPEND ls_ios_file_access_info TO et_file_access_info.
    ENDLOOP.

    CALL FUNCTION 'SKWF_PHIOS_FILE_PROPERTIES_GET'
      TABLES
        components = et_file_access_info.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->GET_ATTACHMENTS_BY_BP_WAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OBJECTS                     TYPE        LTTY_OBJECT_KEY
* | [<-()] RT_LINKS_A                     TYPE        OBL_T_LINK
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD GET_ATTACHMENTS_BY_BP_WAY.
    DATA:
      lt_business_objects TYPE sibflporbt,
      ls_relation_option  TYPE obl_s_relt,
      ls_business_object  TYPE sibflporb,
      lt_relation_options TYPE obl_t_relt.

    FIELD-SYMBOLS: <ls_object>  TYPE lty_object_key.

    DATA(lo_tool) = NEW cl_crm_bp_odata_rt_attachment( ).

    ls_business_object-catid = 'BO'.

    LOOP AT it_objects ASSIGNING <ls_object>.
      ls_business_object-instid = <ls_object>-instid.
      ls_business_object-typeid = <ls_object>-typeid.
      APPEND ls_business_object TO lt_business_objects.
    ENDLOOP.

    ls_relation_option-option = 'EQ'.
    ls_relation_option-sign = 'I'.
    ls_relation_option-low = 'WCM_LINK'.
    APPEND ls_relation_option TO lt_relation_options.

    CALL METHOD lo_tool->read_links_of_objects
      EXPORTING
        it_objects          = lt_business_objects
        it_relation_options = lt_relation_options
      IMPORTING
        et_links_a          = rt_links_a.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->GET_ATTACHMENTS_BY_JERRY_WAY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OBJECTS                     TYPE        LTTY_OBJECT_KEY
* | [<-()] RT_ATTACHMENTS                 TYPE        CRMT_ODATA_TASK_ATTACHMENTT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_attachments_by_jerry_way.

    DATA: lt_links            TYPE obl_t_link,
          lt_ios              TYPE skwf_ios,
          lt_iplinks          TYPE sdoklogphys,
          lt_property_result  TYPE crm_kw_propst,
          lt_file_access_info TYPE skwf_cpprps.

    lt_links = get_links( it_objects ).

    CALL METHOD get_all_ios_with_properties
      EXPORTING
        it_links            = lt_links
      IMPORTING
        et_property_result  = lt_property_result
        et_file_access_info = lt_file_access_info
        et_ip_links         = lt_iplinks.

************* assemble
    FIELD-SYMBOLS: <property_result>  LIKE LINE OF lt_property_result,
                   <order_att_link>   LIKE LINE OF mt_order_atta_link,
                   <file_access_info> LIKE LINE OF lt_file_access_info,
                   <ip_link>          LIKE LINE OF lt_iplinks.

    DATA: ls_attachment TYPE crmt_odata_task_attachment,
          ls_property   TYPE sdokproptl,
          lv_username   TYPE bapibname-bapibname.

    LOOP AT lt_property_result ASSIGNING <property_result> WHERE objtype = 'P'.
      CLEAR: ls_attachment.
      READ TABLE lt_iplinks ASSIGNING <ip_link> WITH KEY objid_ph = <property_result>-objid.
      ASSERT sy-subrc = 0.
      READ TABLE mt_order_atta_link ASSIGNING <order_att_link> WITH KEY
         attid_lo = <ip_link>-objid_lo.
      ASSERT sy-subrc = 0.
      ls_attachment-header_guid = <order_att_link>-order_guid.
      ls_attachment-documentid = <property_result>-objid.
      ls_attachment-documentclass = <property_result>-class.

      READ TABLE lt_file_access_info WITH KEY objtype = <property_result>-objtype
          class = <property_result>-class objid = <property_result>-objid
          ASSIGNING <file_access_info>.
      IF sy-subrc = 0. " not an url
        ls_attachment-mime_type     = <file_access_info>-mimetype.
      ENDIF.
      READ TABLE <property_result>-properties WITH KEY name = 'KW_RELATIVE_URL' INTO ls_property. "#EC *
      IF sy-subrc = 0.
        ls_attachment-name = ls_property-value.
      ENDIF.

      READ TABLE <property_result>-properties WITH KEY name = 'CREATED_AT' INTO ls_property. "#EC *
      IF sy-subrc = 0.
        ls_attachment-created_at = ls_property-value.
      ENDIF.

      READ TABLE <property_result>-properties WITH KEY name = 'CREATED_BY' INTO ls_property. "#EC *
      IF sy-subrc = 0.
        lv_username = ls_property-value.
        ls_attachment-created_by = get_created_by( lv_username ).
      ENDIF.

      IF <property_result>-class = crmkw_class-phio_url.
         ls_attachment-url = get_url( is_properties = <property_result> ).
      ENDIF.
      ls_attachment-typeid = <order_att_link>-order_bortype.
      ls_attachment-instid = <order_att_link>-order_guid.

      APPEND ls_attachment TO rt_attachments.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->GET_ATTACHMENTS_ORIGIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OBJECTS                     TYPE        LTTY_OBJECT_KEY
* | [<-()] RT_ATTACHMENTS                 TYPE        CRMT_ODATA_TASK_ATTACHMENTT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_attachments_origin.
    DATA: lt_key_tab TYPE /iwbep/t_mgw_name_value_pair,
          ls_expand  TYPE crmt_odata_task_hdr_expanded.

    DATA(lo_tool) = NEW cl_crm_task_rt( ).

    LOOP AT it_objects ASSIGNING FIELD-SYMBOL(<object>).
      CLEAR: lt_key_tab, ls_expand.

      DATA(ls_key) = VALUE /iwbep/s_mgw_name_value_pair( name = 'Guid'
        value = <object>-instid ).

      APPEND ls_key TO lt_key_tab.
      CALL METHOD lo_tool->get_task_attachments
        EXPORTING
          iv_entity_name     = space
          iv_entity_set_name = space
          iv_source_name     = space
          it_key_tab         = lt_key_tab
        IMPORTING
          et_task_expanded   = ls_expand.

      APPEND LINES OF ls_expand-attachments TO rt_attachments.
    ENDLOOP.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->GET_ATTACHMENT_BY_TASK_GUID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TASK_GUID                   TYPE        CRMT_OBJECT_GUID
* | [<-()] RT_TASK_EXPAND                 TYPE        CRMT_ODATA_TASK_HDR_EXPANDED
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_attachment_by_task_guid.
    DATA: lt_key_tab TYPE /iwbep/t_mgw_name_value_pair.

    DATA(lo_tool) = NEW cl_crm_task_rt( ).
    DATA(ls_key) = VALUE /iwbep/s_mgw_name_value_pair( name = 'Guid' value = iv_task_guid ).
    APPEND ls_key TO lt_key_tab.
    CALL METHOD lo_tool->get_task_attachments
      EXPORTING
        iv_entity_name     = space
        iv_entity_set_name = space
        iv_source_name     = space
        it_key_tab         = lt_key_tab
      IMPORTING
        et_task_expanded   = rt_task_expand.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_ATTACHMENT_TOOL->GET_CREATED_BY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_USER_NAME                   TYPE        BAPIBNAME-BAPIBNAME
* | [<-()] RV_FULLNAME                    TYPE        AD_NAMTEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_created_by.
    DATA: ls_bupa_addr TYPE bapiaddr3,
          lt_return    TYPE bapirettab.

    FIELD-SYMBOLS: <user_name> TYPE ty_user_name.
    READ TABLE mt_user_name ASSIGNING <user_name> WITH KEY user_name = iv_user_name.
    IF sy-subrc = 0.
      rv_fullname = <user_name>-fullname.
      RETURN.
    ENDIF.

    APPEND INITIAL LINE TO mt_user_name ASSIGNING <user_name>.

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username = iv_user_name
      IMPORTING
        address  = ls_bupa_addr
      TABLES
        return   = lt_return.

    <user_name>-user_name = iv_user_name.
    IF ls_bupa_addr-fullname IS INITIAL.
      ls_bupa_addr-fullname = iv_user_name.
    ENDIF.
    rv_fullname = <user_name>-fullname = ls_bupa_addr-fullname.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_ATTACHMENT_TOOL->GET_GUID_BY_INDEX
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INDEX                       TYPE        SYINDEX
* | [<-()] RV_GUID                        TYPE        CRMT_OBJECT_GUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_GUID_BY_INDEX.
     READ TABLE mt_guid_For_test INTO rv_guid INDEX iv_index.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->GET_IOS_BY_KEY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_KEY                         TYPE        SIBFBORIID
* | [<-()] RS_IOS                         TYPE        SKWF_IO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_IOS_BY_KEY.
    FIND REGEX '([FLP])/([\w]+)/([\w]+)' IN iv_key SUBMATCHES
       rs_ios-objtype rs_ios-class rs_ios-objid.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_ATTACHMENT_TOOL->GET_LINKS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OBJECTS                     TYPE        LTTY_OBJECT_KEY
* | [<-()] RT_LINKS_A                     TYPE        OBL_T_LINK
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_links.
    DATA: lv_bor_type TYPE sibftypeid.
    FIELD-SYMBOLS: <object> LIKE LINE OF it_objects.

    CHECK it_objects IS NOT INITIAL.

    READ TABLE it_objects ASSIGNING <object> INDEX 1.

    lv_bor_type = <object>-typeid.
    SELECT instid_a typeid_a  instid_b typeid_b  catid_b utctime
            INTO CORRESPONDING FIELDS OF TABLE rt_links_a FROM skwg_brel
             FOR ALL ENTRIES IN it_objects
             WHERE instid_a  = it_objects-instid AND
                   typeid_a      = lv_bor_type AND
                   catid_a  = 'BO' AND
                   reltype  = 'WCM_LINK'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->GET_STORAGE_BY_FM
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_storage_by_fm.
    DATA: ls_key TYPE skwf_key,
          ls_io  TYPE skwf_io.

    ls_key-key_text = 'L/CRM_L_ORD/FA163EE56C3A1EE5AFCAF9FF31FFFE64'.

    start( ).
    DO mv_regular_test_num TIMES.
      CALL FUNCTION 'SKWF_UTIL_IO_FIND_BY_KEY'
        EXPORTING
          key = ls_key
        IMPORTING
          io  = ls_io.
    ENDDO.

    stop( 'Function call performance with testing loop number: ' && mv_regular_test_num ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->GET_STORAGE_BY_REGULAR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_storage_by_regular.
    DATA: lv_input TYPE string VALUE 'L/CRM_L_ORD/FA163EE56C3A1EE5AFCAF9FF31FFFE64',
          lv_type  TYPE skwf_ioty,
          lv_class TYPE sdok_class,
          lv_guid  TYPE sdok_docid.

    start( ).
    DO mv_regular_test_num TIMES.
       FIND REGEX '([FLP])/([\w]+)/([\w]+)$' IN lv_input SUBMATCHES lv_type lv_class lv_guid.
    ENDDO.
    stop( 'Regular expression performance with testing loop number: ' && mv_regular_test_num ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->GET_TESTDATA
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATA                        TYPE        CRMT_OBJECT_KEY_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_TESTDATA.
    DATA: lt_guid TYPE STANDARD TABLE OF ztask_with_follo.

    SELECT * INTO TABLE lt_guid FROM ztask_with_follo.

    FIELD-SYMBOLS: <item> LIKE LINE OF mt_bp_test_data.

    LOOP AT lt_guid ASSIGNING FIELD-SYMBOL(<guid>).
       APPEND INITIAL LINE TO mt_bp_test_data ASSIGNING <item>.
       <item>-typeid = 'BUS2000125'.
       <item>-instid = <guid>-task_guid .
    ENDLOOP.

    APPEND INITIAL LINE TO mt_bp_test_data ASSIGNING FIELD-SYMBOL(<item1>).
    <item1>-typeid = 'BUS2000125'.
    <item1>-instid = 'FA163EE56C3A1ED5AE9AE011B059611E'.

    APPEND INITIAL LINE TO mt_bp_test_data ASSIGNING FIELD-SYMBOL(<seconditem>).
    <seconditem>-instid = 'FA163EE56C3A1EE5AD89008F1DBB0B45'.

    rt_data = MT_BP_TEST_DATA.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_ATTACHMENT_TOOL->GET_URL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_PROPERTIES                  TYPE        CRM_KW_PROPS
* | [<-()] RV_URL                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_url.
    DATA: lt_url TYPE sdokcompurls.

    FIELD-SYMBOLS:<url> TYPE sdokcomurl.

    CALL FUNCTION 'SDOK_PHIO_GET_URL_FOR_GET'
      EXPORTING
        object_id                  = is_properties-object
        web_applic_server_url_only = 'X'
      IMPORTING
        urls                       = lt_url
      EXCEPTIONS
        not_existing               = 1
        not_authorized             = 2
        no_content                 = 3
        bad_storage_type           = 4
        no_urls_available          = 5
        OTHERS                     = 6.

    IF sy-subrc <> 0.
      CLEAR rv_url.
      RETURN.
    ENDIF.

    READ TABLE lt_url ASSIGNING <url> INDEX 1.
    rv_url = <url>-url.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_ATTACHMENT_TOOL->HANDLE_FOLDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_FOLDERS                     TYPE        SKWF_IOS
* | [<-->] CT_LOIOS                       TYPE        SKWF_IOS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_folder.
    DATA: lt_ios        TYPE skwf_ios,
          lv_order_guid TYPE ty_order_atta_link-order_guid,
          lv_order_type TYPE ty_order_atta_link-order_bortype.

    FIELD-SYMBOLS: <folder>               LIKE LINE OF it_folders,
                   <io>                   LIKE LINE OF lt_ios,
                   <order_att_link>       LIKE LINE OF mt_order_atta_link,
                   <link_for_folder_file> LIKE <order_att_link>.

    LOOP AT it_folders ASSIGNING <folder>.
      CLEAR: lt_ios.
      READ TABLE mt_order_atta_link ASSIGNING <order_att_link>
        WITH KEY attid_lo = <folder>-objid.
      ASSERT sy-subrc = 0.
      lv_order_guid = <order_att_link>-order_guid.
      lv_order_type = <order_att_link>-order_bortype.

      CALL FUNCTION 'SKWF_FOLDER_SUB_IOS_GET'
        EXPORTING
          folder     = <folder>
          io_type    = 'L'
          x_attached = 'X'
          x_linked   = 'X'
          x_hidden   = 'X'
        TABLES
          ios        = lt_ios.
      LOOP AT lt_ios ASSIGNING <io>.
*         Remove mapping-record Order<->Folder (only one time)
        AT FIRST.
          DELETE mt_order_atta_link WHERE attid_lo = <order_att_link>-attid_lo.
        ENDAT.

        IF <io>-objtype = 'L'.
          APPEND <io> TO ct_loios.
* I042416: construct link between one order and attachment which is NESTED in the folder
          APPEND INITIAL LINE TO mt_order_atta_link ASSIGNING <link_for_folder_file>.
          <link_for_folder_file>-atta_type = <io>-objtype.
          <link_for_folder_file>-attid_lo = <io>-objid.
          <link_for_folder_file>-order_guid = lv_order_guid.
          <link_for_folder_file>-order_bortype = lv_order_type.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->PARALLEL_READ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GROUP_NUMBER                TYPE        INT4
* | [--->] IT_ORDERS                      TYPE        LTTY_OBJECT_KEY
* | [<-()] RT_ATTACHMENTS                 TYPE        CRMT_ODATA_TASK_ATTACHMENTT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD parallel_read.
    DATA:lv_taskid     TYPE c LENGTH 8,
         lv_index      TYPE c LENGTH 4,
         lt_attachment TYPE crmt_odata_task_attachmentt.

    DO iv_group_number TIMES.
      lv_index = sy-index.
      lv_taskid = 'Task' && lv_index.

      CLEAR: lt_attachment.
      CALL FUNCTION 'ZJERRYGET_ATTACHMENTS'
        STARTING NEW TASK lv_taskid
        CALLING read_finished ON END OF TASK
        EXPORTING
          it_objects     = it_orders.
    ENDDO.

    WAIT UNTIL mv_finished = iv_group_number.

    rt_attachments = mt_attachment_result.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->PASS_BY_REF
* +-------------------------------------------------------------------------------------------------+
* | [<---] ES_RESULT                      TYPE        TADIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method PASS_BY_REF.
    CLEAR: es_result.

    es_result-obj_name = 'ZJERRY'.
    es_result-author = 'WANGJER'.
    es_result-devclass = '$TMP'.
    es_result-object = 'CLAS'.
    es_result-cproject = 'TEST'.
    es_result-component = 'CSS'.
    es_result-created_on = '20110111'.
    es_result-masterlang = 'EN'.
    es_result-srcsystem = 'AG3'.
    es_result-pgmid = 'R3TR'.


  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->PASS_BY_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_RESULT                      TYPE        TADIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method PASS_BY_VALUE.
    CLEAR: rs_result.

    rs_result-obj_name = 'ZJERRY'.
    rs_result-author = 'WANGJER'.
    rs_result-devclass = '$TMP'.
    rs_result-object = 'CLAS'.
    rs_result-cproject = 'TEST'.
    rs_result-component = 'CSS'.
    rs_result-created_on = '20110111'.
    rs_result-masterlang = 'EN'.
    rs_result-srcsystem = 'AG3'.
    rs_result-pgmid = 'R3TR'.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->PREFILL_ATTACHMENT_TAB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NUM                         TYPE        INT4
* | [<-->] CT_BP1                         TYPE        ZCRM_BP_ATTACHMENT_T
* | [<-->] CT_BP2                         TYPE        ZCRM_BP_ATTACHMENT_T
* | [<-->] CT_TASK1                       TYPE        ZCRM_TASK_ATTACHMENT_T
* | [<-->] CT_TASK2                       TYPE        ZCRM_TASK_ATTACHMENT_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method PREFILL_ATTACHMENT_TAB.
    generate_test_guid( iv_num ).

    DO iv_num TIMES.
       DATA(lv_guid) = get_guid_by_index( sy-index ).
       APPEND INITIAL LINE TO ct_bp1 ASSIGNING FIELD-SYMBOL(<bp1>).
       <bp1>-header_guid = lv_guid.

       APPEND INITIAL LINE TO ct_bp2 ASSIGNING FIELD-SYMBOL(<bp2>).
       <bp2>-header_guid = lv_guid.

       APPEND INITIAL LINE TO ct_task1 ASSIGNING FIELD-SYMBOL(<task1>).
       <task1>-header_guid = lv_guid.

       APPEND INITIAL LINE TO ct_task2 ASSIGNING FIELD-SYMBOL(<task2>).
       <task2>-header_guid = lv_guid.
    ENDDO.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->READ_FINISHED
* +-------------------------------------------------------------------------------------------------+
* | [--->] P_TASK                         TYPE        CLIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD read_finished.
    DATA: lt_attachment TYPE crmt_odata_task_attachmentt.

    ADD 1 TO mv_finished.
    RECEIVE RESULTS FROM FUNCTION 'ZJERRYGET_ATTACHMENTS'
    CHANGING
      ct_attachments              = lt_attachment
    EXCEPTIONS
      system_failure        = 1
      communication_failure = 2.

    APPEND LINES OF lt_attachment TO mt_attachment_result.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->SEQUENTIAL_READ
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LOOP_TIME                   TYPE        INT4
* | [--->] IT_ORDERS                      TYPE        LTTY_OBJECT_KEY
* | [<-()] RT_ATTACHMENTS                 TYPE        CRMT_ODATA_TASK_ATTACHMENTT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method SEQUENTIAL_READ.
    DATA: lt_attachment LIKE rt_attachments.

    DO iv_loop_time TIMES.
       CLEAR: lt_attachment.

       lt_attachment = get_attachments_origin( it_orders ).
       APPEND LINES OF lt_attachment TO rt_attachments.
    ENDDO.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->START
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method START.
    GET RUN TIME FIELD mv_start.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ATTACHMENT_TOOL->STOP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MESSAGE                     TYPE        STRING(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method STOP.
    GET RUN TIME FIELD mv_end.

    mv_end = mv_end - mv_start.

    DATA: lv_text TYPE string.

    IF iv_message IS SUPPLIED.
       lv_text = iv_message.
    ENDIF.

    lv_text = lv_text && ' consumed time: ' && mv_end.

    WRITE: / lv_text COLOR COL_NEGATIVE.
  endmethod.
ENDCLASS.