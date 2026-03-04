*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
*CLASS lhc_EmployeeList DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*
**    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
**      IMPORTING keys REQUEST requested_authorizations FOR SalesOrder RESULT result.
**
**    METHODS create FOR MODIFY
**      IMPORTING entities FOR CREATE SalesOrder.
**
**    METHODS update FOR MODIFY
**      IMPORTING entities FOR UPDATE SalesOrder.
**
**    METHODS delete FOR MODIFY
**      IMPORTING keys FOR DELETE SalesOrder.
*
*    METHODS read FOR READ
*      IMPORTING keys FOR READ EmployeeList RESULT result.
*
**    METHODS lock FOR LOCK
**      IMPORTING keys FOR LOCK SalesOrder.
*
*ENDCLASS.
*
***********************************************************************
***********************************************************************
*
*CLASS lhc_EmployeeList IMPLEMENTATION.
*
***********************************************************************
*
*  METHOD read.
**  IMPORTING keys   FOR READ EmployeeList.
**  CHANGING  result   type table for read result zi_demo_sales_order\\salesorder
**            failed   type response for failed early zi_demo_sales_order
**            reported type response for reported early zi_demo_sales_order
*
*    DATA zovbak_struct TYPE zovbak.
*    DATA messages      TYPE zo_message_tab.
*
*    LOOP AT keys
*      ASSIGNING FIELD-SYMBOL(<key>).
*
***      CALL FUNCTION 'Z_SO_READ'
***        EXPORTING iv_id       = <key>-SalesOrderID
***        IMPORTING es_zvbak    = zovbak_struct
***                  et_messages = messages.
***
***      IF messages IS INITIAL.
***        INSERT CORRESPONDING #( zovbak_struct MAPPING TO ENTITY ) INTO TABLE result.
***      ELSE.
***        APPEND VALUE #( SalesOrderID = <key>-SalesOrderID
***                        %fail-cause  = if_abap_behv=>cause-not_found )
***               TO failed-salesorder.
***      ENDIF.
*
*    ENDLOOP.
*
*  ENDMETHOD.
*
***********************************************************************
*
**  METHOD get_instance_authorizations.
**  ENDMETHOD.
*
***********************************************************************
*
**  METHOD create.
***        IMPORTING entities FOR CREATE SalesOrder.
***        EXPORTING mapped   TYPE table
***                  failed   TYPE table
***                  reported TYPE table
**
**    DATA messages          TYPE zo_message_tab.
**    DATA zovbak_in_struct  TYPE zovbak.
**    DATA zovbak_out_struct TYPE zovbak.
**
**    LOOP AT entities
**         ASSIGNING FIELD-SYMBOL(<ls_entity>).
**
**      zovbak_in_struct = CORRESPONDING #( <ls_entity> MAPPING FROM ENTITY USING CONTROL ).
**
**      CALL FUNCTION 'Z_SO_CREATE'
**        EXPORTING is_zvbak    = zovbak_in_struct
**        IMPORTING es_zvbak    = zovbak_out_struct
**                  et_messages = messages.
**
**      IF messages IS INITIAL.
**        APPEND VALUE #( %cid         = <ls_entity>-%cid " Content ID
**                        SalesOrderID = zovbak_out_struct-id )
**               TO mapped-salesorder.
**      ELSE.
**        " fill failed return structure for the framework
**        APPEND VALUE #( %cid         = <ls_entity>-%cid
**                        SalesOrderID = zovbak_in_struct-id ) TO failed-salesorder.
**
**        " fill reported structure to be displayed on the UI
**        APPEND VALUE #( SalesOrderID = zovbak_in_struct-id
**                        %cid         = <ls_entity>-%cid
**                        %msg         = new_message(
**                                           id       = messages[ 1 ]-msgid
**                                           number   = messages[ 1 ]-msgno
**                                           v1       = messages[ 1 ]-msgv1
**                                           v2       = messages[ 1 ]-msgv2
**                                           v3       = messages[ 1 ]-msgv3
**                                           v4       = messages[ 1 ]-msgv4
**                                           severity = CONV #( messages[ 1 ]-msgty ) ) )
**               TO reported-salesorder.
**      ENDIF.
**
**    ENDLOOP.
**  ENDMETHOD.
**
************************************************************************
**
**  METHOD update.
***        IMPORTING entities FOR UPDATE SalesOrder.
**
**    FIELD-SYMBOLS <lv_field_old>       TYPE any.
**    FIELD-SYMBOLS <lv_field_new>       TYPE any.
**    FIELD-SYMBOLS <lv_field_behv_flag> TYPE any.
**
**    DATA lr_descr_struc TYPE REF TO data.
**    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.
**    DATA zovbak_struct  TYPE zovbak.
**    DATA messages       TYPE zo_message_tab.
**
**    " Read old status (from transaction buffer) using EML (Entity Manipulation Language).
**    " Alternatively using API Z_SO_READ.
**    READ ENTITIES OF zi_demo_sales_order IN LOCAL MODE
**         ENTITY SalesOrder
**         ALL FIELDS WITH CORRESPONDING #( entities )
**         RESULT DATA(sales_orders).
**
**    " Adopt new status
**    LOOP AT entities
**         ASSIGNING FIELD-SYMBOL(<entity>).
**
**      READ TABLE sales_orders
**           INTO DATA(ls_mysalesorder) WITH KEY %tky = <entity>-%tky.
**
**      IF sy-subrc = 0.
**        CLEAR lr_descr_struc.
**        CLEAR lo_structdescr.
**
**        CREATE DATA lr_descr_struc LIKE <entity>.
**        lo_structdescr ?= cl_abap_structdescr=>describe_by_data_ref( p_data_ref = lr_descr_struc ).
**
**        LOOP AT lo_structdescr->components
**             ASSIGNING FIELD-SYMBOL(<lv_component>)
**             WHERE     name    <> 'SALESORDERID'
**                   AND name    <> 'CUSTOMERID'
**                   AND name(1) <> '%'.
**
***          IF     <lv_component>-name    <> 'SALESORDERID'
***             AND <lv_component>-name(1) <> '%'.
**
**          ASSIGN COMPONENT <lv_component>-name OF STRUCTURE <entity> TO <lv_field_new>.
**          ASSIGN COMPONENT <lv_component>-name OF STRUCTURE ls_mysalesorder TO <lv_field_old>.
**          ASSIGN COMPONENT <lv_component>-name OF STRUCTURE <entity>-%control TO <lv_field_behv_flag>.
**
**          IF     <lv_field_old> IS ASSIGNED
**             AND <lv_field_new> IS ASSIGNED AND <lv_field_behv_flag> = if_abap_behv=>mk-off.
**            <lv_field_new> = <lv_field_old>.
**          ENDIF.
**
***          ENDIF.
**
**        ENDLOOP.
**
**        zovbak_struct = CORRESPONDING #( <entity> MAPPING FROM ENTITY ).
**
**        CALL FUNCTION 'Z_SO_UPDATE'
**          EXPORTING is_zvbak    = zovbak_struct
**          IMPORTING et_messages = messages.
**
**        IF messages IS INITIAL.
**          APPEND VALUE #( SalesOrderID = <entity>-SalesOrderID ) TO mapped-salesorder.
**        ELSE.
**          " fill failed return structure for the framework
**          APPEND VALUE #( SalesOrderID = <entity>-SalesOrderID ) TO failed-salesorder.
**          " fill reported structure to be displayed on the UI
**          APPEND VALUE #( SalesOrderID = <entity>-SalesOrderID
**                          %msg         = new_message(
**                                             id       = messages[ 1 ]-msgid
**                                             number   = messages[ 1 ]-msgno
**                                             v1       = messages[ 1 ]-msgv1
**                                             v2       = messages[ 1 ]-msgv2
**                                             v3       = messages[ 1 ]-msgv3
**                                             v4       = messages[ 1 ]-msgv4
**                                             severity = CONV #( messages[ 1 ]-msgty ) ) )
**                 TO reported-salesorder.
**        ENDIF.
**
**      ELSE.
**
***  Error handling
**
**      ENDIF.
**
**    ENDLOOP.
**  ENDMETHOD.
**
************************************************************************
**
**  METHOD delete.
***      IMPORTING keys FOR DELETE SalesOrder.
**
**    DATA messages TYPE zo_message_tab.
**
**    LOOP AT keys
**      ASSIGNING FIELD-SYMBOL(<key>).
**
**      CALL FUNCTION 'Z_SO_DELETE'
**        EXPORTING
**          iv_id       = <key>-salesorderid
**        IMPORTING
**          et_messages = messages.
**
**      IF messages IS INITIAL.
**        APPEND VALUE #( salesorderid = <key>-salesorderid ) TO mapped-salesorder.
**      ELSE.
**        "fill failed return structure for the framework
**        APPEND VALUE #(  salesorderid = <key>-salesorderid ) TO failed-salesorder.
**        "fill reported structure to be displayed on the UI
**        APPEND VALUE #( salesorderid = <key>-salesorderid
**                        %msg = new_message( id = messages[ 1 ]-msgid
**                                            number = messages[ 1 ]-msgno
**                                            v1 = messages[ 1 ]-msgv1
**                                            v2 = messages[ 1 ]-msgv2
**                                            v3 = messages[ 1 ]-msgv3
**                                            v4 = messages[ 1 ]-msgv4
**                                            severity = CONV #( messages[ 1 ]-msgty ) )
**       ) TO reported-salesorder.
**      ENDIF.
**
**    ENDLOOP.
**
**  ENDMETHOD.
**
************************************************************************
**
**  METHOD lock.
**    DATA lt_messages TYPE zo_message_tab.
**
**    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
**
***     Set lock
**      CALL FUNCTION 'Z_SO_LOCK'
**        EXPORTING iv_id       = <key>-SalesOrderID
**        IMPORTING et_messages = lt_messages.
**
**      IF lt_messages IS INITIAL.
**        CONTINUE.
**      ENDIF.
**
**      " fill failed return structure for the framework
**      APPEND VALUE #( SalesOrderID = <key>-SalesOrderID ) TO failed-salesorder.
**
**      " fill reported structure to be displayed on the UI
**      APPEND VALUE #( SalesOrderID = <key>-SalesOrderID
**                      %msg         = new_message(
**                                         id       = lt_messages[ 1 ]-msgid
**                                         number   = lt_messages[ 1 ]-msgno
**                                         v1       = lt_messages[ 1 ]-msgv1
**                                         v2       = lt_messages[ 1 ]-msgv2
**                                         v3       = lt_messages[ 1 ]-msgv3
**                                         v4       = lt_messages[ 1 ]-msgv4
**                                         severity = CONV #( lt_messages[ 1 ]-msgty ) ) )
**             TO reported-salesorder.
**
**    ENDLOOP.
**
**  ENDMETHOD.
*
*ENDCLASS.
*
***********************************************************************
**=====================================================================
***********************************************************************
*
*
**CLASS lsc_ZI_HCM_ADM_EMPLOYEE DEFINITION INHERITING FROM cl_abap_behavior_saver.
**  PROTECTED SECTION.
*
**    METHODS finalize REDEFINITION.
**
**    METHODS check_before_save REDEFINITION.
**
**    METHODS save REDEFINITION.
**
**    METHODS cleanup REDEFINITION.
**
**    METHODS cleanup_finalize REDEFINITION.
*
**ENDCLASS.
*
***********************************************************************
***********************************************************************
*
**CLASS lsc_ZI_HCM_ADB_EMPLOYEE IMPLEMENTATION.
**
************************************************************************
**
**  METHOD finalize.
**    DATA zovbak_buffer_t TYPE zovbak_buffer_tab.
**    DATA messages        TYPE zo_message_tab.
**
**    CALL FUNCTION 'Z_SO_READ_ALL'
**      IMPORTING et_buffer_zvbak = zovbak_buffer_t.
**
**    LOOP AT zovbak_buffer_t
**         ASSIGNING FIELD-SYMBOL(<zovbak_buffer>).
**
**      CALL FUNCTION 'Z_SO_ENRICH'
**        EXPORTING iv_id       = <zovbak_buffer>-id
**        IMPORTING et_messages = messages.
**
**      IF messages IS INITIAL.
**        CONTINUE.
**      ENDIF.
**
**      APPEND VALUE #( SalesOrderID = <zovbak_buffer>-id ) TO failed-salesorder.
**
**      APPEND VALUE #( SalesOrderID = <zovbak_buffer>-id
**                      %msg         = new_message(
**                                         id       = messages[ 1 ]-msgid
**                                         number   = messages[ 1 ]-msgno
**                                         v1       = messages[ 1 ]-msgv1
**                                         v2       = messages[ 1 ]-msgv2
**                                         v3       = messages[ 1 ]-msgv3
**                                         v4       = messages[ 1 ]-msgv4
**                                         severity = CONV #( messages[ 1 ]-msgty ) ) )
**             TO reported-salesorder.
**
**    ENDLOOP.
**  ENDMETHOD.
**
************************************************************************
**
**  METHOD check_before_save.
***      CHANGING !FAILED type DATA
***               !REPORTED type DATA .
**
**    DATA zovbak_buffer_t TYPE zovbak_buffer_tab.
**    DATA messages        TYPE zo_message_tab.
**
**    CALL FUNCTION 'Z_SO_READ_ALL'
**      IMPORTING et_buffer_zvbak = zovbak_buffer_t.
**
**    LOOP AT zovbak_buffer_t
**         ASSIGNING FIELD-SYMBOL(<zovbak_buffer>).
**
**      CALL FUNCTION 'Z_SO_CHECK'
**        EXPORTING iv_id       = <zovbak_buffer>-id
**        IMPORTING et_messages = messages.
**
**      LOOP AT messages INTO DATA(ls_message).
**        APPEND VALUE #( SalesOrderID = <zovbak_buffer>-id ) TO failed-salesorder.
**
**        reported-salesorder = VALUE #( BASE reported-salesorder
**                                       ( SalesOrderID = <zovbak_buffer>-id
**                                         %msg         = me->new_message(
**                                                            severity = if_abap_behv_message=>severity-error
**                                                            id       = ls_message-msgid
**                                                            number   = ls_message-msgno
**                                                            v1       = ls_message-msgv1
**                                                            v2       = ls_message-msgv2
**                                                            v3       = ls_message-msgv3
**                                                            v4       = ls_message-msgv4 ) ) ).
**      ENDLOOP.
**
**    ENDLOOP.
**  ENDMETHOD.
**
************************************************************************
**
**  METHOD save.
**    CALL FUNCTION 'Z_SO_SAVE'.
**  ENDMETHOD.
**
************************************************************************
**
**  METHOD cleanup.
**    CALL FUNCTION 'Z_SO_INITIALIZE'.
**  ENDMETHOD.
**
************************************************************************
**
**  METHOD cleanup_finalize.
**  ENDMETHOD.
*
**ENDCLASS.
