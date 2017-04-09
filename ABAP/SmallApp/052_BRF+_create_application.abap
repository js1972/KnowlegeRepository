*&---------------------------------------------------------------------*
*& Report  ZCEATE_APPLICATION
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zceate_app_function.

DEFINE write_errors.
  IF &1 IS NOT INITIAL.
  LOOP AT &1 ASSIGNING <ls_message>.
  WRITE: <ls_message>-text.
  ENDLOOP.
  RETURN.
  ENDIF.
END-OF-DEFINITION.

START-OF-SELECTION.

  DATA: lo_factory     TYPE REF TO if_fdt_factory,
        lo_application TYPE REF TO if_fdt_application,
        lt_message     TYPE if_fdt_types=>t_message,
        lv_boolean     TYPE abap_bool.
  FIELD-SYMBOLS: <ls_message> TYPE if_fdt_types=>s_message.
  lo_factory = cl_fdt_factory=>if_fdt_factory~get_instance( ).
  lo_application = lo_factory->get_application( ).
  lo_application->if_fdt_transaction~enqueue( ).
  lo_application->set_development_package( '$TMP' ).
  lo_application->if_fdt_admin_data~set_name( 'PRICING3' ).
  lo_application->if_fdt_admin_data~set_texts(
  iv_short_text = 'Pricing3' ).

  lo_application->if_fdt_transaction~activate(
      IMPORTING et_message           = lt_message
                ev_activation_failed = lv_boolean ).

  write_errors lt_message.
  lo_application->if_fdt_transaction~save( ).
  lo_application->if_fdt_transaction~dequeue( ).

  lo_factory = cl_fdt_factory=>if_fdt_factory~get_instance(
  iv_application_id = lo_application->mv_id ).

  BREAK-POINT.

  WRITE:/ lo_application->mv_id.

  DATA: lo_function    TYPE REF TO if_fdt_function,
        lts_context_id TYPE if_fdt_types=>ts_object_id,
        lv_result_id   TYPE if_fdt_types=>id.

  lo_function ?= lo_factory->get_function( ).
  lo_function->if_fdt_transaction~enqueue( ).
  lo_function->if_fdt_admin_data~set_name( 'price_calculation' ).
  lo_function->if_fdt_admin_data~set_texts(
  iv_short_text = 'price calculation' ).

  lo_function->set_function_mode( if_fdt_function=>gc_mode_event ).

* WE NEED TO CREATE DATA OBJECT AND ASSIGN IT TO CONTEXT

  DATA lo_element TYPE REF TO if_fdt_element.
* CREATION: get new element via factory - CUSTOMER
  lo_element ?= lo_factory->get_data_object(
  iv_data_object_type = if_fdt_constants=>gc_data_object_type_element ).

  lo_element->if_fdt_transaction~enqueue( ).
  lo_element->if_fdt_admin_data~set_name( 'customer' ).
  lo_element->if_fdt_admin_data~set_texts( iv_short_text = 'customer' ).

  lo_element->set_element_type( if_fdt_constants=>gc_element_type_text ).

  lo_element->set_element_type_attributes( iv_length = 30 ).

  INSERT lo_element->mv_id INTO TABLE lts_context_id.

* CREATE ITEM
  lo_element ?= lo_factory->get_data_object(
  iv_data_object_type = if_fdt_constants=>gc_data_object_type_element ).

  lo_element->if_fdt_transaction~enqueue( ).
  lo_element->if_fdt_admin_data~set_name( 'item' ).
  lo_element->if_fdt_admin_data~set_texts( iv_short_text = 'item' ).

  lo_element->set_element_type( if_fdt_constants=>gc_element_type_text ).

  lo_element->set_element_type_attributes( iv_length = 30 ).

  INSERT lo_element->mv_id INTO TABLE lts_context_id.

* CREATE PROMOTION
  lo_element ?= lo_factory->get_data_object(
  iv_data_object_type = if_fdt_constants=>gc_data_object_type_element ).

  lo_element->if_fdt_transaction~enqueue( ).
  lo_element->if_fdt_admin_data~set_name( 'promotion' ).
  lo_element->if_fdt_admin_data~set_texts( iv_short_text = 'promotion' ).

  lo_element->set_element_type( if_fdt_constants=>gc_element_type_text ).

  lo_element->set_element_type_attributes( iv_length = 20 ).

  INSERT lo_element->mv_id INTO TABLE lts_context_id.

* CREATE PROMOTION
  lo_element ?= lo_factory->get_data_object(
  iv_data_object_type = if_fdt_constants=>gc_data_object_type_element ).

  lo_element->if_fdt_transaction~enqueue( ).
  lo_element->if_fdt_admin_data~set_name( 'shelf_price' ).
  lo_element->if_fdt_admin_data~set_texts( iv_short_text = 'shelf price' ).

  lo_element->set_element_type( if_fdt_constants=>gc_element_type_number ).

  lo_element->set_element_type_attributes(
      iv_length        = 7
      iv_decimals      = 2
      iv_only_positive = abap_true ).

  INSERT lo_element->mv_id INTO TABLE lts_context_id.
* CREATE RESULT DATA OBJECT
  lo_element ?= lo_factory->get_data_object(
      iv_data_object_type = if_fdt_constants=>gc_data_object_type_element ).

  lo_element->if_fdt_transaction~enqueue( ).
  lo_element->if_fdt_admin_data~set_name( 'final_price' ).
  lo_element->if_fdt_admin_data~set_texts( iv_short_text = 'final price' ).
  lo_element->set_element_type( if_fdt_constants=>gc_element_type_number ).

  lo_element->set_element_type_attributes(
      iv_length        = 7
      iv_decimals      = 2
      iv_only_positive = abap_true ).

  lv_result_id     = lo_element->mv_id.

* WE NEED TO ASSIGN PROPERTY CONTEXT TO FUNCTION INSTANCE
  lo_function->set_context_data_objects( lts_context_id ).
  lo_function->set_result_data_object( lv_result_id ).

  lo_function->if_fdt_transaction~activate(
     EXPORTING
        iv_deep              = abap_true
     IMPORTING
        et_message           = lt_message
        ev_activation_failed = lv_boolean ).
  write_errors lt_message.

  lo_function->if_fdt_transaction~save(
       EXPORTING iv_deep = abap_true ).

  lo_function->if_fdt_transaction~dequeue(
       EXPORTING iv_deep = abap_true ).