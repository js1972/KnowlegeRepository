class ZCL_CRM_TASK_DOC_HISTORY_TOOL definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods GET_HISTORIES_ORIGIN
    importing
      !IT_TASK_GUIDS type CRMT_OBJECT_GUID_TAB_UNSORTED
    returning
      value(RT_DOC_LINKS) type CRMT_DOC_FLOW_DB_WRKT .
  methods GET_HISTORIES_WITH_NUMBER
    returning
      value(RT_DOC_LINKS) type CRMT_DOC_FLOW_DB_WRKT .
  methods GET_HISTORIES_OPT
    importing
      !IT_TASK_GUIDS type SWO_TYPEID_LIST
    returning
      value(RT_DOC_LINKS) type CRMT_DOC_FLOW_LINK .
  methods COMPARE
    importing
      !IT_ORIGIN type CRMT_DOC_FLOW_DB_WRKT
      !IT_OPT type CRMT_DOC_FLOW_LINK
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods START .
  methods STOP .
  methods GENERATE_TASKS
    importing
      !IV_NUM type INT4
    returning
      value(RT_CREATED_GUIDS) type CRMT_OBJECT_GUID_TAB .
  methods LINK
    importing
      !IT_TASK_GUIDS type CRMT_OBJECT_GUID_TAB .
  methods GET_WHOLE_ORIGINAL
    importing
      !IT_TASK_GUIDS type CRMT_OBJECT_GUID_TAB
    returning
      value(RT_RESULT) type CRMT_ODATA_DOC_HISTORY_T .
  methods GET_WHOLE_OPT
    importing
      !IT_TASK_GUIDS type CRMT_OBJECT_GUID_TAB
    changing
      !CT_ENTITYSET type ZCRMT_JERRY_DOC_HISTORY_T .
  methods COMPARE_HISTORY
    importing
      !IT_RESULT_ORIGIN type CRMT_ODATA_DOC_HISTORY_T
      !IT_RESULT_OPT type ZCRMT_JERRY_DOC_HISTORY_T
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods PRINT_HISTORY
    importing
      !IT_HISTORY type ZCRMT_JERRY_DOC_HISTORY_T .
  methods COMPARE_100
    returning
      value(RV_EQUAL) type ABAP_BOOL .
  methods COMPARE_ORDER_READ .
protected section.
private section.

  data MT_GUID_TABS type CRMT_OBJECT_GUID_TAB_UNSORTED .
  data MV_START type I .
  data MV_STOP type I .
  data MV_NUMBER_RANGE type I value 1 ##NO_TEXT.

  methods GET_NUMBER_RANGE
    returning
      value(RV_RESULT) type I .
ENDCLASS.



CLASS ZCL_CRM_TASK_DOC_HISTORY_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->COMPARE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ORIGIN                      TYPE        CRMT_DOC_FLOW_DB_WRKT
* | [--->] IT_OPT                         TYPE        CRMT_DOC_FLOW_LINK
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method COMPARE.
    rv_equal = abap_false.
    CHECK lines( it_origin ) = lines( it_opt ).

    LOOP AT it_origin ASSIGNING FIELD-SYMBOL(<origin>).
      READ TABLE it_opt ASSIGNING FIELD-SYMBOL(<opt>) WITH KEY objkey_a = <origin>-objkey_a
       objkey_b = <origin>-objkey_b.
      IF sy-subrc <> 0.
         RETURN.
      ENDIF.
    ENDLOOP.

    rv_equal = abap_true.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->COMPARE_100
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare_100.
    DATA: lt_task    TYPE crmt_object_guid_tab,
          lt_result1 TYPE crmt_odata_doc_history_t,
          lt_result2 TYPE zcrmt_jerry_doc_history_t,
          lv_equal   TYPE abap_bool.

    SELECT task_guid INTO TABLE lt_task FROM ztask_with_follo.
    lt_result1 = get_whole_original( lt_task ).

    get_whole_opt( EXPORTING it_task_guids = lt_task CHANGING ct_entityset = lt_result2 ).

    rv_equal = compare_history( it_result_origin = lt_result1 it_result_opt = lt_result2 ).

    "print_history( lt_result2 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->COMPARE_HISTORY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_RESULT_ORIGIN               TYPE        CRMT_ODATA_DOC_HISTORY_T
* | [--->] IT_RESULT_OPT                  TYPE        ZCRMT_JERRY_DOC_HISTORY_T
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method COMPARE_HISTORY.
    rv_equal = abap_false.

    CHECK lines( it_result_origin ) = lines( it_result_opt ).

    LOOP AT it_result_opt ASSIGNING FIELD-SYMBOL(<opt>).
      LOOP AT <opt>-documenthistories ASSIGNING FIELD-SYMBOL(<doc>).
         READ TABLE it_result_origin WITH KEY guid = <doc>-guid RELATIONSHIP = <doc>-relationship TRANSPORTING NO FIELDS.
         IF sy-subrc <> 0.
            RETURN.
         ENDIF.
      ENDLOOP.
    ENDLOOP.

    rv_equal = abap_true.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->COMPARE_ORDER_READ
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare_order_read.
    DATA: lt_guid              TYPE crmt_object_guid_tab,
          lt_orderadm_h        TYPE crmt_orderadm_h_wrkt,
          lt_orderadm_h_db     TYPE crmt_orderadm_h_du_tab,
          lt_requested_objects TYPE crmt_object_name_tab,
          lt_exception         TYPE  crmt_exception_t,
          ls_result1           TYPE CRMT_ODATA_DOC_HISTORY,
          ls_result2           TYPE CRMT_ODATA_DOC_HISTORY.

    CONSTANTS:  lc_orderadm_h    TYPE  crmt_object_name  VALUE 'ORDERADM_H'.

    SELECT guid INTO TABLE lt_guid FROM crmd_orderadm_h UP TO 2 ROWS.

    INSERT lc_orderadm_h INTO TABLE lt_requested_objects.

    WRITE: / 'CRM_ORDER_READ...'.
    me->start( ).
    CALL FUNCTION 'CRM_ORDER_READ'
      EXPORTING
        it_header_guid       = lt_guid
        it_requested_objects = lt_requested_objects
        iv_no_auth_check     = 'X'
      IMPORTING
        et_orderadm_h        = lt_orderadm_h
        et_exception         = lt_exception
      EXCEPTIONS
        document_not_found   = 1
        error_occurred       = 2
        document_locked      = 3
        no_change_authority  = 4
        no_display_authority = 5
        no_change_allowed    = 6
        OTHERS               = 7.
    stop( ).

    WRITE: / 'CRM_ORDERADM_H_SELECT_M_DB ...'.
    start( ).
    CALL FUNCTION 'CRM_ORDERADM_H_SELECT_M_DB'
      EXPORTING
        it_guid          = lt_guid
      IMPORTING
        et_orderadm_h_db = lt_orderadm_h_db
      EXCEPTIONS
        parameter_error  = 1
        record_not_found = 2
        OTHERS           = 3.
    stop( ).

    ASSERT lines( lt_orderadm_h ) = lines( lt_orderadm_h_db ).

    LOOP AT lt_orderadm_h ASSIGNING FIELD-SYMBOL(<origin>).
       READ TABLE lt_orderadm_h_db ASSIGNING FIELD-SYMBOL(<db>) WITH KEY guid = <origin>-guid.
       ASSERT sy-subrc = 0.
       MOVE-CORRESPONDING <origin> TO ls_result1.
       MOVE-CORRESPONDING <db> TO ls_result2.
       ASSERT ls_result1 = ls_result2.
    ENDLOOP.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CONSTRUCTOR.
*    append 'FA163EE56C3A1EE5AD89008F1DBB0B45' TO  mt_guid_tabs. "31318"
*    append 'FA163EE56C3A1EE5ADA0457B58202108' tO  mt_guid_tabs. "31331
*    append 'FA163EE56C3A1EE5A5E673B95A344AC5' TO  mt_guid_tabs. "29944
*    APPEND 'FA163EE56C3A1EE5AD8901590BA7CB46' TO mt_guid_tabs.  "31319
*    APPEND 'FA163EE56C3A1EE5ADA0AD5FB303C1DF' TO mt_guid_tabs.  "31332
*    APPEND 'FA163EE56C3A1EE5ADA0AE5AB83B01E1' TO mt_guid_Tabs.  "31333
*    append 'FA163EE56C3A1EE5ADA0D8608C98A232' TO mt_guid_tabs.  "31335
*    append 'FA163EE56C3A1EE5ADA0D92F87C10232' TO mt_guid_tabs.  "31336
    DATA: lt_guid TYPE STANDARD TABLE OF ztask_with_follo.

    SELECT * INTO TABLE lt_guid FROM ztask_with_follo.

    LOOP AT lt_guid ASSIGNING FIELD-SYMBOL(<guid>).
       INSERT <guid>-task_guid INTO TABLE mt_guid_tabs.
    ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->GENERATE_TASKS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NUM                         TYPE        INT4
* | [<-()] RT_CREATED_GUIDS               TYPE        CRMT_OBJECT_GUID_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD generate_tasks.
    DEFINE insert_field.
      ls_field-fieldname = &1.
      INSERT ls_field INTO TABLE ls_input_fields-field_names.
    END-OF-DEFINITION.

    DATA: lt_orderadm_h TYPE crmt_orderadm_h_comt,
          ls_orderadm_h LIKE LINE OF lt_orderadm_h.
    DATA: lt_activity_h TYPE crmt_activity_h_comt,
          ls_activity_h LIKE LINE OF lt_activity_h.
    DATA: lt_partner      TYPE crmt_partner_comt,
          ls_partner      LIKE LINE OF lt_partner,
          lv_partner_key1 LIKE ls_partner-ref_partner_handle,
          lv_partner_key2 LIKE lv_partner_key1.
    DATA: lt_appointment TYPE crmt_appointment_comt,
          ls_appointment LIKE LINE OF lt_appointment.
    DATA: lt_status TYPE crmt_status_comt,
          ls_status LIKE LINE OF lt_status.
    DATA: lt_input_fields TYPE crmt_input_field_tab,
          ls_input_fields LIKE LINE OF lt_input_fields,
          ls_field        LIKE LINE OF ls_input_fields-field_names.
    DATA: lv_timestamp         TYPE timestamp,
          lt_objects_to_save   TYPE crmt_object_guid_tab,
          lt_objects_not_saved TYPE crmt_object_guid_tab,
          lv_text              TYPE char40.

    GET TIME STAMP FIELD lv_timestamp.
    lv_text = 'Doc history:' && lv_timestamp.

    DO iv_num TIMES.
      ls_activity_h-ref_handle = get_number_range( ).
      ls_activity_h-priority = 5.
      INSERT ls_activity_h INTO TABLE lt_activity_h.

      ls_partner-ref_handle = ls_activity_h-ref_handle.
      ls_partner-ref_kind = 'A'.
      lv_partner_key1 = ls_partner-ref_partner_handle = get_number_range( ).
      ls_partner-kind_of_entry = 'C'.
      ls_partner-partner_fct = '00000009'.
      ls_partner-partner_no = '0004105192'.
      ls_partner-display_type = ls_partner-no_type = 'BP'.
      ls_partner-mainpartner = 'X'.
      INSERT ls_partner INTO TABLE lt_partner.

      ls_partner-partner_fct = '00000014'.
      ls_partner-partner_no = '0004031140'.
      lv_partner_key2 = ls_partner-ref_partner_handle = get_number_range( ).
      INSERT ls_partner INTO TABLE lt_partner.

      ls_appointment-ref_handle = ls_activity_h-ref_handle.
      ls_appointment-ref_kind = 'A'.
      ls_appointment-appt_type = 'ORDERPLANNED'.
      ls_appointment-timestamp_from = ls_appointment-timestamp_to = '20150110160000'.
      ls_appointment-timezone_from = ls_appointment-timezone_to = 'BRAZIL'.
      INSERT ls_appointment INTO TABLE lt_appointment.

      ls_status-ref_handle = ls_activity_h-ref_handle.
      ls_status-ref_kind = 'A'.
      ls_status-status = 'E0001'.
      ls_status-user_stat_proc = 'CRMACTIV'.

      ls_orderadm_h-handle = ls_activity_h-ref_handle.
      ls_orderadm_h-process_type = '1003'.
      ls_orderadm_h-description = lv_text && ' : ' && sy-index.
      ls_orderadm_h-mode = 'A'.
      INSERT ls_orderadm_h INTO TABLE lt_orderadm_h.

      ls_input_fields-ref_handle = ls_activity_h-ref_handle.
      ls_input_fields-objectname = 'ACTIVITY_H'.
      insert_field 'COMPLETION'.
      insert_field 'PRIORITY'.
      insert_field 'PRIVATE_FLAG'.
      INSERT ls_input_fields INTO TABLE lt_input_fields.

      CLEAR: ls_input_fields.
      ls_input_fields-ref_handle = ls_activity_h-ref_handle.
      ls_input_fields-objectname = 'APPOINTMENT'.
      ls_input_fields-ref_kind = 'A'.
      ls_input_fields-logical_key = 'ORDERPLANNED'.
      insert_field 'TIMESTAMP_FROM'.
      insert_field 'TIMESTAMP_TO'.
      insert_field 'TIMEZONE_FROM'.
      insert_field 'TIMEZONE_TO'.
      INSERT ls_input_fields INTO TABLE lt_input_fields.

      "3
      CLEAR: ls_input_fields.
      ls_input_fields-ref_handle = ls_activity_h-ref_handle.
      ls_input_fields-objectname = 'ORDERADM_H'.
      insert_field 'DESCRIPTION'.
      insert_field 'MODE'.
      insert_field 'PROCESS_TYPE'.
      INSERT ls_input_fields INTO TABLE lt_input_fields.

      "4 Partner
      CLEAR: ls_input_fields.
      ls_input_fields-ref_handle = ls_activity_h-ref_handle.
      ls_input_fields-ref_kind = 'A'.
      ls_input_fields-objectname = 'PARTNER'.
      ls_input_fields-logical_key = lv_partner_key1.
      insert_field 'DISPLAY_TYPE'.
      insert_field 'KIND_OF_ENTRY'.
      insert_field 'NO_TYPE'.
      insert_field 'PARTNER_FCT'.
      insert_field 'PARTNER_NO'.
      INSERT ls_input_fields INTO TABLE lt_input_fields.

      "5 Partner
      ls_input_fields-logical_key = lv_partner_key2.
      INSERT ls_input_fields INTO TABLE lt_input_fields.

      "6 Status
      CLEAR: ls_input_fields.
      ls_input_fields-ref_handle = ls_activity_h-ref_handle.
      ls_input_fields-ref_kind = 'A'.
      ls_input_fields-objectname = 'STATUS'.
      ls_input_fields-logical_key = 'E0001CRMACTIV'.
      insert_field 'ACTIVATE'.
      INSERT ls_input_fields INTO TABLE lt_input_fields.
    ENDDO.

    CALL FUNCTION 'CRM_ORDER_MAINTAIN'
      EXPORTING
        it_activity_h     = lt_activity_h
        it_partner        = lt_partner
        it_appointment    = lt_appointment
        it_status         = lt_status
      CHANGING
        ct_orderadm_h     = lt_orderadm_h
        ct_input_fields   = lt_input_fields
      EXCEPTIONS
        error_occurred    = 1
        document_locked   = 2
        no_change_allowed = 3
        no_authority      = 4
        OTHERS            = 5.

    ASSERT sy-subrc = 0.

    LOOP AT lt_orderadm_h ASSIGNING FIELD-SYMBOL(<order>).
      INSERT <order>-guid INTO TABLE lt_objects_to_save.
    ENDLOOP.

    CHECK lt_objects_to_save IS NOT INITIAL.

    CALL FUNCTION 'CRM_ORDER_SAVE'
      EXPORTING
        it_objects_to_save   = lt_objects_to_save
        iv_update_task_local = abap_true
      IMPORTING
        et_objects_not_saved = lt_objects_not_saved
      EXCEPTIONS
        document_not_saved   = 1
        OTHERS               = 2.

    ASSERT sy-subrc = 0.

    CHECK lt_objects_not_saved IS INITIAL.
    rt_created_guids = lt_objects_to_save.

    COMMIT WORK AND WAIT.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->GET_HISTORIES_OPT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TASK_GUIDS                  TYPE        SWO_TYPEID_LIST
* | [<-()] RT_DOC_LINKS                   TYPE        CRMT_DOC_FLOW_LINK
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_histories_opt.
    DATA: lt_orbreltyp  TYPE TABLE OF orbreltyp,
          lt_relrange   TYPE relrange,
          lt_bor_object TYPE trl_borid,
          lt_rolrange   TYPE rolrange,
          ls_orbreltyp  LIKE LINE OF lt_orbreltyp,
          ls_relrange   LIKE LINE OF lt_relrange.

    SELECT reltype FROM orbreltyp INTO CORRESPONDING FIELDS OF TABLE lt_orbreltyp WHERE dbtable = 'SMW0REL'.

    ls_relrange-sign   = 'E'.
    ls_relrange-option = 'EQ'.

    LOOP AT lt_orbreltyp INTO ls_orbreltyp.
      ls_relrange-low    = ls_orbreltyp-reltype.
      INSERT ls_relrange INTO TABLE lt_relrange.
    ENDLOOP.

    SELECT objkey objtype logsys
         FROM srrelroles
         INTO TABLE lt_bor_object
         FOR ALL ENTRIES IN it_task_guids
         WHERE objkey = it_task_guids-table_line.

    CALL FUNCTION 'NREL_GET_RELATIONS_FOR_OBJLIST'
      EXPORTING
        it_object    = lt_bor_object
        it_rolerange = lt_rolrange
        it_relrange  = lt_relrange
      TABLES
        links        = rt_doc_links.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->GET_HISTORIES_ORIGIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TASK_GUIDS                  TYPE        CRMT_OBJECT_GUID_TAB_UNSORTED
* | [<-()] RT_DOC_LINKS                   TYPE        CRMT_DOC_FLOW_DB_WRKT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD GET_HISTORIES_ORIGIN.
    DATA: lt_docs LIKE rt_doc_links.

    LOOP AT it_task_guids ASSIGNING FIELD-SYMBOL(<guid>).
      CALL FUNCTION 'CRM_DOC_FLOW_READ_DB'
        EXPORTING
          iv_header_guid = <guid>
        IMPORTING
          et_doc_links   = lt_docs
        EXCEPTIONS
          error_occurred = 1
          OTHERS         = 2.

      CHECK sy-subrc = 0.
      INSERT LINES OF lt_docs INTO TABLE rt_doc_links.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->GET_HISTORIES_WITH_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DOC_LINKS                   TYPE        CRMT_DOC_FLOW_DB_WRKT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_HISTORIES_WITH_NUMBER.

    DATA: lt_guid LIKE mt_guid_tabs.

    LOOP AT mt_guid_tabs ASSIGNING FIELD-SYMBOL(<guid>).
       APPEND <guid> TO lt_guid.
    ENDLOOP.

    WRITE: / 'guid counts: ' , lines( lt_guid ).
    rt_doc_links = GET_HISTORIES_origin( lt_guid ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->GET_NUMBER_RANGE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RESULT                      TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_NUMBER_RANGE.
    rv_result = mv_number_range.
    ADD 1 TO mv_number_range.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->GET_WHOLE_OPT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TASK_GUIDS                  TYPE        CRMT_OBJECT_GUID_TAB
* | [<-->] CT_ENTITYSET                   TYPE        ZCRMT_JERRY_DOC_HISTORY_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_WHOLE_OPT.
    DATA: lo_initial_loader        TYPE REF TO cl_crm_odata_initial_loader,
          ls_line LIKE LINE OF ct_entityset.

    CREATE OBJECT lo_initial_loader.

    LOOP AT it_task_guids ASSIGNING FIELD-SYMBOL(<guid>).
       ls_line-guid = <guid>.
       APPEND ls_line TO ct_entityset.
    ENDLOOP.

    lo_initial_loader->if_crm_odata_initial_loader~get_doc_histories( CHANGING ct_entityset = ct_entityset ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->GET_WHOLE_ORIGINAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TASK_GUIDS                  TYPE        CRMT_OBJECT_GUID_TAB
* | [<-()] RT_RESULT                      TYPE        CRMT_ODATA_DOC_HISTORY_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_whole_original.
    DATA: lr_task_impl   TYPE REF TO cl_crm_task_rt,
          ls_filter      TYPE /iwbep/t_mgw_select_option,
          lt_doc_history TYPE cl_crm_task_mpc=>tt_documenthistory,
          lt_key_tab     TYPE /iwbep/t_mgw_name_value_pair,
          lt_path        TYPE /iwbep/t_mgw_navigation_path,
          lt_order       TYPE /iwbep/t_mgw_sorting_order,
          lo_context     TYPE REF TO /iwbep/if_mgw_req_entityset,
          ls_page        TYPE /iwbep/s_mgw_paging.

    CREATE OBJECT lr_task_impl.

    LOOP AT it_task_guids ASSIGNING FIELD-SYMBOL(<guid>).
      CLEAR: lt_key_tab.
      DATA(ls_key) = VALUE /iwbep/s_mgw_name_value_pair( name = 'Guid' value = <guid> ).
      APPEND ls_key TO lt_key_tab.

      CLEAR: lt_doc_history.
      CALL METHOD lr_task_impl->get_document_history
        EXPORTING
          iv_entity_name           = 'dummy'
          iv_entity_set_name       = 'dummy'
          iv_source_name           = ''
          it_filter_select_options = ls_filter
          it_key_tab               = lt_key_tab
          is_paging                = ls_page
          it_navigation_path       = lt_path
          it_order                 = lt_order
          iv_filter_string         = ''
          iv_search_string         = ''
          io_tech_request_context  = lo_context
        IMPORTING
          et_entityset             = lt_doc_history.
      APPEND LINES OF lt_doc_history TO rt_result.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->LINK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TASK_GUIDS                  TYPE        CRMT_OBJECT_GUID_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD link.
    DEFINE insert_field.
      ls_field-fieldname = &1.
      INSERT ls_field INTO TABLE ls_input_fields-field_names.
    END-OF-DEFINITION.

    DATA: lt_doc_flow          TYPE crmt_doc_flow_comt,
          ls_doc_flow          LIKE LINE OF lt_doc_flow,
          lv_source_guid       TYPE crmt_object_guid,
          ls_doc_link          LIKE LINE OF ls_doc_flow-doc_link,
          lv_count             TYPE int4,
          lt_input_fields      TYPE crmt_input_field_tab,
          ls_input_fields      LIKE LINE OF lt_input_fields,
          lt_to_save           TYPE crmt_object_guid_tab,
          lt_objects_not_saved TYPE crmt_object_guid_tab,
          ls_field             LIKE LINE OF ls_input_fields-field_names.

    lv_count = lines( it_task_guids ).

    CHECK ( lv_count MOD 2 ) = 0.
    lv_count = lv_count / 2.

    DO lv_count TIMES.
      CLEAR: ls_doc_flow, ls_doc_link, ls_input_fields.
      READ TABLE it_task_guids ASSIGNING FIELD-SYMBOL(<target>) INDEX sy-index.
      ASSERT sy-subrc = 0.
      READ TABLE it_task_guids ASSIGNING FIELD-SYMBOL(<source>) INDEX ( sy-index + 1 ) .
      ls_doc_flow-ref_guid = <source>.
      ls_doc_flow-ref_kind = 'A'.
      ls_doc_link-objkey_a = <source>.
      ls_doc_link-objtype_a = ls_doc_link-objtype_b = 'BUS2000125'.
      ls_doc_link-objkey_b = <target>.
      ls_doc_link-brel_kind = ls_doc_link-brel_mode = 'A'.
      ls_doc_link-reltype = 'VONA'.
      INSERT ls_doc_link INTO TABLE ls_doc_flow-doc_link.
      INSERT ls_doc_flow INTO TABLE lt_doc_flow.

      ls_input_fields-ref_guid = <source>.
      ls_input_fields-ref_kind = 'A'.
      ls_input_fields-objectname = 'DOC_FLOW'.
      insert_field 'BREL_KIND'.
      insert_field 'OBJKEY_A'.
      insert_field 'OBJKEY_B'.
      insert_field 'OBJTYPE_A'.
      insert_field 'OBJTYPE_B'.
      insert_field 'REF_KIND'.
      insert_field 'REFTYPE'.
      INSERT ls_input_fields INTO TABLE lt_input_fields.
    ENDDO.

    CALL FUNCTION 'CRM_ORDER_MAINTAIN'
      CHANGING
        ct_doc_flow     = lt_doc_flow
        ct_input_fields = lt_input_fields.
    ASSERT sy-subrc = 0.

    LOOP AT lt_input_fields ASSIGNING FIELD-SYMBOL(<input>).
      INSERT <input>-ref_guid INTO TABLE lt_to_save.
    ENDLOOP.

    CALL FUNCTION 'CRM_ORDER_SAVE'
      EXPORTING
        it_objects_to_save   = lt_to_save
        iv_update_task_local = abap_true
      IMPORTING
        et_objects_not_saved = lt_objects_not_saved
      EXCEPTIONS
        document_not_saved   = 1
        OTHERS               = 2.

    ASSERT sy-subrc = 0.
    ASSERT lt_objects_not_saved IS INITIAL.

    COMMIT WORK AND WAIT.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->PRINT_HISTORY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HISTORY                     TYPE        ZCRMT_JERRY_DOC_HISTORY_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method PRINT_HISTORY.
    DATA: lt_header TYPE STANDARD TABLE OF crmd_orderadm_h,
          lv_object_id TYPE crmd_orderadm_h-object_id.

    SELECT * INTO TABLE lt_header FROM crmd_orderadm_h FOR ALL ENTRIES IN it_history
       WHERE guid = it_history-guid.

    LOOP AT it_history ASSIGNING FIELD-SYMBOL(<history>).
       READ TABLE lt_header ASSIGNING FIELD-SYMBOL(<header>) WITH KEY guid = <history>-guid.
       WRITE: / 'document id: ' , <header>-object_id.
       "SELECT * APPENDING TABLE lt_header FROM crmd_orderadm_h FOR ALL ENTRIES IN <history>-documenthistories
       "    WHERE guid = <history>-documenthistories-guid.
       LOOP AT <history>-documenthistories ASSIGNING FIELD-SYMBOL(<detail>).
          READ TABLE lt_header ASSIGNING FIELD-SYMBOL(<header2>) WITH KEY guid = <detail>-guid.
          IF sy-subrc = 0.
             lv_object_id = <header2>-object_id.
          ELSE.
             SELECT SINGLE object_id INTO lv_object_id FROM crmd_orderadm_h WHERE guid = <detail>-guid.
          ENDIF.
          WRITE: / 'history id: ', lv_object_id COLOR COL_TOTAL, 'type: ' , <detail>-relationship COLOR COL_GROUP.
       ENDLOOP.
    ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->START
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method START.
    GET RUN TIME FIELD mv_start.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_TASK_DOC_HISTORY_TOOL->STOP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method STOP.
     GET RUN TIME FIELD mv_stop.
     mv_stop = mv_stop - mv_start.
     WRITE:/ 'time consumed: ' COLOR COL_NEGATIVE, mv_stop.
  endmethod.
ENDCLASS.