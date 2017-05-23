DATA: ok_code TYPE sy-ucomm,
      save_ok LIKE ok_code,
      output(8) TYPE c.

CALL SCREEN 100.

MODULE user_command_0100 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.