REPORT demo_rfc_dynamic_dest.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA:
      val_in     TYPE string VALUE `val_in`,
      val_in_out TYPE string VALUE `val_in_out`,
      val_out    TYPE string,
      msg        TYPE c LENGTH 80.

    IF sy-uname IS INITIAL.
      cl_demo_output=>display(
        |Example not possible for anonymous user| ).
      RETURN.
    ENDIF.

    DATA(in) = cl_demo_input=>new( ).
    DATA(client) = sy-mandt.
    in->add_field( CHANGING field = client ).
    DATA(uname) = sy-uname.
    in->add_field( CHANGING field = uname ).
    DATA(langu) = sy-langu.
    in->add_field( CHANGING field = langu ).
    DATA(sysid) = sy-sysid.
    in->add_field( CHANGING field = sysid ).
    DATA(host) = CONV rfchost( sy-host ).
    in->add_field( CHANGING field = host ).
    DATA(group) = CONV rfcload( 'PUBLIC' ).
    in->add_field( CHANGING field = group ).
    in->request( ).

    DATA(dest) = cl_dynamic_destination=>create_rfc_destination(
                   logon_client   = client
                   logon_user     = uname
                   logon_language = langu
                   sid            = sysid
                   server         = host
                   group          = group ).

    CALL FUNCTION 'DEMO_RFM_PARAMETERS'
      DESTINATION dest
      EXPORTING
        p_in                  = val_in
      IMPORTING
        p_out                 = val_out
      CHANGING
        p_in_out              = val_in_out
      EXCEPTIONS
        system_failure        = 2 MESSAGE msg
        communication_failure = 4 MESSAGE msg.

    IF sy-subrc <> 0.
      cl_demo_output=>display( |Error when calling sRFC.\n{ msg }| ).
      RETURN.
    ENDIF.
    cl_demo_output=>display( |{ val_out }\n{ val_in_out }| ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).