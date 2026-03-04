CLASS zcl_hcm_utilities DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_years FOR TABLE FUNCTION ztf_hcm_get_years_rv.
ENDCLASS.

CLASS zcl_hcm_utilities IMPLEMENTATION.
  METHOD get_years BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
*  USING
  .
  DECLARE lv_char "$ABAP.type( gjahr )";
  DECLARE lv_num, i int;
  SELECT SUBSTRING( :fecha, 1, 4 ) INTO lv_char FROM dummy;
   lt_result = SELECT lv_char AS FiscYear FROM dummy;

   FOR i IN 1  .. 40 DO
       lt_result = SELECT  ( lv_char - i ) AS FiscYear FROM dummy
                    UNION
                    SELECT FiscYear FROM :lt_result;
   END FOR;

    RETURN SELECT * FROM  :lt_result ORDER BY FiscYear DESC;
  ENDMETHOD.
ENDCLASS.
