* this class is written on 2016 Spring festival eve
CLASS cl_crm_task_userstatus_tool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor .
    METHODS get_user_statuses_origin
      IMPORTING
        !it_key_tab TYPE /iwbep/t_mgw_name_value_pair
      EXPORTING
        !et_results TYPE cl_crm_task_mpc=>tt_taskstatus .
    METHODS get_user_statuses_opt
      IMPORTING
        !it_key_tab TYPE /iwbep/t_mgw_name_value_pair
      EXPORTING
        !et_results TYPE cl_crm_task_mpc=>tt_taskstatus .
    METHODS generate_guid_tab
      IMPORTING
        !iv_num     TYPE int4 OPTIONAL
      EXPORTING
        !et_key_tab TYPE /iwbep/t_mgw_name_value_pair .
    METHODS clear_cache .
    METHODS compare
      IMPORTING
        !it_origin      TYPE crmt_odata_user_status_t
        !it_opt         TYPE crmt_odata_user_status_t
      RETURNING
        VALUE(rv_equal) TYPE abap_bool .
    METHODS get_guid_tab_by_guid
      IMPORTING
        !iv_guid          TYPE crmt_object_guid
      RETURNING
        VALUE(rt_key_tab) TYPE /iwbep/t_mgw_name_value_pair .
    METHODS convert_guid_tab
      IMPORTING
        !it_guid_tab      TYPE string_table
      RETURNING
        VALUE(rt_key_tab) TYPE /iwbep/t_mgw_name_value_pair .
    METHODS run_and_compare
      IMPORTING
        !iv_num          TYPE int4
      RETURNING
        VALUE(rv_result) TYPE abap_bool .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
      mt_guid_tab TYPE STANDARD TABLE OF crmd_orderadm_h-guid .

    METHODS is_status_allowed
      IMPORTING
        !iv_order_guid    TYPE crmt_object_guid
        !is_status_ui     TYPE crmt_status_ui
      RETURNING
        VALUE(rv_allowed) TYPE abap_bool .
    METHODS init .
ENDCLASS.



CLASS CL_CRM_TASK_USERSTATUS_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRM_TASK_USERSTATUS_TOOL->CLEAR_CACHE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD clear_cache.
    CALL FUNCTION 'CRM_LC_STATUS_GET_ATTRIB_CB'
      EXPORTING
        iv_refresh = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRM_TASK_USERSTATUS_TOOL->COMPARE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ORIGIN                      TYPE        CRMT_ODATA_USER_STATUS_T
* | [--->] IT_OPT                         TYPE        CRMT_ODATA_USER_STATUS_T
* | [<-()] RV_EQUAL                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD compare.
    rv_equal = abap_false.
    IF lines( it_origin ) <> lines( it_opt ).
      BREAK-POINT.
    ENDIF.
    CHECK lines( it_origin ) = lines( it_opt ).

    LOOP AT it_origin ASSIGNING FIELD-SYMBOL(<origin>).
      READ TABLE it_opt WITH KEY header_guid = <origin>-header_guid laiso = <origin>-laiso
         status = <origin>-status txt30 = <origin>-txt30 inist = <origin>-inist TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        BREAK-POINT.
        RETURN.
      ENDIF.
    ENDLOOP.

    rv_equal = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRM_TASK_USERSTATUS_TOOL->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.

    DATA: lt_guid_tab TYPE STANDARD TABLE OF zorder_guid.

    SELECT * INTO TABLE lt_guid_tab FROM zorder_guid.

    LOOP AT lt_guid_tab ASSIGNING FIELD-SYMBOL(<guid>).
      APPEND <guid>-guid TO mt_guid_tab.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRM_TASK_USERSTATUS_TOOL->CONVERT_GUID_TAB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_GUID_TAB                    TYPE        STRING_TABLE
* | [<-()] RT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD convert_guid_tab.
    DATA: ls_key LIKE LINE OF rt_key_tab.

    LOOP AT it_guid_tab ASSIGNING FIELD-SYMBOL(<guid>).
      ls_key = VALUE #( name = 'Guid' value = <guid> ).
      APPEND ls_key TO rt_key_tab.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRM_TASK_USERSTATUS_TOOL->GENERATE_GUID_TAB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NUM                         TYPE        INT4(optional)
* | [<---] ET_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD generate_guid_tab.
    DATA: lv_total    TYPE int4,
          lv_size     TYPE int4,
          lt_guid_tab TYPE STANDARD TABLE OF crmd_orderadm_h-guid,
          ls_key      LIKE LINE OF et_key_tab.

    lv_size = iv_num.
    lv_total = lines( mt_guid_tab ).

    IF iv_num > lv_total OR iv_num IS NOT SUPPLIED.
      lv_size = lv_total.
    ENDIF.

    DO lv_size TIMES.
      READ TABLE mt_guid_tab ASSIGNING FIELD-SYMBOL(<guid>) INDEX sy-index.
      ls_key = VALUE #( name = 'Guid' value = <guid> ).
      APPEND ls_key TO et_key_tab.
    ENDDO.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRM_TASK_USERSTATUS_TOOL->GET_GUID_TAB_BY_GUID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GUID                        TYPE        CRMT_OBJECT_GUID
* | [<-()] RT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_guid_tab_by_guid.
    DATA: ls_key LIKE LINE OF rt_key_tab.

    ls_key = VALUE #( name = 'Guid' value = iv_guid ).
    APPEND ls_key TO rt_key_tab.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRM_TASK_USERSTATUS_TOOL->GET_USER_STATUSES_OPT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [<---] ET_RESULTS                     TYPE        CL_CRM_TASK_MPC=>TT_TASKSTATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_user_statuses_opt.

    TYPES: BEGIN OF ty_user_status_ui_map,
             status_profile   TYPE crm_jsto-stsma,
             user_statuses_ui TYPE crmt_status_ui_tab,
           END OF ty_user_status_ui_map.

    DATA: ls_key_tab            TYPE /iwbep/s_mgw_name_value_pair,
          lt_status_ui          TYPE crmt_status_ui_tab,
          ls_status             TYPE crms_odata_task_status_ofl,
          lv_lang               TYPE char2,
          lt_user_status        TYPE STANDARD TABLE OF crm_jsto,
          lt_guid_tab           TYPE STANDARD TABLE OF crm_jsto-objnr,
          lt_user_status_ui_map TYPE STANDARD TABLE OF ty_user_status_ui_map,
          lv_status_allowed     TYPE abap_bool.

    FIELD-SYMBOLS:<guid>               TYPE crm_jsto-objnr,
                  <key_item>           LIKE LINE OF it_key_tab,
                  <status_header>      LIKE LINE OF lt_user_status,
                  <user_status_ui_map> LIKE LINE OF lt_user_status_ui_map,
                  <status_ui>          TYPE crmt_status_ui.

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = sy-langu
      IMPORTING
        output = lv_lang.

    LOOP AT it_key_tab ASSIGNING <key_item> WHERE name = 'Guid'.
      APPEND <key_item>-value TO lt_guid_tab.
    ENDLOOP.

    SELECT objnr stsma INTO CORRESPONDING FIELDS OF TABLE lt_user_status FROM crm_jsto FOR ALL ENTRIES IN lt_guid_tab WHERE
      objnr = lt_guid_tab-table_line AND stsma <> space.

    CHECK sy-subrc = 0.

    LOOP AT lt_user_status ASSIGNING <status_header>.
      ASSERT <status_header>-stsma IS NOT INITIAL.

      READ TABLE lt_user_status_ui_map ASSIGNING <user_status_ui_map> WITH KEY status_profile = <status_header>-stsma.
      IF sy-subrc <> 0.
        APPEND INITIAL LINE TO lt_user_status_ui_map ASSIGNING <user_status_ui_map>.
        <user_status_ui_map>-status_profile = <status_header>-stsma.
        CLEAR: lt_status_ui.
        CALL FUNCTION 'CRM_LC_STATUS_GET_ATTRIB_CB'
          EXPORTING
            iv_user_stat_proc = <status_header>-stsma
          CHANGING
            ct_status_ui      = lt_status_ui
          EXCEPTIONS
            error_occurred    = 1
            OTHERS            = 2.
        CHECK sy-subrc = 0.

        <user_status_ui_map>-user_statuses_ui = lt_status_ui.

        LOOP AT lt_status_ui ASSIGNING <status_ui>.
          lv_status_allowed = is_status_allowed( iv_order_guid = <status_header>-objnr is_status_ui = <status_ui> ).
          IF lv_status_allowed = abap_true.
            CLEAR: ls_status.
            MOVE-CORRESPONDING <status_ui> TO ls_status.
            ls_status-laiso = lv_lang.
            ls_status-header_guid = <status_header>-objnr.
            INSERT ls_status INTO TABLE et_results.
          ENDIF.
        ENDLOOP.

      ELSE.
        CLEAR: lt_status_ui.
        READ TABLE lt_user_status_ui_map ASSIGNING <user_status_ui_map> WITH KEY status_profile = <status_header>-stsma.
        ASSERT sy-subrc = 0.
        lt_status_ui = <user_status_ui_map>-user_statuses_ui.

        LOOP AT lt_status_ui ASSIGNING <status_ui>.
          lv_status_allowed = is_status_allowed( iv_order_guid = <status_header>-objnr is_status_ui = <status_ui> ).
          IF lv_status_allowed = abap_true.
            MOVE-CORRESPONDING <status_ui> TO ls_status.
            ls_status-laiso = lv_lang.
            ls_status-header_guid = <status_header>-objnr.
            INSERT ls_status INTO TABLE et_results.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRM_TASK_USERSTATUS_TOOL->GET_USER_STATUSES_ORIGIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [<---] ET_RESULTS                     TYPE        CL_CRM_TASK_MPC=>TT_TASKSTATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_user_statuses_origin.
    DATA: ls_key_tab   TYPE /iwbep/s_mgw_name_value_pair,
          lt_guid      TYPE crmt_object_guid_tab,
          lv_guid      TYPE crmt_object_guid,
          lt_status_ui TYPE crmt_status_ui_tab,
          ls_status_ui TYPE crmt_status_ui,
          ls_status    TYPE crms_odata_task_status_ofl,
          lv_lang      TYPE char2,
          et_entityset TYPE cl_crm_task_mpc=>tt_taskstatus.

    LOOP AT it_key_tab INTO ls_key_tab
       WHERE name = 'Guid'.

      lv_guid = ls_key_tab-value.

      CALL METHOD cl_crm_uiu_status_info=>get_status_info(
        EXPORTING
          iv_object_guid = lv_guid
          iv_object_kind = 'A'
        RECEIVING
          rt_status_ui   = lt_status_ui
        EXCEPTIONS
          error_occurred = 1
          OTHERS         = 2 ).

      LOOP AT lt_status_ui INTO ls_status_ui.
        MOVE-CORRESPONDING ls_status_ui TO ls_status.
        ls_status-laiso = sy-langu.
        ls_status-header_guid = lv_guid.
        INSERT ls_status INTO TABLE et_results.
      ENDLOOP.

*    Convert from SAP internal code to ISO
      CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
        EXPORTING
          input  = sy-langu
        IMPORTING
          output = lv_lang.

      CLEAR ls_status.
      ls_status-laiso = lv_lang.
      MODIFY et_results FROM ls_status TRANSPORTING laiso WHERE laiso = sy-langu.

    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRM_TASK_USERSTATUS_TOOL->INIT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD init.
    TYPES:
      BEGIN OF ty_sel_tab,
        sign   TYPE ddsign,
        option TYPE ddoption,
        low    TYPE string,
        high   TYPE string,
      END OF ty_sel_tab .
    TYPES:
      tt_sel_tab TYPE STANDARD TABLE OF ty_sel_tab .

    DATA: lt_tj30        TYPE STANDARD TABLE OF tj30,
          lv_valid_found TYPE abap_bool,
          lt_option      TYPE tt_sel_tab.

    SELECT stsma stonr INTO CORRESPONDING FIELDS OF TABLE lt_tj30 FROM tj30.

    LOOP AT lt_tj30 ASSIGNING FIELD-SYMBOL(<tj30>).
      AT NEW stsma.
        lv_valid_found = abap_false.
      ENDAT.

      IF <tj30>-stonr IS NOT INITIAL.
        lv_valid_found = abap_true.
      ENDIF.

      AT END OF stsma.
        IF lv_valid_found = abap_true.
          DATA(ls_option) = VALUE ty_sel_tab( sign = 'I' option = 'EQ' low = <tj30>-stsma ).
          APPEND ls_option TO lt_option.
        ENDIF.
      ENDAT.

    ENDLOOP.

    SELECT guid INTO TABLE mt_guid_tab FROM crmd_orderadm_h AS a INNER JOIN crm_jsto AS b
       ON a~guid = b~objnr WHERE b~stsma IN lt_option.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method CL_CRM_TASK_USERSTATUS_TOOL->IS_STATUS_ALLOWED
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ORDER_GUID                  TYPE        CRMT_OBJECT_GUID
* | [--->] IS_STATUS_UI                   TYPE        CRMT_STATUS_UI
* | [<-()] RV_ALLOWED                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_status_allowed.
    CONSTANTS:  gc_invert(4)  TYPE   c              VALUE ' XX ' ##needed.
    CONSTANTS:
        lc_fieldname_activate TYPE crmt_input_field_names VALUE 'ACTIVATE'.

    rv_allowed = abap_true.

    DATA: ls_status_com       TYPE crmt_status_com,
          lt_status_com       TYPE crmt_status_comt,
          ls_curr_user_status TYPE crmt_status_wrk,
          lt_input_fields     TYPE crmt_input_field_names_tab,
          ls_input_field      LIKE LINE OF lt_input_fields.

    MOVE-CORRESPONDING is_status_ui TO ls_status_com.

    ls_status_com-ref_guid = iv_order_guid.
    ls_status_com-ref_kind = 'A'.
    ls_status_com-activate = is_status_ui-active.
    TRANSLATE ls_status_com-activate USING gc_invert.
    INSERT ls_status_com INTO TABLE lt_status_com.
    INSERT lc_fieldname_activate INTO TABLE lt_input_fields.

    CALL FUNCTION 'CRM_STATUS_MAINTAIN_OW'
      EXPORTING
        it_status_com        = lt_status_com
        iv_check_only        = abap_true
      CHANGING
        ct_input_field_names = lt_input_fields
      EXCEPTIONS
        not_allowed          = 1
        error_occurred       = 2
        warning_occurred     = 3
        OTHERS               = 4.

    READ TABLE lt_input_fields INTO ls_input_field INDEX 1.
    CHECK ls_input_field-changeable = 'A'. " A means NOT changeable
    CALL FUNCTION 'CRM_STATUS_READ_OW'
      EXPORTING
        iv_guid                = iv_order_guid
        iv_only_active         = abap_true
      IMPORTING
        es_current_user_status = ls_curr_user_status
      EXCEPTIONS
        not_found              = 1
        OTHERS                 = 2.

    IF sy-subrc = 0 AND ls_curr_user_status-status <> is_status_ui-status.
      rv_allowed = abap_false.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method CL_CRM_TASK_USERSTATUS_TOOL->RUN_AND_COMPARE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NUM                         TYPE        INT4
* | [<-()] RV_RESULT                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD run_and_compare.
    DATA: lt_result1 TYPE crmt_odata_user_status_t,
          lt_result2 TYPE crmt_odata_user_status_t,
          lt_key_tab TYPE /iwbep/t_mgw_name_value_pair.

    clear_cache( ).
    generate_guid_tab( EXPORTING iv_num = iv_num IMPORTING et_key_tab = lt_key_tab ).
    get_user_statuses_origin( EXPORTING it_key_tab = lt_key_tab IMPORTING et_results = lt_result1 ).
    get_user_statuses_opt(    EXPORTING it_key_tab = lt_key_tab IMPORTING et_results = lt_result2 ).

    rv_result = compare( it_origin = lt_result1 it_opt = lt_result2 ).
  ENDMETHOD.
ENDCLASS.