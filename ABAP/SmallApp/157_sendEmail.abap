*&---------------------------------------------------------------------*
*& Report  ZTEST_SEND_MAIL_HTML
*&---------------------------------------------------------------------*
*& This report will show how to send the Formatted Emails using 
*&   SAPConnect 
*&---------------------------------------------------------------------*
REPORT  ztest_np_send_mail.

DATA:
t_objbin   TYPE STANDARD TABLE OF solisti1,   " Attachment data
t_objtxt   TYPE STANDARD TABLE OF solisti1,   " Message body
t_objpack  TYPE STANDARD TABLE OF sopcklsti1, " Packing list
t_reclist  TYPE STANDARD TABLE OF somlreci1,  " Receipient list
t_objhead  TYPE STANDARD TABLE OF solisti1.   " Header

DATA: wa_docdata TYPE sodocchgi1,   " Document data
      wa_objtxt  TYPE solisti1,     " Message body
      wa_objbin  TYPE solisti1,     " Attachment data
      wa_objpack TYPE sopcklsti1,   " Packing list
      wa_reclist TYPE somlreci1.    " Receipient list

DATA: w_tab_lines TYPE i.           " Table lines

* Selection Screen
PARAMETERS: p_email TYPE char120 obligatory
                VISIBLE LENGTH 40
                LOWER CASE.

* Start-of-selection
START-OF-SELECTION.

* Creating message
  PERFORM create_message.

* Sending Message
  PERFORM send_message.

*&---------------------------------------------------------------------*
*&      Form  create_message
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM create_message .

**1 Title, Description & Body
  PERFORM create_title_desc_body.

**2 Receivers
  PERFORM fill_receivers.

ENDFORM.                    " create_message

*&---------------------------------------------------------------------*
*&      Form  CREATE_TITLE_DESC_BODY
*&---------------------------------------------------------------------*
*       Title, Description and body
*----------------------------------------------------------------------*
FORM create_title_desc_body.

*...Title
  wa_docdata-obj_name  = 'Email notification'.

*...Description
  wa_docdata-obj_descr = 'Email body in HTML'.

*...Message Body in HMTL
  wa_objtxt-line = '<html> <body style="background-color:#FFE4C4;">'.
  APPEND wa_objtxt TO t_objtxt.

  wa_objtxt-line = '<p> List of Test materials </p>'.
  APPEND wa_objtxt TO t_objtxt.

*   table display
  wa_objtxt-line = '<table style="MARGIN: 10px" bordercolor="#90EE90" '.
  APPEND wa_objtxt TO t_objtxt.
  wa_objtxt-line = ' cellspacing="0" cellpadding="3" width="400"'.
  APPEND wa_objtxt TO t_objtxt.
  wa_objtxt-line = ' border="1"><tbody><tr>'.
  APPEND wa_objtxt TO t_objtxt.

*   table header
  wa_objtxt-line = '<th bgcolor="#90EE90">Material</th>'.
  APPEND wa_objtxt TO t_objtxt.
  wa_objtxt-line = '<th bgcolor="#90EE90">Description</th></tr>'.
  APPEND wa_objtxt TO t_objtxt.

*   table Contents
  DO 5 TIMES.
    wa_objtxt-line = '<tr style="background-color:#eeeeee;"><td>TEST</td>'.
    APPEND wa_objtxt TO t_objtxt.
    CONCATENATE '<td>' sy-abcde '</td> </tr>' INTO wa_objtxt-line.
    APPEND wa_objtxt TO t_objtxt.
  ENDDO.

*   table close
  wa_objtxt-line = '</tbody> </table>'.
  APPEND wa_objtxt TO t_objtxt.

*   Hyperlink
  wa_objtxt-line = '<br> <br>'.
  APPEND wa_objtxt TO t_objtxt.
  wa_objtxt-line = '<p><a href="http://help-abap.blogspot.com">'.
  APPEND wa_objtxt TO t_objtxt.
  wa_objtxt-line = 'Click here to check the latest post</a></p>'.
  APPEND wa_objtxt TO t_objtxt.

*   Signature with background color
  wa_objtxt-line = '<br><br>'.
  APPEND wa_objtxt TO t_objtxt.
  wa_objtxt-line = '<p> Regards,</p>'.
  APPEND wa_objtxt TO t_objtxt.
  wa_objtxt-line = '<p style="background-color:#1E90FF;"><b>Naimesh Patel</b></p>'.
  APPEND wa_objtxt TO t_objtxt.


*   HTML close
  wa_objtxt-line = '</body> </html> '.
  APPEND wa_objtxt TO t_objtxt.

* Document data
  DESCRIBE TABLE t_objtxt      LINES w_tab_lines.
  READ     TABLE t_objtxt      INTO wa_objtxt INDEX w_tab_lines.
  wa_docdata-doc_size =
      ( w_tab_lines - 1 ) * 255 + STRLEN( wa_objtxt ).

* Packing data
  CLEAR wa_objpack-transf_bin.
  wa_objpack-head_start = 1.
  wa_objpack-head_num   = 0.
  wa_objpack-body_start = 1.
  wa_objpack-body_num   = w_tab_lines.
*   we will pass the HTML, since we have created the message
*   body in the HTML
  wa_objpack-doc_type   = 'HTML'.
  APPEND wa_objpack TO t_objpack.

ENDFORM.                    " CREATE_TITLE_DESC_BODY

*&---------------------------------------------------------------------*
*&      Form  fill_receivers
*&---------------------------------------------------------------------*
*       Filling up the Receivers
*----------------------------------------------------------------------*
FORM fill_receivers .

  wa_reclist-receiver = p_email.
  wa_reclist-rec_type = 'U'.
  APPEND wa_reclist TO t_reclist.
  CLEAR  wa_reclist.


ENDFORM.                    " fill_receivers
*&---------------------------------------------------------------------*
*&      Form  send_message
*&---------------------------------------------------------------------*
*       Sending Mail
*----------------------------------------------------------------------*
FORM send_message .
	
* Send Message to external Internet ID
  CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
    EXPORTING
      document_data              = wa_docdata
      put_in_outbox              = 'X'
      commit_work                = 'X'     "used from rel.6.10
    TABLES
      packing_list               = t_objpack
      object_header              = t_objhead
      contents_txt               = t_objtxt
      receivers                  = t_reclist
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.

  IF sy-subrc NE 0.
    WRITE: 'Sending Failed'.
  ELSE.
    WRITE: 'Sending Successful'.
  ENDIF.


ENDFORM.                    " send_message