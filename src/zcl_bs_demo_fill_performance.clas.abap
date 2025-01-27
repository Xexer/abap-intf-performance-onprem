CLASS zcl_bs_demo_fill_performance DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    DATA randomizer_amount   TYPE REF TO zcl_bs_demo_random.
    DATA randomizer_currency TYPE REF TO zcl_bs_demo_random.
    DATA randomizer_text     TYPE REF TO zcl_bs_demo_random.
    DATA randomizer_blob     TYPE REF TO zcl_bs_demo_random.
    DATA randomizer_date     TYPE REF TO zcl_bs_demo_random.
    DATA randomizer_time     TYPE REF TO zcl_bs_demo_random.
    DATA all_letters         TYPE string.

    METHODS initialize_class_attributes.

    METHODS get_random_currency
      RETURNING VALUE(result) TYPE waers.

    METHODS get_description
      RETURNING VALUE(result) TYPE zbs_dmo_perf-description.

    METHODS get_blob
      RETURNING VALUE(result) TYPE zbs_dmo_perf-blob.

    METHODS get_letter
      RETURNING VALUE(result) TYPE string.

    METHODS get_date
      RETURNING VALUE(result) TYPE d.

    METHODS get_time
      RETURNING VALUE(result) TYPE t.

ENDCLASS.


CLASS zcl_bs_demo_fill_performance IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA new_database_entries TYPE STANDARD TABLE OF zbs_dmo_perf WITH EMPTY KEY.

    initialize_class_attributes( ).

    DELETE FROM zbs_dmo_perf.
    COMMIT WORK.

    DO 50 TIMES.
      DO 500 TIMES.
        DATA(new_entry) = VALUE zbs_dmo_perf( identifier  = xco_cp=>uuid( )->value
                                              description = get_description( )
                                              amount      = randomizer_amount->rand( )
                                              currency    = get_random_currency( )
                                              blob        = get_blob( )
                                              ndate       = get_date( )
                                              ntime       = get_time( )
                                              utc         = utclong_current( ) ).
        new_entry-item_description = |Item from { new_entry-ndate DATE = USER } in currency { new_entry-currency }|.

        INSERT new_entry INTO TABLE new_database_entries.
      ENDDO.

      INSERT zbs_dmo_perf FROM TABLE @new_database_entries.
      COMMIT WORK.

      CLEAR new_database_entries.
    ENDDO.

    out->write( |New Entries created in ZBS_DMO_PERF| ).
  ENDMETHOD.


  METHOD initialize_class_attributes.
    all_letters = to_lower( sy-abcde ) && to_upper( sy-abcde ).
    randomizer_amount = NEW zcl_bs_demo_random( id_min = 2
                                                id_max = 450 ).
    randomizer_currency = NEW zcl_bs_demo_random( id_min = 1
                                                  id_max = 4 ).
    randomizer_text = NEW zcl_bs_demo_random( id_min = 1
                                              id_max = 52 ).
    randomizer_blob = NEW zcl_bs_demo_random( id_min = 500
                                              id_max = 2000 ).
    randomizer_date = NEW zcl_bs_demo_random( id_min = 0
                                              id_max = 730 ).
    randomizer_time = NEW zcl_bs_demo_random( id_min = 0
                                              id_max = 360 ).
  ENDMETHOD.


  METHOD get_random_currency.
    CASE randomizer_currency->rand( ).
      WHEN 1.
        result = 'EUR'.
      WHEN 2.
        result = 'USD'.
      WHEN 3.
        result = 'RUB'.
      WHEN 4.
        result = 'CHF'.
    ENDCASE.
  ENDMETHOD.


  METHOD get_description.
    DO 150 TIMES.
      result &&= get_letter( ).
    ENDDO.
  ENDMETHOD.


  METHOD get_blob.
    DO randomizer_blob->rand( ) TIMES.
      result &&= get_letter( ).
    ENDDO.
  ENDMETHOD.


  METHOD get_letter.
    result = substring( val = all_letters
                        off = CONV i( randomizer_text->rand( ) - 1 )
                        len = 1 ).
  ENDMETHOD.


  METHOD get_date.
    RETURN sy-datum - randomizer_date->rand( ).
  ENDMETHOD.


  METHOD get_time.
    RETURN sy-uzeit - randomizer_time->rand( ) * 60.
  ENDMETHOD.
ENDCLASS.
