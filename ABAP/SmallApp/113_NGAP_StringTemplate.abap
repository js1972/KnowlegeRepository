cl_demo_output=>display( 
  COND #( LET t = '120000' IN 
          WHEN sy-timlo < t THEN 
            |{ sy-timlo TIME = ISO } AM| 
          WHEN sy-timlo > t AND sy-timlo < '240000' THEN 
            |{ CONV t( sy-timlo - 12 * 3600 ) TIME = ISO } PM| 
          WHEN sy-timlo = t THEN 
            |High Noon| 
          ELSE 
            THROW cx_cant_be( ) ) ). 