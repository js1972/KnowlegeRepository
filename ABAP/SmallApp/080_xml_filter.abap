REPORT z_xml_filter.

PARAMETERS: uuid TYPE string OBLIGATORY DEFAULT 'FA163EEF573D1ED3B795C1AA63F43F3E'.

DATA: lo_ixml      TYPE REF TO if_ixml.
DATA: streamfactory TYPE REF TO if_ixml_stream_factory.
DATA: istream        TYPE REF TO if_ixml_istream.
DATA: rv_attr_path TYPE string.
DATA: document TYPE REF TO if_ixml_document.
DATA: parser TYPE REF TO if_ixml_parser.
DATA: xmlcontent TYPE xstring.

DATA: filter_node_name     TYPE REF TO if_ixml_node_filter,
      filter_attr_uuid     TYPE REF TO if_ixml_node_filter,
      filter1              TYPE REF TO if_ixml_node_filter,
      lo_filtered_node     TYPE REF TO if_ixml_node,
      lo_parent            TYPE REF TO if_ixml_node,
      lo_filtered_iterator TYPE REF TO if_ixml_node_iterator,
      lv_temp              TYPE string.

DATA: attributes     TYPE REF TO if_ixml_named_node_map,
      child          TYPE REF TO if_ixml_node,
      index          TYPE i,
      lv_attr_name   TYPE string,
      lv_attr_val    TYPE string,
      attribute      TYPE REF TO if_ixml_attribute,
      lv_name        TYPE string,
      lo_docx        TYPE REF TO cl_docx_document,
      lo_main        TYPE REF TO cl_docx_maindocumentpart,
      lv_docx_main   TYPE xstring,
      lv_parent_name TYPE string,
      lv_type        TYPE string.

START-OF-SELECTION.

  xmlcontent = zcl_jerry_tool=>get_file_binary_by_path( '\\TSHomeServer\TSHome$\i042416\Desktop\custom_part_before.xml').
  lo_ixml = cl_ixml=>create( ).

  streamfactory = lo_ixml->create_stream_factory( ).
  document = lo_ixml->create_document( ).
  istream = streamfactory->create_istream_xstring( string = xmlcontent ).
  parser = lo_ixml->create_parser( stream_factory = streamfactory
                                    istream        = istream
                                    document       = document ).

  parser->set_normalizing( is_normalizing = ' ' ).
  ASSERT parser->parse( ) = 0.

  filter_attr_uuid = document->if_ixml_node~create_filter_attribute( name = 'uuid' value = uuid ).
  lo_filtered_iterator = document->if_ixml_node~create_iterator_filtered( filter_attr_uuid ).
  lo_filtered_node = lo_filtered_iterator->get_next( ).
  WHILE lo_filtered_node IS NOT INITIAL.
    lv_temp = lo_filtered_node->get_name( ).
    WRITE: / 'Filtered node name: ' , lv_temp COLOR COL_NEGATIVE.
    attributes = lo_filtered_node->get_attributes( ).
    index = 0.
    IF attributes IS NOT INITIAL.
      WHILE index < attributes->get_length( ).
        child = attributes->get_item( index ).
        IF child IS NOT INITIAL.
          attribute ?= child->query_interface( ixml_iid_attribute ).
          lv_attr_name = attribute->get_name( ).
          IF lv_attr_name = 'name'.
            lv_name = attribute->get_value( ).
          ENDIF.
          IF lv_attr_name = 'type'.
            lv_type = attribute->get_value( ).
          ENDIF.
          WRITE: / 'filtered node attribute name: ', lv_name COLOR COL_POSITIVE, ' type: ', lv_type COLOR COL_TOTAL.
          IF lv_name IS NOT INITIAL AND lv_type IS NOT INITIAL.
            EXIT.
          ENDIF.
        ENDIF.
        index = index + 1.
      ENDWHILE.
    ENDIF.

    IF lv_type = 'H'.
      CONCATENATE 'n0:' lv_name rv_attr_path INTO rv_attr_path.
    ELSE.
      CONCATENATE 'n0:' lv_name '/' rv_attr_path INTO rv_attr_path.
    ENDIF.

    WRITE:/ 'Filtered path: ', rv_attr_path COLOR COL_NORMAL.

    lo_parent = lo_filtered_node->get_parent( ).
    WHILE lo_parent IS NOT INITIAL.
      lv_parent_name = lo_parent->get_name( ).
      IF lv_parent_name = 'SAP_DATA'.
        EXIT.
      ENDIF.
      attributes = lo_parent->get_attributes( ).
      index = 0.
      IF attributes IS NOT INITIAL.
        WHILE index < attributes->get_length( ).
          child = attributes->get_item( index ).
          IF child IS NOT INITIAL.
            attribute ?= child->query_interface( ixml_iid_attribute ).
            lv_attr_name = attribute->get_name( ).
            IF lv_attr_name = 'name'.
              lv_name = attribute->get_value( ).
              EXIT.
            ENDIF.
          ENDIF.
          index = index + 1.
        ENDWHILE.
      ENDIF.

      IF lv_type = 'H'.
        CONCATENATE 'n0:' lv_name '/' rv_attr_path ':' lv_name '/' INTO rv_attr_path.
        CLEAR: lv_type.
      ELSE.
        CONCATENATE 'n0:' lv_name '/' rv_attr_path INTO rv_attr_path.
      ENDIF.

      CLEAR: lv_name, lv_type.
      lo_parent = lo_parent->get_parent( ).
      WRITE: / 'Final path: ', rv_attr_path COLOR COL_POSITIVE.

    ENDWHILE.

    lo_filtered_node = lo_filtered_iterator->get_next( ).
  ENDWHILE.