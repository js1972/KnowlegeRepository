REPORT ZTEST3.

form run_in_background.
  data:seltab  type rsparams occurs 0 with header line,
       jobnumber type tbtcjob-jobcount,
       jobname   type tbtcjob-jobname value sy-repid,
       print_parameters type pri_params.
  check sy-batch is initial.
  call function 'RS_REFRESH_FROM_SELECTOPTIONS'
    exporting
      curr_report     = sy-repid
    tables
      selection_table = seltab
    exceptions
      not_found       = 1
      no_report       = 2
      others          = 3.
  "it shouldn't be possible to have an exception here!
  call function 'JOB_OPEN'
    exporting
      jobname          = jobname
    importing
      jobcount         = jobnumber
    exceptions
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      others           = 4.
  if sy-subrc <> 0.
    message 'Can''t create a new job' type 'E'.
  else.
    submit zjob with selection-table seltab
           via job jobname number jobnumber and return.
    if sy-subrc <> 0.
      message 'Error adding a step for background execution' type 'E'.
    else.
      call function 'JOB_CLOSE'
        exporting
          jobcount             = jobnumber
          jobname              = jobname
          strtimmed            = 'X'
        exceptions
          cant_start_immediate = 1
          invalid_startdate    = 2
          jobname_missing      = 3
          job_close_failed     = 4
          job_nosteps          = 5
          job_notex            = 6
          lock_failed          = 7
          others               = 8.
      if sy-subrc <> 0.
        message 'Can''t close the new job' type 'E'.
      else.
        message 'Background processing successfully scheduled' type 'S'.
      endif.
    endif.
  endif.
  leave program.
endform.                    "run_in_background

START-OF-SELECTION.

 PERFORM run_in_background.
 WRITE:/ 'job scheduled!'.