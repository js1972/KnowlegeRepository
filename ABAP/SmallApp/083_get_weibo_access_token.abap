report z.
DATA: lv_url TYPE string,
      lv_data TYPE string,
      lr_http_client TYPE REF TO if_http_client.

lv_url = 'https://api.weibo.com/oauth2/access_token?client_id=294066968'
&& '&client_secret=7b0f092f35ec1e443197c2567e67f2a3&grant_type=authorization_code&redirect_uri='
&& 'https://api.weibo.com/oauth2/default.html&code=edd7ec1b2d99dba6ca2806da2e729ac7'.

CALL METHOD cl_http_client=>create_by_url
   EXPORTING
     url                = lv_url
     proxy_host         = 'PROXY.SHA.SAP.CORP'
     proxy_service      = '8080'
     ssl_id             = 'ANONYM'
   IMPORTING
     client             = lr_http_client
   EXCEPTIONS
     argument_not_found = 1
     plugin_not_active  = 2
     internal_error     = 3
     OTHERS             = 4.
 CHECK sy-subrc = 0.

 CALL METHOD lr_http_client->request->set_method( 'POST' ).

 CALL METHOD lr_http_client->send
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3.


 CHECK sy-subrc = 0.

 CALL METHOD lr_http_client->receive
    EXCEPTIONS
       http_communication_failure = 1
       http_invalid_state         = 2
       http_processing_failed     = 3.

 IF sy-subrc <> 0.

    DATA: lv_error_msg TYPE string,
          lv_sysubrc LIKE sy-subrc.
    CALL METHOD lr_http_client->get_last_error
       IMPORTING
          code    = lv_sysubrc
          message = lv_error_msg.
    WRITE: / lv_error_msg.
    RETURN.
 ENDIF.


 lv_data = lr_http_client->response->get_cdata( ).

 WRITE lv_data.