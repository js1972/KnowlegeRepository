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
