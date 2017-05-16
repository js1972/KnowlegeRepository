# Initial creation on 2017-05-15 8:37AM

## 2017-05-15
/sap/bc/apc_test/ping_pong/player
field: https://ldciqgs.wdf.sap.corp:44300/sap/bc/apc_test/ping_pong/game?sap-client=001
report: RS_APC_PING_PONG
html author: Steffen Knoeller

DATA: lo_producer_txt TYPE REF TO if_amc_message_producer_text.
lo_producer_txt ?= cl_amc_channel_manager=>create_message_producer( i_application_id = 'APC_GAME'
                                                                    i_channel_id = '/ping_pong' ). 
lo_producer_txt->send( i_message = lv_register ).
lo_producer_txt->send( i_message = lv_move ).

how to find application APC_GAME?

In Js code:
var sUrl = "wss://ldciqgs.wdf.sap.corp:44300/sap/bc/apc/sap/ping_pong"
my url: /sap/bc/apc/sap/zorder_log_apc
## 2017-05-16
For demo:
APC: PING_PONG
CL_APC_WS_EXT_PING_PONG - registered in AMC as well.
On start, bind to AMC: 'APC_GAME', i_channel_id     = '/ping_pong' ).
In web page we connect to wss://ldciqgs.wdf.sap.corp:44300/sap/bc/apc/sap/ping_pong. - generated from apc design time.

report: RS_APC_PING_PONG to send message.
Working code:
DATA: lo_producer_txt TYPE REF TO if_amc_message_producer_text.

TRY.
    lo_producer_txt ?= cl_amc_channel_manager=>create_message_producer( i_application_id = 'ZORDERLOG'
                                                                        i_channel_id = '/order_log' ). " channel_extension_id = extens ).
    lo_producer_txt->send( i_message = 'Jerry' ).
  CATCH cx_amc_error INTO DATA(lx_amc_error).
    MESSAGE lx_amc_error->get_text( ) TYPE 'E'.
ENDTRY.


