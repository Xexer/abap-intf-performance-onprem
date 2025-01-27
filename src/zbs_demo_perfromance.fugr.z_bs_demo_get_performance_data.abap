FUNCTION z_bs_demo_get_performance_data.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(SELECTION_FIELDS) TYPE  STRING_TABLE
*"     VALUE(TOP) TYPE  I
*"     VALUE(SKIP) TYPE  I
*"  EXPORTING
*"     VALUE(PERFORMANCE_DATA) TYPE  ZBS_T_DEMO_PERFORMANCE
*"----------------------------------------------------------------------
  DATA(fields_for_select) = ``.
  LOOP AT selection_fields REFERENCE INTO DATA(field_name).
    DATA(validated_name) = cl_abap_dyn_prg=>check_column_name( val    = field_name->*
                                                               strict = abap_true ).

    IF fields_for_select <> ``.
      fields_for_select &&= `, `.
    ENDIF.
    fields_for_select &&= validated_name.
  ENDLOOP.

  IF fields_for_select IS INITIAL.
    fields_for_select = `*`.
  ENDIF.

  SELECT FROM zbs_dmo_perf
    FIELDS (fields_for_select)
    ORDER BY identifier
    INTO CORRESPONDING FIELDS OF TABLE @performance_data
    UP TO @top ROWS
    OFFSET @skip.
ENDFUNCTION.
