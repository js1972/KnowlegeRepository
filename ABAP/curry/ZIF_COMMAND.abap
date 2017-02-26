interface ZIF_COMMAND
  public .


  data NEXT type ref to ZIF_COMMAND .

  methods DO .
  methods GET_NEXT
    returning
      value(RO_NEXT) type ref to ZIF_COMMAND .
  methods SET_TASK
    importing
      !IV_TASK type ANY .
endinterface.