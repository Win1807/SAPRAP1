**"* use this source file for your ABAP unit test classes
*CLASS ltc_trv_virtualelement DEFINITION FINAL FOR TESTING
*DURATION MEDIUM
*RISK LEVEL HARMLESS.
*
*  PRIVATE SECTION.
*    CLASS-DATA gv_pernr  TYPE pernr_d.
*    CLASS-DATA gv_tripno TYPE reinr.
*
*    METHODS teardown.
*
*
*    " AUT Methods for Addl.Destinations----
*    METHODS get_dest_fc_dest_d             FOR TESTING RAISING cx_static_check.
*    METHODS get_dest_fc_dest_active        FOR TESTING RAISING cx_static_check.
*    METHODS get_dest_fc_dest_n_unhide      FOR TESTING RAISING cx_static_check.
*    METHODS get_dest_fc_withcity_hide      FOR TESTING RAISING cx_static_check.
*
*    " AUT Methods for Mileages----
*    METHODS get_mileagefields_hide         FOR TESTING RAISING cx_static_check.
*    METHODS get_mileagefields_hide_fc      FOR TESTING RAISING cx_static_check.
*    METHODS get_costassfields_hide         FOR TESTING RAISING cx_static_check.
*    METHODS get_costassfields_draft_hide         FOR TESTING RAISING cx_static_check.
*
*    " AUT methods for receipts and read calc
*    METHODS get_rec_hidden_fields          FOR TESTING RAISING cx_static_check.
*    METHODS get_ded_hid_field              FOR TESTING RAISING cx_static_check.
*    METHODS get_ded_hid_field_fc           FOR TESTING RAISING cx_static_check.
*    METHODS get_ded_hid_field_fc_x         FOR TESTING RAISING cx_static_check.
*    METHODS get_elmnt_read_calc_fc         FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_ok       FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_ok_2     FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_ok_2_x   FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc          FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_with_val FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_info     FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_info_2   FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_info_3   FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_info_4   FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_info_5   FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_info_6   FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_info_7   FOR TESTING RAISING cx_static_check.
*    METHODS get_element_read_calc_info_8   FOR TESTING RAISING cx_static_check.
*    METHODS get_trip_dest                  FOR TESTING RAISING cx_static_check.
*    METHODS get_rec_hid_field_fc           FOR TESTING RAISING cx_static_check.
*    METHODS get_costass_with_value         FOR TESTING RAISING cx_static_check.
*    METHODS get_costass_with_value_fc      FOR TESTING RAISING cx_static_check.
*    METHODS get_virtual_draft              FOR TESTING RAISING cx_static_check.
*
*    " AUT Methods for Participant relation----
*    METHODS get_prtcpntrelation_rcpts      FOR TESTING RAISING cx_static_check.
*
*    CLASS-METHODS class_setup.
*    CLASS-METHODS class_teardown.
*ENDCLASS.
*
*
*CLASS ltc_trv_virtualelement IMPLEMENTATION.
*  METHOD get_mileagefields_hide.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensemileage.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensemileage.
*
*    lt_calc_elements = VALUE #( ( `MILEAGEISTRIPTYPEENTHIDDEN` ) ).
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               =  gv_tripno
*                             mileageiseditortexthidden      = ''
*                             mileageisnrofpassengerhidden   = ''
*                             mileageistriptypeenthidden     = ''
*                             mileageisaddlflatratehidden    = ''
*                             mileageisdeptrcitynamehidden   = ''
*                             mileageisarrvlcitynamehidden   = ''
*                            mileageiscalcddstncratehidden   = ''
*                             mileageisdeptrcountryhidden    = ''
*                            mileageisarrvlcountryhidden     = ''
*                             mileageistraveldatehidden      = ''
*                             mileageisdeptrhousenmbrhidden  = ''
*                             mileageisarrvlhousenmbrhidden  = ''
*                             mileageisvehlicenseplatehidden = ''
*                             mileageisvehiclemakehidden     = ''
*                             mileageisbaggageweighthidden   = ''
*                             mileageistotalmileshidden      = ''
*                             mileageisdomesticmileshidden   = ''
*                             mileageisvehicletypehidden     = ''
*                             mileagelocationisfacetvisible  = ''
*                             mileageisstartinglochidden     = ''
*                             mileageisendlochidden          = ''
*                             mileageisvehicleclasshidden    = ''
*                             mileageisdeptrpostlcodehidden  = ''
*                             mileageisarrvlpostlcodehidden  = ''
*                             mileageisdepartureregionhidden = ''
*                             mileageisarrivalregionhidden   = ''
*                             mileageisdeparturestreethidden = ''
*                             mileageisarrivalstreethidden   = ''
*                             mileageisvehicletypenamehidden = ''
*                             mileageisdeptrctrynamehidden   = ''
*                             mileageistriptypeentnamehidden = '' ) ).
*    cl_trv_mte_virtual_element_s4=>get_mileage_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                        et_org_data        = lt_org_data
*                                                              CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  METHOD get_mileagefields_hide_fc.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensemileage.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensemileage.
*
*    lt_calc_elements = VALUE #( ( `MILEAGEISTRIPTYPEENTHIDDEN` ) ).
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               =  gv_tripno
*                             mileageiseditortexthidden      = ''
*                             mileageisnrofpassengerhidden   = ''
*                             mileageistriptypeenthidden     = ''
*                             mileageisaddlflatratehidden    = ''
*                             mileageisdeptrcitynamehidden   = ''
*                             mileageisarrvlcitynamehidden   = ''
*                            mileageiscalcddstncratehidden   = ''
*                             mileageisdeptrcountryhidden    = ''
*                            mileageisarrvlcountryhidden     = ''
*                             mileageistraveldatehidden      = ''
*                             mileageisdeptrhousenmbrhidden  = ''
*                             mileageisarrvlhousenmbrhidden  = ''
*                             mileageisvehlicenseplatehidden = ''
*                             mileageisvehiclemakehidden     = ''
*                             mileageisbaggageweighthidden   = ''
*                             mileageistotalmileshidden      = ''
*                             mileageisdomesticmileshidden   = ''
*                             mileageisvehicletypehidden     = ''
*                             mileagelocationisfacetvisible  = ''
*                             mileageisstartinglochidden     = ''
*                             mileageisendlochidden          = ''
*                             mileageisvehicleclasshidden    = ''
*                             mileageisdeptrpostlcodehidden  = ''
*                             mileageisarrvlpostlcodehidden  = ''
*                             mileageisdepartureregionhidden = ''
*                             mileageisarrivalregionhidden   = ''
*                             mileageisdeparturestreethidden = ''
*                             mileageisarrivalstreethidden   = ''
*                             mileageisvehicletypenamehidden = ''
*                             mileageisdeptrctrynamehidden   = ''
*                             mileageistriptypeentnamehidden = '' ) ).
*
*    TEST-INJECTION lt_mileage_fc.
*      lt_mileage_fc = VALUE #( (  fieldname = 'PASSENGE'           visible = '' )
*                                      (  fieldname = 'ADD_FLRA'            visible = '' )
*                                      (  fieldname = 'MIL_DATE'            visible = '' )
*                                      (  fieldname = 'LIC_PLAT'            visible = '' )
*                                      (  fieldname = 'CAR_MAKE'           visible = '' )
*                                      (  fieldname = 'BAG_WGHT'  visible = '' )
*                                      (  fieldname = 'M_TOTAL'            visible = '' )
*                                      (  fieldname = 'KEY_MILE'             visible = '' )
*                                      (  fieldname = 'VEH_TYPE'             visible = '' )
*                                      (  fieldname = 'COUNTRY'             visible = 'X' )
*                                      (  fieldname = 'LOC_FROM'             visible = 'X' )
*                                      (  fieldname = 'LOC_TO'             visible = 'X' )
*                                      (  fieldname = 'VEH_CLAS'             visible = '' )
*                                      (  fieldname = 'VEH_TYPE_NAME'             visible = '' )
*                                      (  fieldname = 'VEH_CLAS_NAME'             visible = '' )
*                                      (  fieldname = 'EDITOR'            visible = '' )
*                                      (  fieldname = 'TT_COMSP'            visible = '' )
*                                      (  fieldname = 'CITYAD1'            visible = '' )
*                                      (  fieldname = 'CITYAD2'           visible = '' )
*                                      (  fieldname = 'COMPUTED_DIST'  visible = '' )
*                                      (  fieldname = 'COUNTRYAD1'            visible = '' )
*                                      (  fieldname = 'COUNTRYAD2'             visible = '' )
*                                      (  fieldname = 'HOUSE_NUMAD1'             visible = '' )
*                                      (  fieldname = 'HOUSE_NUMAD2'             visible = '' )
*                                      (  fieldname = 'COUNTRY'             visible = '' )
*                                      (  fieldname = 'POST_CODEAD1'             visible = '' )
*                                      (  fieldname = 'POST_CODEAD2'             visible = '' )
*                                      (  fieldname = 'REGIONAD1'             visible = '' )
*                                      (  fieldname = 'REGIONAD2'             visible = '' )
*                                      (  fieldname = 'STREETAD1'            visible = '' )
*                                      (  fieldname = 'STREETAD2'            visible = '' )
*                                      (  fieldname = 'TT_COMSP_NAME'            visible = '' )
*                               (  fieldname = 'COUNTRY_REGION_NAME'             visible = '' ) ).
*    END-TEST-INJECTION.
*    cl_trv_mte_virtual_element_s4=>get_mileage_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                        et_org_data        = lt_org_data
*                                                              CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  METHOD get_dest_fc_dest_d .
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>put_in_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*    " Add trip break to the destination
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Adding a trip break now
*
*    DATA lt_keys_trv_exp TYPE TABLE FOR READ IMPORT c_travelexpense.
*
*    " Read keys of travel expense
*    lt_keys_trv_exp = VALUE #( ( %is_draft        = if_abap_behv=>mk-on
*                                 personnelnumber  = gv_pernr
*                                 traveltripnumber = gv_tripno ) ).
*
*    DATA systz TYPE timezone.
*    CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
*      IMPORTING
*        timezone = systz.
*    IF sy-subrc <> 0.
*    ENDIF.
*
*    DATA(api) = cl_bp_i_travelexpense=>get_api( is_keys = VALUE #( is_draft         = if_abap_behv=>mk-on
*                                                                   personnelnumber  = gv_pernr
*                                                                   traveltripnumber = gv_tripno ) ).
*
*    " default trip dates are right within trip dates. We might enhance logic later to check for existing destinations
*    cl_abap_tstmp=>td_add( EXPORTING date     = api->get_bo( )->travelexpense-tripdeparturedate
*                                     time     = api->get_bo( )->travelexpense-departurebegintime
*                                     secs     = 60
*                           IMPORTING res_date = DATA(lv_tb_begd_default)
*                                     res_time = DATA(lv_tb_begt_default) ).
*
*    CONVERT DATE lv_tb_begd_default TIME lv_tb_begt_default INTO TIME STAMP DATA(lv_beg_ts_default) TIME ZONE systz.
*
*    cl_abap_tstmp=>td_add( EXPORTING date     = lv_tb_begd_default
*                                     time     = lv_tb_begt_default
*                                     secs     = 60
*                           IMPORTING res_date = DATA(lv_tb_endd_default)
*                                     res_time = DATA(lv_tb_endt_default) ).
*
*    CONVERT DATE lv_tb_endd_default TIME lv_tb_endt_default INTO TIME STAMP DATA(lv_end_ts_default) TIME ZONE systz.
*
*    MODIFY ENTITIES OF i_travelexpense
*           ENTITY travelexpense
*           EXECUTE CreateTripBreak FROM VALUE #(
*               (
*                 %param-NumberOfTripBreakRecurrence = '1'
*                 %param-RecurrenceType              = 'N' " No recurrence
*                 %param-TripDepartureDate      = lv_tb_begd_default
*    %param-DepartureBeginTime      = lv_tb_begt_default
*    %param-TripArrivalDate      = lv_tb_endd_default
*    %param-ArrivalEndTime      = lv_tb_endt_default
*                 %tky                               = CORRESPONDING #( lt_keys_trv_exp[ 1 ] ) ) )
*           FAILED   DATA(failed)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           REPORTED DATA(reported).
*
*    cl_abap_unit_assert=>assert_initial( failed-travelexpense ).
*    cl_abap_unit_assert=>assert_initial( failed-travelexpenseaddldest ).
*
*    DATA(dests) = api->get_bo( )->traveladdldestinations.
*    READ TABLE dests WITH KEY DestinationType = 'D' ASSIGNING FIELD-SYMBOL(<dest_from_bo>).
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpenseaddldest.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpenseaddldest.
*
*    lt_calc_elements = VALUE #( ( `ADDLDESTISTRIPRSNTXTHIDDEN` ) ).
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               = gv_tripno
*                             DestinationAssignment          = <dest_from_bo>-DestinationAssignment
*                             destinationtype                = 'D'
*                             addldestiscountryhidden        = ''
*                             addldestistripdesthidden       = ''
*                             addldestistriptypestatryhidden = ''
*                             addldestistripactytypehidden   = ''
*                             addldestistriptypeenthidden    = ''
*                             addldestiscitynamehidden       = ''
*                             addldestisdistrictnamehidden   = ''
*                             addldestispostalcodehidden     = ''
*                             addldestiscitycodenamehidden   = ''
*                             addldestisstreetnamehidden     = ''
*                             addldestishousenumberhidden    = ''
*                             addldestisregionhidden         = '' ) ).
*    cl_trv_mte_virtual_element_s4=>get_addldest_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                         et_org_data        = lt_org_data
*                                                               CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>discard_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  ENDMETHOD.
*
*  METHOD get_dest_fc_dest_active.
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpenseaddldest.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpenseaddldest.
*
*    lt_calc_elements = VALUE #( ( `ADDLDESTISTRIPRSNTXTHIDDEN` ) ).
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               = gv_tripno
*                             destinationassignment          = ' 1'
*                             destinationtype                = 'N'
*                             addldestiscountryhidden        = ''
*                             addldestistripdesthidden       = ''
*                             addldestistriptypestatryhidden = ''
*                             addldestistripactytypehidden   = ''
*                             addldestistriptypeenthidden    = ''
*                             addldestiscitynamehidden       = ''
*                             addldestisdistrictnamehidden   = ''
*                             addldestispostalcodehidden     = ''
*                             addldestiscitycodenamehidden   = ''
*                             addldestisstreetnamehidden     = ''
*                             addldestishousenumberhidden    = ''
*                             addldestisregionhidden         = '' ) ).
*    cl_trv_mte_virtual_element_s4=>get_addldest_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                         et_org_data        = lt_org_data
*                                                               CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*
*   ENDMETHOD.
*
*  METHOD get_dest_fc_dest_n_unhide.
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>put_in_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpenseaddldest.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpenseaddldest.
*
*    lt_calc_elements = VALUE #( ( `ADDLDESTISTRIPRSNTXTHIDDEN` ) ).
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               = gv_tripno
*                             destinationassignment          = ' 1'
*                             destinationtype                = 'N'
*                             addldestiscountryhidden        = ''
*                             addldestistripdesthidden       = ''
*                             addldestistriptypestatryhidden = ''
*                             addldestistripactytypehidden   = ''
*                             addldestistriptypeenthidden    = ''
*                             addldestiscitynamehidden       = ''
*                             addldestisdistrictnamehidden   = ''
*                             addldestispostalcodehidden     = ''
*                             addldestiscitycodenamehidden   = ''
*                             addldestisstreetnamehidden     = ''
*                             addldestishousenumberhidden    = ''
*                             addldestisregionhidden         = '' ) ).
*    cl_trv_mte_virtual_element_s4=>get_addldest_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                         et_org_data        = lt_org_data
*                                                               CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>discard_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  ENDMETHOD.
*
*  METHOD get_dest_fc_withcity_hide.
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>put_in_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    DATA(api) = cl_bp_i_travelexpense=>get_api( is_keys = VALUE #( is_draft         = if_abap_behv=>mk-on
*                                                                   personnelnumber  = gv_pernr
*                                                                   traveltripnumber = gv_tripno ) ).
*    DATA(dests) = api->get_bo( )->traveladdldestinations.
*    READ TABLE dests WITH KEY DestinationType = 'M' ASSIGNING FIELD-SYMBOL(<dest_from_bo>).
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpenseaddldest.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpenseaddldest.
*
*    lt_calc_elements = VALUE #( ( `ADDLDESTISTRIPRSNTXTHIDDEN` ) ).
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               = gv_tripno
*                             DestinationAssignment          = <dest_from_bo>-DestinationAssignment
*                             destinationtype                = 'N'
*                             addldestiscountryhidden        = ''
*                             addldestistripdesthidden       = ''
*                             addldestistriptypestatryhidden = ''
*                             addldestistripactytypehidden   = ''
*                             addldestistriptypeenthidden    = ''
*                             addldestiscitynamehidden       = ''
*                             addldestisdistrictnamehidden   = ''
*                             addldestispostalcodehidden     = ''
*                             addldestiscitycodenamehidden   = ''
*                             addldestisstreetnamehidden     = ''
*                             addldestishousenumberhidden    = ''
*                             addldestisregionhidden         = '' ) ).
*
*    cl_trv_mte_virtual_element_s4=>get_addldest_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                         et_org_data        = lt_org_data
*                                                               CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>discard_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  ENDMETHOD.
*
*  METHOD  get_costassfields_hide.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelcostassignment.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelcostassignment.
*
*    lt_calc_elements = VALUE #( ( `COSTASSGMTCOSTCTRISHIDDEN` ) ).
*
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               = gv_tripno
*                          costassgmtcostctrishidden      = ''
*                          travelcostassignmenttype       = 'T'
*                          costassgmtsalesordishidden      = ''
*                          costassgmtslsorditmishidden     = ''
*                          costassgmtwbselmntishidden      = ''
*                          costassgmtntwknmbrishidden      = ''
*                          costassgmtactynmbrishidden      = ''
*                          costassgmtcostobjishidden       = ''
*                          costassgmtisbdgtperdhidden      = ''
*                          costassgmtisbusprochidden       = ''
*                          costassgmtiscategoryhidden      = ''
*                          costassgmtiscmtmtitmhidden      = ''
*                          costassgmtisctrlgareahidden     = ''
*                          costassignmentisdsponlyhidden   = ''
*                          costassgmtisemrkdfndsdochidden  = ''
*                          costassgmtisemrkddocitmhidden   = ''
*                          costassgmtisextprojnmbrhidden   = ''
*                          costassgmtisfundhidden          = ''
*                          costassgmtisfundctrtxthidden    = ''
*                          fndsmgmtcmtmtitmiscmpltdhidden  = ''
*                          costassgmtisgrantidhidden       = ''
*                          costassgmtisprofitcenterhidden  = ''
*                          costassgmtisreferencekeyhidden  = ''
*                          costassgmtissegmenthidden       = ''
*                          costassgmtisfldgrpnamehidden    = ''
*                          costassgmtisbusinessareahidden  = ''
*                          costassgmtiscompanycodehidden   = ''
*                             travelrequestfieldgroup        = '01' ) ).
*
*    cl_trv_mte_virtual_element_s4=>get_costassign_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                 et_org_data        = lt_org_data
*                                                       CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  METHOD get_prtcpntrelation_rcpts.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_trvlexpnreceiptparticipant.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_trvlexpnreceiptparticipant.
*    DATA ls_expense_receipt TYPE i_travelexpensereceipt.
*
*    lt_calc_elements = VALUE #( ( `PARTICIPANTRELATIONNAME` ) ).
*
*    DELETE FROM trvs4_receipt WHERE pernr = gv_pernr AND reinr = '7182'.
*    SELECT personnelnumber, traveltripnumber,
*           travelrequuid,  seqrequuid, travelexpensedocument
*    FROM i_travelexpensereceipt INTO @ls_expense_receipt UP TO 1 ROWS
*      WHERE  personnelnumber = @gv_pernr.
*    ENDSELECT.
*
*    IF sy-subrc = 0.
*      lt_org_data = VALUE #( ( personnelnumber         = gv_pernr
*                               traveltripnumber        = ls_expense_receipt-traveltripnumber
*                               travelrequuid           = 0
*                               travelexpensedocument   = ls_expense_receipt-travelexpensedocument
*                               participantrelation     = '-'
*                               participantrelationname = '' ) ).
*    ENDIF.
*    cl_trv_mte_virtual_element_s4=>get_recpar_participantrelation(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_orginal_data            = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*
*  " Test Method to fetch Virtual Elements for Receipts Hidden Fields by filling values in lt_calc_elements
*  " and Organization data
*  METHOD get_rec_hidden_fields.
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>put_in_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensereceipt.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensereceipt.
*
*    lt_calc_elements = VALUE #( ( `RCPTTRAVELEXPENSETYPEISHIDDEN` ) ).
*
*    lt_org_data = VALUE #( ( personnelnumber       = gv_pernr
*                             traveltripnumber      = gv_tripno
*                             travelrequuid           = 0
*                             travelexpensedocument   = '001'   ) ).
*
**    TEST-INJECTION get_bo.
**
**      "Filling the values in Organization data
**      lt_travelexpense = VALUE #(  personnelnumber         = <fs_receipt_data>-personnelnumber
**                               traveltripnumber        = 0
**                               travelrequuid           = 0  ).
**
**      lt_receipt = VALUE #( ( personnelnumber         = <fs_receipt_data>-personnelnumber
**                               traveltripnumber        = 0
**                               travelexpensedocument = '001'  ) ).
**
**      lt_reccost  = VALUE #( ( personnelnumber         = <fs_receipt_data>-personnelnumber
**                               traveltripnumber        = 0  ) ).
**
**      lt_spl_pvt_rec = VALUE #( ( personnelnumber         = <fs_receipt_data>-personnelnumber
**                               traveltripnumber        = 0  ) ).
**
**
**    END-TEST-INJECTION.
*
*    TEST-INJECTION get_hid_field_control.
*
*      lt_receipts_fc = VALUE #( ( fieldname = 'EXP_TYPES'   visible = '' )
*                                ( fieldname = 'VAT_REG_NO' visible = 'X' ) ).
*
*    END-TEST-INJECTION.
*
*    cl_trv_mte_virtual_element_s4=>get_receipt_hidden_fields(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_orginal_data            = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>discard_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc.
*    """"""""""""""""""""""""""""""""""""""""""""""
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>put_in_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpense.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpense.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `TRVLEXPNISSTARTDATEHIDDEN` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber  = gv_pernr
*                             traveltripnumber = gv_tripno
*                             travelrequuid    = 0 ) ).
*
*    " Setting the Field Controls
*    TEST-INJECTION get_field_control.
*      lt_fieldcontrol = VALUE #( visible = ''
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_country_d )
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_customer ) ).
*    END-TEST-INJECTION.
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~calculate(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_original_data           = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>discard_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and multiple Field Control values to improve branch coverage.
*  METHOD get_element_read_calc_with_val.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpense.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpense.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `TRVLEXPNISSTARTDATEHIDDEN` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber  = gv_pernr
*                             traveltripnumber = gv_tripno
*                             travelrequuid    = 0 ) ).
*
*    " Setting the values for Field Control.
*    TEST-INJECTION get_field_control.
*
*      lt_fieldcontrol = VALUE #( visible = ''
*                                 (       fname = 'PTRV_WEB_GENERAL_DATA_EXT-DATEDEP' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-DATEARR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TIMEDEP' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TIMEARR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CUSTOMER' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-PLAN_ACTIVITY_TYPE' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-ARRIVAL_WORK' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-ESTIMATED_COST' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-COUNTRY' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-LOCATION' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-POST_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITYADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-STREETADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_DISTRICTADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-EDITOR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-ADDR_ARRVL' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-ADDR_DEPAR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-DAT_REDUC1' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-DAT_REDUC2' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-EST_COST_PLAN' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-DURATION_TRIP_BREAKS' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-DZ_LIMIT_180' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-EST_COST_REQ' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-EXCHANGE_DATE' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-EXCL_PERIOD_EXC' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-EXPENSES' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-REASON' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-REPID' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-NO_MILES' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-NUMBER_PERSONS' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-PERM_TRIP_APPR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-KITCHEN_TEMP_ACCOMODATION' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-T_SCHEMA' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-RUNID' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-ROUNDING' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TRAVEL_PLAN' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TLOCK' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TAX_PER_DIEMTAX' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TAX_PD_MANTAX' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-UNAME' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TIMEOUT' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TT_COMSP' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TT_STATU' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-T_ACTYPE' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-DATEOUT' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-DATERET' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-TIMERET' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-RET_COUN' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-PD_MEALS' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-PD_ACCOM' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-DEPARTURE_WORK' ) ).
*
*    END-TEST-INJECTION.
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~calculate(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_original_data           = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  " Test Method to fetch Virtual Elements for Receipts Hidden Fields by filling values in lt_calc_elements,
*  " Organization data and receipt field controls.
*  METHOD get_rec_hid_field_fc.
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>put_in_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensereceipt.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensereceipt.
*
*    lt_calc_elements = VALUE #( ( `RCPTTRAVELEXPENSETYPEISHIDDEN` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber       = gv_pernr
*                             traveltripnumber      = gv_tripno
*                             travelrequuid           = 0
*                             travelexpensedocument   = '001' ) ).
*
*    " fetching the values for receipt field control
*    TEST-INJECTION get_hid_field_control.
*
*      lt_receipts_fc = VALUE #( visible = ''
*                                (       fieldname = 'EXP_TYPE' )
*                                (  fieldname = 'REC_AMOUNT' )
*                                (  fieldname = 'FROM_DATE' )
*                                (  fieldname = 'PAY_AMOUNT' )
*                                (  fieldname = 'TAX_CODE' )
*                                (  fieldname = 'TO_DATE' )
*                                (  fieldname = 'EDITOR' )
*                                (  fieldname = 'DESCRIPT' )
*                                (  fieldname = 'P_PRV' )
*                                (  fieldname = 'LOCATION' )
*                                (  fieldname = 'COUNTRY' )
*                                (  fieldname = 'REGION' )
*                                (  fieldname = 'COUNTRY_REGION_NAME' )
*                                (  fieldname = 'SHORTTXT' )
*                                (  fieldname = 'PAYOUT' )
*                                (  fieldname = 'PAPER_RECEIPT' )
*                                (  fieldname = 'NO_UNIT' )
*                                (  fieldname = 'NO_BRFT' )
*                                (  fieldname = 'N_STF' )
*                                (  fieldname = 'N_PTN' )
*                                (  fieldname = 'N_GST' )
*                                (  fieldname = 'P_DOC' )
*                                (  fieldname = 'REC_DATE' )
*                                (  fieldname = 'SE_NAME' )
*                                (  fieldname = 'SE_STREET' )
*                                (  fieldname = 'SE_CITY' )
*                                (  fieldname = 'SE_STATE_PROVINCE' )
*                                (  fieldname = 'SE_COUNTRY' )
*                                (  fieldname = 'SE_POSTAL_CODE' )
*                                (  fieldname = 'SE_CUSTOMER_SERVICE_PHONE' )
*                                (  fieldname = 'T_PRODUCT' )
*                                (  fieldname = 'REC_RATE' )
*                                (  fieldname = 'TAXJURCODE' )
*                                (  fieldname = 'BUS_PURPO' )
*                                (  fieldname = 'BUS_REASON' )
*                                (  fieldname = 'NO_LUNCH' )
*                                (  fieldname = 'NO_DINNER' )
*                                (  fieldname = 'TT_COMSP' )
*                                (  fieldname = 'NAME' )
*                                (  fieldname = 'STREET' )
*                                (  fieldname = 'HOUSE_NUM' )
*                                (  fieldname = 'POST_CODE' )
*                                (  fieldname = 'CITY' )
*                                (  fieldname = 'RECEIPT_NO' )
*                                (  fieldname = 'RECEIPT_ITEM' )
*                                (  fieldname = 'VAT_AMOUNT' )
*                                (  fieldname = 'VAT_SERVICE_CODE' )
*                                (  fieldname = 'VAT_SUB_SRV_CODE' )
*                                (  fieldname = 'VAT_SERVICE_DESC' )
*                                (  fieldname = 'AIR_DEPARTURE' )
*                                (  fieldname = 'AIR_ARRIVAL' )
*                                (  fieldname = 'AIRLINE' )
*                                (  fieldname = 'AIR_CABIN_CLASS' )
*                                (  fieldname = 'AIR_TICKET_NUMBER' )
*                                (  fieldname = 'CAR_ODOMETER_READING' )
*                                (  fieldname = 'T_GUEST' )
*                                (  fieldname = 'PTRV_WEB_GENERAL' ) ).
*
*    END-TEST-INJECTION.
*
**    TEST-INJECTION get_bo.
**
**      "Filling the values in Organization data
**      lt_travelexpense = VALUE #(  personnelnumber         = <fs_receipt_data>-personnelnumber
**                               traveltripnumber        = 0
**                               travelrequuid           = 0  ).
**
**      lt_receipt = VALUE #( ( personnelnumber         = <fs_receipt_data>-personnelnumber
**                               traveltripnumber        = 0
**                               travelexpensedocument = '001'  ) ).
**
**      lt_reccost  = VALUE #( ( personnelnumber         = <fs_receipt_data>-personnelnumber
**                               traveltripnumber        = 0  ) ).
**
**      lt_spl_pvt_rec = VALUE #( ( personnelnumber         = <fs_receipt_data>-personnelnumber
**                               traveltripnumber        = 0  ) ).
**
**    END-TEST-INJECTION.
*
*    cl_trv_mte_virtual_element_s4=>get_receipt_hidden_fields(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_orginal_data            = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>discard_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  ENDMETHOD.
*
*  " Test Method to fetch Virtual Elements for Cost Assignment Hidden Fields by filling values in lt_calc_elements,
*  " Organization data, Travel Field Group and Cost Assignment field controls.
*  METHOD get_costass_with_value.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensecostassignment.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensecostassignment.
*
*    lt_calc_elements = VALUE #( ( `COSTASSGMTCOSTCTRISHIDDEN` ) ).
*
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               = gv_tripno
*                          costassgmtcostctrishidden      = ''
*                          travelcostassignmenttype       = 'T'
*                          costassgmtsalesordishidden      = ''
*                          costassgmtslsorditmishidden     = ''
*                          costassgmtwbselmntishidden      = ''
*                          costassgmtntwknmbrishidden      = ''
*                          costassgmtactynmbrishidden      = ''
*                          costassgmtcostobjishidden       = ''
*                          costassgmtisbdgtperdhidden      = ''
*                          costassgmtisbusprochidden       = ''
*                          costassgmtiscategoryhidden      = ''
*                          costassgmtiscmtmtitmhidden      = ''
*                          costassgmtisctrlgareahidden     = ''
*                          costassignmentisdsponlyhidden   = ''
*                          costassgmtisemrkdfndsdochidden  = ''
*                          costassgmtisemrkddocitmhidden   = ''
*                          costassgmtisextprojnmbrhidden   = ''
*                          costassgmtisfundhidden          = ''
*                          costassgmtisfundctrtxthidden    = ''
*                          fndsmgmtcmtmtitmiscmpltdhidden  = ''
*                          costassgmtisgrantidhidden       = ''
*                          costassgmtisprofitcenterhidden  = ''
*                          costassgmtisreferencekeyhidden  = ''
*                          costassgmtissegmenthidden       = ''
*                          costassgmtisfldgrpnamehidden    = ''
*                          costassgmtisbusinessareahidden  = ''
*                          costassgmtiscompanycodehidden   = ''
*                             travelrequestfieldgroup        = '01' ) ).
*
*    " Entering the values in only selected fields to improve branch coverage
*    TEST-INJECTION get_costass_field_control.
*
*      lt_fieldcontrol->* = VALUE #( visible = ''
*                                 ( fieldname = 'COSTCENTER' )
*                                 (  fieldname = 'ORDER' )
*                                 (  fieldname = 'PERC_SHARE' )
*                                 (  fieldname = 'COMP_CODE' )
*                                 (  fieldname = 'COST_OBJ' )
*                                 (  fieldname = 'NETWORK' )
*                                 (  fieldname = 'ACTIVITY' )
*                                 (  fieldname = 'WBS_ELEMT' )
*                                 (  fieldname = 'BUS_AREA' )
*                                 (  fieldname = 'SALES_ORD' )
*                                 (  fieldname = 'S_ORD_ITEM' )
*                                 (  fieldname = 'CO_AREA' )
*                                 (  fieldname = 'CDT_NUMBER' )
*                                 (  fieldname = 'PTRV_WEB_GENERAL' ) ).
*
*    END-TEST-INJECTION.
*
*    cl_trv_mte_virtual_element_s4=>get_costassign_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                 et_org_data        = lt_org_data
*                                                       CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  " Test Method to fetch Virtual Elements for Cost Assignment Hidden Fields by filling values in lt_calc_elements,
*  " Organization data, Travel Field Group and Cost Assignment field controls with keyname as 01.
*  METHOD get_costass_with_value_fc.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensecostassignment.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensecostassignment.
*
*    lt_calc_elements = VALUE #( ( `COSTASSGMTCOSTCTRISHIDDEN` ) ).
*
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               = gv_tripno
*                          costassgmtcostctrishidden      = ''
*                          travelcostassignmenttype       = 'T'
*                          costassgmtsalesordishidden      = ''
*                          costassgmtslsorditmishidden     = ''
*                          costassgmtwbselmntishidden      = ''
*                          costassgmtntwknmbrishidden      = ''
*                          costassgmtactynmbrishidden      = ''
*                          costassgmtcostobjishidden       = ''
*                          costassgmtisbdgtperdhidden      = ''
*                          costassgmtisbusprochidden       = ''
*                          costassgmtiscategoryhidden      = ''
*                          costassgmtiscmtmtitmhidden      = ''
*                          costassgmtisctrlgareahidden     = ''
*                          costassignmentisdsponlyhidden   = ''
*                          costassgmtisemrkdfndsdochidden  = ''
*                          costassgmtisemrkddocitmhidden   = ''
*                          costassgmtisextprojnmbrhidden   = ''
*                          costassgmtisfundhidden          = ''
*                          costassgmtisfundctrtxthidden    = ''
*                          fndsmgmtcmtmtitmiscmpltdhidden  = ''
*                          costassgmtisgrantidhidden       = ''
*                          costassgmtisprofitcenterhidden  = ''
*                          costassgmtisreferencekeyhidden  = ''
*                          costassgmtissegmenthidden       = ''
*                          costassgmtisfldgrpnamehidden    = ''
*                          costassgmtisbusinessareahidden  = ''
*                          costassgmtiscompanycodehidden   = ''
*                             travelrequestfieldgroup        = '01' ) ).
*
*    " Entering the values in only selected fields to improve branch coverage
*    TEST-INJECTION get_costass_field_control.
*
*      lt_fieldcontrol->* = VALUE #( keyname = '01'
*                                 ( fieldname = 'COSTCENTER' )
*                                 (  fieldname = 'ORDER' )
*                                 (  fieldname = 'PERC_SHARE' )
*                                 (  fieldname = 'COMP_CODE' )
*                                 (  fieldname = 'COST_OBJ' )
*                                 (  fieldname = 'NETWORK' )
*                                 (  fieldname = 'ACTIVITY' )
*                                 (  fieldname = 'WBS_ELEMT' )
*                                 (  fieldname = 'BUS_AREA' )
*                                 (  fieldname = 'SALES_ORD' )
*                                 (  fieldname = 'S_ORD_ITEM' )
*                                 (  fieldname = 'CO_AREA' )
*                                 (  fieldname = 'CDT_NUMBER' )
*                                 (  fieldname = 'BUDGET_PERIOD' )
*                                 (  fieldname = 'CMMT_ITEM_LONG' )
*                                 (  fieldname = 'FUNDS_CTR' )
*                                 (  fieldname = 'FUNC_AREA' )
*                                 (  fieldname = 'FUND' )
*                                 (  fieldname = 'GRANT_NBR' )
*                                 (  fieldname = 'PRCTR' )
*                                 (  fieldname = 'TASK_ROLE_EXT_ID' )
*                                 (  fieldname = 'TASK_ROLE_GUID' )
*                                 (  fieldname = 'PROJECT_EXT_ID' )
*                                 (  fieldname = 'CO_BUSPROC' )
*                                 (  fieldname = 'PROJECT_GUID' )
*                                 (  fieldname = 'CATEGORY' )
*                                 (  fieldname = 'SEGMENT' )
*                                 (  fieldname = 'KBLNR' )
*                                 (  fieldname = 'KBLPOS' )
*                                 (  fieldname = 'OBJECT_TYPE' )
*                                 (  fieldname = 'ERLKZ' )
*                                 (  fieldname = 'PTRV_WEB_GENERAL' ) ).
*
*    END-TEST-INJECTION.
*
*    cl_trv_mte_virtual_element_s4=>get_costassign_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                 et_org_data        = lt_org_data
*                                                       CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  " kaushik
*  " Test Method to fetch Virtual Elements for Receipts Hidden Fields by filling values in lt_calc_elements,
*  " Organization data and receipt field controls.
*  METHOD get_ded_hid_field.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensereceipt.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensereceipt.
*
*    lt_calc_elements = VALUE #( ( `RCPTTRAVELEXPENSETYPEISHIDDEN` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber         = gv_pernr
*                             traveltripnumber        = gv_tripno
*                             travelrequuid           = 0
*                             travelexpensedocument   = '001' ) ).
*
*    " fetching the values for receipt field control
*    TEST-INJECTION get_ded_field_control.
*      CREATE DATA lt_deduction_fc.
*      lt_deduction_fc->* = VALUE #( visible = ''
*                                    ( fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-BREAK_DE' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_DE' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-DINNE_DE' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-NIGHT_DE' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-BREAK_DE_TIME' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_DE_TIME' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-DINNE_DE_TIME' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-LU_COUPN' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-BREAK_PIK' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_PIK' )
*                                    (  fieldname = 'PTRV_WEB_DEDUCTIONS_EXT-DINNE_PIK' )
*                                    (  fieldname = 'REGION' )
*                                    (  fieldname = 'PTRV_WEB_GENERAL' ) ).
*
*    END-TEST-INJECTION.
*
*    cl_trv_mte_virtual_element_s4=>get_deduction_hidden_fields(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_orginal_data            = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  " Test Method to fetch Virtual Elements for Receipts Hidden Fields by filling values in lt_calc_elements,
*  " Organization data and receipt field controls.
*  METHOD get_ded_hid_field_fc.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensereceipt.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensereceipt.
*
*    lt_calc_elements = VALUE #( ( `RCPTTRAVELEXPENSETYPEISHIDDEN` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber         = gv_pernr
*                             traveltripnumber        = gv_tripno
*                             travelrequuid           = 0
*                             travelexpensedocument   = '001' ) ).
*
*    TEST-INJECTION get_date.
*      <fs_original_data_deduction>-PerDiemDeductionDate = api->get_bo( )->travelexpense-tripdeparturedate.
*    END-TEST-INJECTION.
*
*    " fetching the values for receipt field control
*    TEST-INJECTION get_ded_field_control.
*      CREATE DATA lt_deduction_fc.
*      lt_deduction_fc->* = VALUE #( visible = ''
*                                    ( fname = 'PTRV_WEB_DEDUCTIONS_EXT-BREAK_DE' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_DE' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-DINNE_DE' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-NIGHT_DE' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-BREAK_DE_TIME' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_DE_TIME' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-DINNE_DE_TIME' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LU_COUPN' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-BREAK_PIK' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_PIK' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-DINNE_PIK' )
*                                    (  fname = 'REGION' )
*                                    (  fname = 'PTRV_WEB_GENERAL' ) ).
*
*    END-TEST-INJECTION.
*
*    cl_trv_mte_virtual_element_s4=>get_deduction_hidden_fields(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_orginal_data            = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  " Test Method to fetch Virtual Elements for Receipts Hidden Fields by filling values in lt_calc_elements,
*  " Organization data and receipt field controls.
*  METHOD get_ded_hid_field_fc_x.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensereceipt.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensereceipt.
*
*    lt_calc_elements = VALUE #( ( `RCPTTRAVELEXPENSETYPEISHIDDEN` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber         = gv_pernr
*                             traveltripnumber        = gv_tripno
*                             travelrequuid           = 0
*                             travelexpensedocument   = '001' ) ).
*
*    TEST-INJECTION get_date.
*      <fs_original_data_deduction>-PerDiemDeductionDate = api->get_bo( )->travelexpense-tripdeparturedate.
*    END-TEST-INJECTION.
*
*    " fetching the values for receipt field control
*    TEST-INJECTION get_ded_field_control.
*      CREATE DATA lt_deduction_fc.
*      lt_deduction_fc->* = VALUE #( visible = 'X'
*                                    ( fname = 'PTRV_WEB_DEDUCTIONS_EXT-BREAK_DE' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_DE' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-DINNE_DE' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-NIGHT_DE' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-BREAK_DE_TIME' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_DE_TIME' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-DINNE_DE_TIME' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LU_COUPN' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-BREAK_PIK' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_PIK' )
*                                    (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-DINNE_PIK' )
*                                    (  fname = 'REGION' )
*                                    (  fname = 'PTRV_WEB_GENERAL' ) ).
*
*    END-TEST-INJECTION.
*
*    cl_trv_mte_virtual_element_s4=>get_deduction_hidden_fields(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_orginal_data            = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_ok.
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>put_in_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpense.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpense.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `TRVLEXPNISSTARTDATEHIDDEN` ) ).
*
*    " Fetching personnel number,trip number etc from Travel Expense
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber  = gv_pernr
*                             traveltripnumber = gv_tripno
*                             travelrequuid    = 0 ) ).
*
*    TEST-INJECTION clear_add_dest_fc.
*      t706s->d1600 = ' '.
*      t706s->trip_break = ' '.
*      t706s->d1500 = ' '.
*      t706s->d1700 = ' '.
*      t706s->d1400 = ' '.
*      t706s->d1300 = ' '.
*      t706s->kfzve = ' '.
*    END-TEST-INJECTION.
*
*    TEST-INJECTION set_subrc_fc.
*      sy-subrc = 0.
*      ls_t706s_fc-addr_dest = 'X'.
*      lt_fieldcontrol = VALUE #( visible = ''
*                                 ( fname = 'PTRV_WEB_GENERAL_DATA_EXT-LOCATION' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-POST_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITYADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_DISTRICTADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-STREETADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_DISTRICTADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-STREETADR' )
*                                 (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_PIK' )
*                                 (  fname = 'PTRV_WEB_GENERAL' ) ).
*    END-TEST-INJECTION.
*
*    " Setting the Field Controls
*    TEST-INJECTION get_field_control.
*      lt_fieldcontrol = VALUE #( visible = ''
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_country_d )
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_customer ) ).
*    END-TEST-INJECTION.
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~calculate(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_original_data           = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>discard_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_elmnt_read_calc_fc.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpense.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpense.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `TRVLEXPNISSTARTDATEHIDDEN` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber  = gv_pernr
*                             traveltripnumber = gv_tripno
*                             travelrequuid    = 0 ) ).
*
*    TEST-INJECTION clear_add_dest_fc.
*      t706s->d1600 = ' '.
*      t706s->trip_break = ' '.
*      t706s->d1500 = ' '.
*      t706s->d1700 = ' '.
*      t706s->d1400 = ' '.
*      t706s->d1300 = ' '.
*      t706s->kfzve = ' '.
*    END-TEST-INJECTION.
*
*    TEST-INJECTION set_subrc_fc.
*      sy-subrc = 0.
*      ls_t706s_fc-addr_dest = 'X'.
*      lt_fieldcontrol = VALUE #( visible = 'X'
*                                 ( fname = 'PTRV_WEB_GENERAL_DATA_EXT-LOCATION' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-POST_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITYADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_DISTRICTADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-STREETADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_DISTRICTADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-STREETADR' )
*                                 (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_PIK' )
*                                 (  fname = 'PTRV_WEB_GENERAL' ) ).
*    END-TEST-INJECTION.
*
*    " Setting the Field Controls
*    TEST-INJECTION get_field_control.
*      lt_fieldcontrol = VALUE #( visible = ''
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_country_d )
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_customer ) ).
*    END-TEST-INJECTION.
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~calculate(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_original_data           = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_ok_2.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpense.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpense.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `TRVLEXPNISSTARTDATEHIDDEN` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber  = gv_pernr
*                             traveltripnumber = gv_tripno
*                             travelrequuid    = 0 ) ).
*
*    TEST-INJECTION clear_add_dest_fc.
*      t706s->d1600 = ' '.
*      t706s->trip_break = ' '.
*      t706s->d1500 = ' '.
*      t706s->d1700 = ' '.
*      t706s->d1400 = ' '.
*      t706s->d1300 = ' '.
*      t706s->kfzve = ' '.
*    END-TEST-INJECTION.
*
*    TEST-INJECTION set_subrc_fc.
*      sy-subrc = 0.
*      ls_t706s_fc-addr_dest = 'X'.
*      <fs_original_data_tr>-tripprovisionvariant = '03'.
*      <fs_original_data_tr>-countrygroup = '03'.
*      lt_fieldcontrol = VALUE #( visible = ''
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-POST_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITYADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_DISTRICTADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-STREETADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_DISTRICTADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-STREETADR' )
*                                 (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_PIK' )
*                                 (  fname = 'PTRV_WEB_GENERAL' ) ).
*    END-TEST-INJECTION.
*
*    " Setting the Field Controls
*    TEST-INJECTION get_field_control.
*      lt_fieldcontrol = VALUE #( visible = ''
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_country_d )
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_customer ) ).
*    END-TEST-INJECTION.
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~calculate(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_original_data           = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_ok_2_x.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpense.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpense.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `TRVLEXPNISSTARTDATEHIDDEN` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber  = gv_pernr
*                             traveltripnumber = gv_tripno
*                             travelrequuid    = 0 ) ).
*
*    TEST-INJECTION clear_add_dest_fc.
*      t706s->d1600 = ' '.
*      t706s->trip_break = ' '.
*      t706s->d1500 = ' '.
*      t706s->d1700 = ' '.
*      t706s->d1400 = ' '.
*      t706s->d1300 = ' '.
*      t706s->kfzve = ' '.
*    END-TEST-INJECTION.
*
*    TEST-INJECTION set_subrc_fc.
*      sy-subrc = 0.
*      ls_t706s_fc-addr_dest = 'X'.
*      <fs_original_data_tr>-tripprovisionvariant = '03'.
*      <fs_original_data_tr>-countrygroup = '03'.
*      lt_fieldcontrol = VALUE #( visible = 'X'
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-POST_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITYADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_DISTRICTADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-STREETADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_CODEADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-CITY_DISTRICTADR' )
*                                 (  fname = 'PTRV_WEB_GENERAL_DATA_EXT-STREETADR' )
*                                 (  fname = 'PTRV_WEB_DEDUCTIONS_EXT-LUNCH_PIK' )
*                                 (  fname = 'PTRV_WEB_GENERAL' ) ).
*    END-TEST-INJECTION.
*
*    " Setting the Field Controls
*    TEST-INJECTION get_field_control.
*      lt_fieldcontrol = VALUE #( visible = ''
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_country_d )
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_customer ) ).
*    END-TEST-INJECTION.
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~calculate(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_original_data           = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_info.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA lt_calc_elements_2 TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `TRVLEXPNISSTARTDATEHIDDEN` ) ).
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~get_calculation_info(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        iv_entity                  = 'Open'
*      IMPORTING
*        et_requested_orig_elements = lt_calc_elements_2 ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_info_2.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA lt_calc_elements_2 TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `PARTICIPANTRELATIONNAME` ) ).
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~get_calculation_info(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        iv_entity                  = 'Open'
*      IMPORTING
*        et_requested_orig_elements = lt_calc_elements_2 ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_info_3.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA lt_calc_elements_2 TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `COSTASSGMTCOSTCTRISHIDDEN` ) ).
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~get_calculation_info(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        iv_entity                  = 'Open'
*      IMPORTING
*        et_requested_orig_elements = lt_calc_elements_2 ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_info_4.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA lt_calc_elements_2 TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `ADDLDESTISCITYNAMEHIDDEN` ) ).
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~get_calculation_info(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        iv_entity                  = 'Open'
*      IMPORTING
*        et_requested_orig_elements = lt_calc_elements_2 ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_info_5.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA lt_calc_elements_2 TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `ADVANCEAMOUNTISHIDDEN` ) ).
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~get_calculation_info(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        iv_entity                  = 'Open'
*      IMPORTING
*        et_requested_orig_elements = lt_calc_elements_2 ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_info_6.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA lt_calc_elements_2 TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `MLEAGEISEDITORTEXTHIDDEN` ) ).
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~get_calculation_info(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        iv_entity                  = 'Open'
*      IMPORTING
*        et_requested_orig_elements = lt_calc_elements_2 ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_info_7.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA lt_calc_elements_2 TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `PERDIEMBRKFSTISDEDUCTEDHIDDEN` ) ).
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~get_calculation_info(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        iv_entity                  = 'Open'
*      IMPORTING
*        et_requested_orig_elements = lt_calc_elements_2 ).
*  ENDMETHOD.
*
*  " Test Method to fetch Calculated Fields using Interface Method Calculate by filling values in lt_calc_elements,
*  " Organization data and two Field Control value to improve branch Coverage.
*  METHOD get_element_read_calc_info_8.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA lt_calc_elements_2 TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `RCPTTRAVELEXPENSETYPEISHIDDEN` ) ).
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~get_calculation_info(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        iv_entity                  = 'Open'
*      IMPORTING
*        et_requested_orig_elements = lt_calc_elements_2 ).
*  ENDMETHOD.
*
*  " Test Method to fetch Virtual Elements for Receipts Hidden Fields by filling values in lt_calc_elements
*  " and Organization data
*  METHOD get_trip_dest.
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpensereceipt.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpensereceipt.
*
*    lt_calc_elements = VALUE #( ( `TRIPDESTINATION` ) ).
*
*    " Filling the values in Organization data
*    lt_org_data = VALUE #( ( personnelnumber         = gv_pernr
*                             traveltripnumber        = 0
*                             travelrequuid           = 0
*                             travelexpensedocument   = '001'   ) ).
*
*    cl_trv_mte_virtual_element_s4=>get_tripdest_frm_destassig(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_orginal_data            = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*  ENDMETHOD.
*
*  METHOD get_virtual_draft.
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>put_in_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelexpense.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelexpense.
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    DATA ls_expense         TYPE i_travelexpense.
*
*    DATA lr_virtual_element TYPE REF TO cl_trv_mte_virtual_element_s4.
*
*    lt_calc_elements = VALUE #( ( `TRVLEXPNISSTARTDATEHIDDEN` ) ).
*
*    " Fetching personnel number,trip number etc from Travel Expense
*    SELECT personnelnumber, traveltripnumber,
*           travelrequuid
*    FROM i_travelexpense INTO @ls_expense UP TO 1 ROWS
*      WHERE  personnelnumber = @gv_pernr and traveltripnumber = @gv_tripno.
*    ENDSELECT.
*
*    IF sy-subrc = 0.
*      " Filling the values in Organization data
*      lt_org_data = VALUE #( ( personnelnumber         = gv_pernr
*                               traveltripnumber        = gv_tripno
*                               travelrequuid           = 0 ) ).
*    ENDIF.
*
*    " Setting the Field Controls
*    TEST-INJECTION get_field_control.
*      lt_fieldcontrol = VALUE #( visible = ''
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_country_d )
*                                 (  fname = cl_trv_s4_constants=>gty_dest_fieldcontrol_struct-gc_customer ) ).
*    END-TEST-INJECTION.
*
*    " creating object to call the Interface Method Calculate
*    lr_virtual_element = NEW #( ).
*    lr_virtual_element->if_sadl_exit_calc_element_read~calculate(
*      EXPORTING
*        it_requested_calc_elements = lt_calc_elements
*        it_original_data           = lt_org_data
*      CHANGING
*        ct_calculated_data         = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*
*      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>discard_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  ENDMETHOD.
*
*
*  METHOD class_setup.
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    DATA lt_receipts          TYPE ptrv_web_receipts_ext_t_2.
*    DATA ls_receipt           TYPE ptrv_web_receipts_ext_2.
*    DATA lt_receipt_costdists TYPE ptrv_web_costdist_ext_t.
*    DATA lt_costdists         TYPE ptrv_web_costdist_ext_t.
*    DATA ls_costdist          LIKE LINE OF lt_costdists.
*    DATA ls_general_data_ext  TYPE ptrv_web_general_data_ext.
*    DATA lv_start_date        TYPE redat.
*    DATA lv_end_date          TYPE redat.
*
*    " Checking if a trip already exists for the date range
*
*    SELECT SINGLE pernr FROM pa0105 INTO @gv_pernr WHERE usrid = @sy-uname.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*      lv_start_date = sy-datum + 1.
*      lv_end_date = sy-datum + 3.
*
*      SELECT pernr,reinr,datv1,datb1 FROM ptrv_head INTO TABLE @DATA(lt_temp)
*      WHERE pernr = @gv_pernr AND expenses = @abap_true.
*
*      IF sy-subrc = 0.
*
*        SORT lt_temp BY datv1.
*        LOOP AT lt_temp ASSIGNING FIELD-SYMBOL(<lfs_temp>).
*        IF    ( <lfs_temp>-datv1 <= lv_start_date AND <lfs_temp>-datb1 >= lv_end_date )
*           OR ( <lfs_temp>-datv1 >= lv_start_date AND <lfs_temp>-datv1 <= lv_end_date )
*           OR ( <lfs_temp>-datb1 >= lv_start_date AND <lfs_temp>-datb1 <= lv_end_date ).
*
*            lv_start_date = <lfs_temp>-datb1 + 1.
*            lv_end_date = <lfs_temp>-datb1 + 3.
*
*          ELSE.
*            CONTINUE.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.
*      SELECT SINGLE bukrs FROM pa0017 INTO @DATA(lv_bukrs)
*     WHERE pernr = @gv_pernr.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*        CLEAR ls_general_data_ext.
*        ls_general_data_ext-datedep = lv_start_date.
*        ls_general_data_ext-datearr = lv_end_date.
*        ls_general_data_ext-customer = 'AUT Create Travel Expense Receipt'.
*        ls_general_data_ext-location = 'Walldorf'.
*        ls_general_data_ext-country = 'DE'.
*        ls_general_data_ext-t_schema = '01'.
*        ls_general_data_ext-timearr = '000000'.
*        ls_general_data_ext-timedep = '000000'.
*        ls_general_data_ext-timeape = '000000'.
*        ls_general_data_ext-timedpe = '000000'.
*        ls_general_data_ext-tp_variant = '01'.
*        ls_general_data_ext-estimated_cost_curr = 'EUR'.
*        ls_general_data_ext-pay_curr = 'EUR'.
*        ls_general_data_ext-cityadr = 'Walldorf'.
*        ls_general_data_ext-streetadr = 'Street'.
*        ls_general_data_ext-appvl_status = '1'.
*        ls_general_data_ext-settl_status = '0'.
*
*        CLEAR ls_receipt.
*        ls_receipt-receiptno  = '001'.
*        ls_receipt-exp_type   = 'ABZM'.
*        ls_receipt-rec_amount = '25'.
*        ls_receipt-rec_curr   = 'EUR'.
*        ls_receipt-rec_date   = ls_general_data_ext-datedep.
*        ls_receipt-tax_code   = 'V0'.
*        ls_receipt-from_date  = ls_general_data_ext-datedep.
*        ls_receipt-to_date    = ls_general_data_ext-datearr.
*        ls_receipt-rec_date   = ls_general_data_ext-datedep.
*        ls_receipt-country    = 'DE'.
*        ls_receipt-descript   = 'Lunch Deduction receipt'.
*        APPEND ls_receipt TO lt_receipts.
*
*    CLEAR ls_costdist.
*        ls_costdist-ref_key = '001'.
*        ls_costdist-costdistno = '001'.
*        ls_costdist-perc_share = '100'.
*        ls_costdist-comp_code = lv_bukrs.        "'0001'.
*        ls_costdist-bus_area = '0001'.
*        ls_costdist-costcenter = 'SAP-DUMMY'.
*        ls_costdist-fieldgroup = '01'.
*        APPEND ls_costdist TO lt_costdists.
*
*    DATA lt_destinations TYPE ptrv_web_itinerary_ext_t.
*
*    cl_trv_business_data_s4=>save_trip( EXPORTING iv_employeenumber     = gv_pernr
*            iv_tripnumber         = '0'
*            iv_tripcomponent      = cl_trv_s4_constants=>gc_component_expenses
*            iv_mode               = cl_trv_s4_constants=>gc_trip_action_insert
*          IMPORTING
*                                            " TODO: variable is assigned but never used (ABAP cleaner) et_messages           = DATA(lt_return_save)
*                                            " TODO: variable is assigned but never used (ABAP cleaner) ev_success            = DATA(lv_success)
*            ev_tripnumber         = gv_tripno
*            et_fieldgroup_costass = DATA(lt_fieldgroups)
*                                        CHANGING  ct_receipts           = lt_receipts
*                                                  ct_costdist           = lt_costdists
*                                                  cs_header             = ls_general_data_ext
*                                                  ct_itinerary          = lt_destinations ).
*
*        cl_abap_unit_assert=>assert_not_initial( act  = gv_tripno
*                                                 quit = '2'
*                                                 msg  = 'Error in Expense Report Creation' ).
*
*        cl_abap_unit_assert=>assert_not_initial( act  = lt_receipts
*                                                 quit = '2'
*                                                 msg  = 'Error in Receipt Creation' ).
*
*        DATA ls_key TYPE  ptp60.
*        ls_key-pernr = gv_pernr.
*        ls_key-reinr = gv_tripno.
*    " Call to Update costass DB
*    LOOP AT lt_costdists INTO DATA(ls_costass).
*      cl_trvs4_db_access=>update_costass( is_key        = ls_key
*                                          is_costass    = ls_costass
*                                          it_fieldgroup = lt_fieldgroups ).
*        ENDLOOP.
*
*        LOOP AT lt_receipts INTO DATA(ls_receipte).
*      cl_trvs4_mte_db_access=>update_receipt( is_key     = ls_key
*                                              is_receipt = ls_receipte ).
*    ENDLOOP.
*
*    LOOP AT lt_destinations INTO DATA(ls_dest).
*      cl_trvs4_db_access=>update_dest( is_key         = ls_key
*                                       iv_trip_schema = ls_general_data_ext-t_schema
*                                       is_dest        = ls_dest ).
*    ENDLOOP.
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  ENDMETHOD.
*
*  METHOD class_teardown.
*    IF gv_tripno IS NOT INITIAL.
*
*      cl_trv_business_data_s4=>delete_trip(
*        EXPORTING
*          iv_employeenumber = gv_pernr
*          iv_tripnumber     = gv_tripno
*          iv_tripcomponent  = cl_trv_s4_constants=>gc_component_expenses
*          is_header         = VALUE ptrv_web_general_data_ext( t_schema = '01' tp_variant = '01' )
*        IMPORTING
*          " TODO: variable is assigned but never used (ABAP cleaner)
*          et_messages       = DATA(messages)
*          " TODO: variable is assigned but never used (ABAP cleaner)
*          ev_success        = DATA(success) ).
*
*      cl_trvs4_db_access=>delete_trip( iv_employeenumber = gv_pernr
*                                       iv_tripnumber     = gv_tripno
*                                       iv_trip_component = cl_trv_s4_constants=>gc_component_expenses
*                                       iv_trip_schema    = '01' ).
*
*      DELETE FROM ptrv_head     WHERE pernr = gv_pernr AND reinr = gv_tripno.
*      DELETE FROM ptrv_perio    WHERE pernr = gv_pernr AND reinr = gv_tripno.
*      DELETE FROM trvs4_receipt   WHERE pernr = gv_pernr AND reinr = gv_tripno.
*      DELETE FROM trvs4_costass    WHERE pernr = gv_pernr AND reinr = gv_tripno.
*
*      COMMIT ENTITIES.
*      IF sy-subrc = 0.
*      ENDIF.
*    ENDIF.
*
*    CLEAR : gv_pernr,
*            gv_tripno.
*  ENDMETHOD.
*
*  METHOD teardown.
*    " in between each test.
*    CALL FUNCTION 'PTRA_SCREEN_MEM_CLEAR_ALL'.
*    CALL FUNCTION 'PTRA_UTIL_MEM_CLEAR_ALL'.
*    CALL FUNCTION 'PTRM_UTIL_MESSAGES_DELETE'
*      EXPORTING
*        i_all_only_once_messages = 'X'.
*    CALL FUNCTION 'PTRM_WEB_PERS_NUMBER_DEQUEUE'
*      EXPORTING
*        i_employeenumber = gv_pernr.
*
*  ENDMETHOD.
*
*  " Test Method to fetch Virtual Elements for Cost Assignment Hidden Fields by filling values in lt_calc_elements,
*  " Organization data, Travel Field Group and Cost Assignment field controls with keyname as 01.
*  METHOD get_costassfields_draft_hide.
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    cl_trvs4_hlp_aut=>put_in_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    DATA(api) = cl_bp_i_travelexpense=>get_api( is_keys = VALUE #( is_draft         = if_abap_behv=>mk-on
*                                                                   personnelnumber  = gv_pernr
*                                                                   traveltripnumber = gv_tripno ) ).
*
*    DATA costassm_api TYPE REF TO if_trv_s4_entity_costass.
*    costassm_api ?= api->get_header( )->if_trv_s4_entity~get_child(
*                        i_entity_name = if_trv_s4_entity=>travelcostassignments ).
*
*    DATA(lt_costass) = costassm_api->get_generic_cost_assignments( ).
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act = lines( lt_costass )
*        exp = 0
*    ).
*    SELECT SINGLE bukrs, kostl FROM pa0017 INTO @DATA(lv_costass)
*WHERE pernr = @gv_pernr.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*    APPEND VALUE #( fieldgroup = '01' costdistno = '001' perc_share = '12' costcenter = lv_costass-kostl comp_code = lv_costass-bukrs ) TO lt_costass.
*
*    costassm_api->set_generic_cost_assignments( i_costass = lt_costass ).
*
*    DATA bo TYPE I_TravelExpenseCostAssignment.
*    bo = VALUE #( TravelRequestSequenceNumber = '001' ).
*    costassm_api->if_trv_s4_cds_crud~update( REF #( bo ) ).
*
*    DATA lt_calc_elements   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
*    DATA lt_org_data        TYPE STANDARD TABLE OF c_travelcostassignment.
*    DATA lt_calculated_data TYPE STANDARD TABLE OF c_travelcostassignment.
*
*    lt_calc_elements = VALUE #( ( `COSTASSGMTCOSTCTRISHIDDEN` ) ).
*
*    lt_org_data = VALUE #( ( personnelnumber                = gv_pernr
*                             traveltripnumber               = gv_tripno
*                             TravelRequestSequenceNumber   = '001'
*                             costassgmtcostctrishidden      = ''
*                             travelcostassignmenttype       = 'T'
*                             costassgmtsalesordishidden     = ''
*                             costassgmtslsorditmishidden    = ''
*                             costassgmtwbselmntishidden     = ''
*                             costassgmtntwknmbrishidden     = ''
*                             costassgmtactynmbrishidden     = ''
*                             costassgmtcostobjishidden      = ''
*                             costassgmtisbdgtperdhidden     = ''
*                             costassgmtisbusprochidden      = ''
*                             costassgmtiscategoryhidden     = ''
*                             costassgmtiscmtmtitmhidden     = ''
*                             costassgmtisctrlgareahidden    = ''
*                             costassignmentisdsponlyhidden  = ''
*                             costassgmtisemrkdfndsdochidden = ''
*                             costassgmtisemrkddocitmhidden  = ''
*                             costassgmtisextprojnmbrhidden  = ''
*                             costassgmtisfundhidden         = ''
*                             costassgmtisfundctrtxthidden   = ''
*                             fndsmgmtcmtmtitmiscmpltdhidden = ''
*                             costassgmtisgrantidhidden      = ''
*                             costassgmtisprofitcenterhidden = ''
*                             costassgmtisreferencekeyhidden = ''
*                             costassgmtissegmenthidden      = ''
*                             costassgmtisfldgrpnamehidden   = ''
*                             costassgmtisbusinessareahidden = ''
*                             costassgmtiscompanycodehidden  = '' ) ).
*
*    cl_trv_mte_virtual_element_s4=>get_costassign_hidden_fields( EXPORTING et_calc_elements   = lt_calc_elements
*                                                                           et_org_data        = lt_org_data
*                                                                 CHANGING  ct_calculated_data = lt_calculated_data ).
*    cl_abap_unit_assert=>assert_not_initial( lt_calculated_data ).
*
*    "mandatory hidden fields
*    cl_abap_unit_assert=>assert_true( act = lt_calculated_data[ 1 ]-CostAssgmtIsReferenceKeyHidden quit = if_abap_unit_constant=>quit-no ).
*    cl_abap_unit_assert=>assert_true( act = lt_calculated_data[ 1 ]-CostAssignmentIsDspOnlyHidden quit = if_abap_unit_constant=>quit-no ).
*    cl_abap_unit_assert=>assert_true( act = lt_calculated_data[ 1 ]-TrvlCostAssignmentTypeIsHidden quit = if_abap_unit_constant=>quit-no ).
*    cl_abap_unit_assert=>assert_true( act = lt_calculated_data[ 1 ]-CostAssgmtIsSqncNmbrHidden quit = if_abap_unit_constant=>quit-no ).
*    cl_abap_unit_assert=>assert_true( act = lt_calculated_data[ 1 ]-CostAssgmtIsFldGrpNameHidden quit = if_abap_unit_constant=>quit-no ).
*
*    "fields that should be displayed
*    cl_abap_unit_assert=>assert_false( act = lt_calculated_data[ 1 ]-CostAssgmtIsFieldGroupHidden quit = if_abap_unit_constant=>quit-no ).
*    cl_abap_unit_assert=>assert_false( act = lt_calculated_data[ 1 ]-CostAssgmtCostCtrIsHidden quit = if_abap_unit_constant=>quit-no ).
*    cl_abap_unit_assert=>assert_false( act = lt_calculated_data[ 1 ]-PctgOfCostAssgmtValueIsHidden quit = if_abap_unit_constant=>quit-no ).
*    cl_abap_unit_assert=>assert_false( act = lt_calculated_data[ 1 ]-CostAssgmtIsBusinessAreaHidden quit = if_abap_unit_constant=>quit-no ).
*
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Discard draft
*    cl_trvs4_hlp_aut=>discard_draft( pernr = gv_pernr tripno = gv_tripno ).
*    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  ENDMETHOD.
*
*
*ENDCLASS.
