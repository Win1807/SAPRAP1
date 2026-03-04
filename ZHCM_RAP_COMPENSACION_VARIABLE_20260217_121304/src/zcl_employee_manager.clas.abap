CLASS zcl_employee_manager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_employee_number
      IMPORTING  user_name              TYPE uname      DEFAULT sy-uname
                 reference_date         TYPE syst_datum DEFAULT sy-datum
      RETURNING  VALUE(employee_number) TYPE persno
      EXCEPTIONS query_error.

    "! Retorna true solo si el usuario es jefe
    "! @parameter user_name      | El ID de logon del usuario
    "! @parameter reference_date | Fecha de referencia para la busqueda en infotipos.
    "! @parameter is_manager     | True si es jefe
    "! @exception query_error    | No se pudo everiguar si es jefe o no
    METHODS is_manager
      IMPORTING  user_name         TYPE uname      DEFAULT sy-uname
                 reference_date    TYPE syst_datum DEFAULT sy-datum
      RETURNING  VALUE(is_manager) TYPE abap_bool
      EXCEPTIONS query_error.

    METHODS get_error_messages
      EXPORTING error_message TYPE bapiret2_tab.


  PROTECTED SECTION.
    DATA employee_record TYPE pa0001.
    DATA error_messages  TYPE bapiret2_tab.

    METHODS add_message
      IMPORTING !class    TYPE sy-msgid DEFAULT sy-msgid
                !type     TYPE symsgty  DEFAULT sy-msgty
                !number   TYPE sy-msgno DEFAULT sy-msgno
                var1      TYPE sy-msgv1 DEFAULT sy-msgv1
                var2      TYPE sy-msgv2 DEFAULT sy-msgv2
                var3      TYPE sy-msgv3 DEFAULT sy-msgv3
                var4      TYPE sy-msgv4 DEFAULT sy-msgv4.
ENDCLASS.



CLASS zcl_employee_manager IMPLEMENTATION.

**********************************************************************

  METHOD add_message.
*      IMPORTING !class    TYPE sy-msgid DEFAULT sy-msgid
*                !type     TYPE symsgty  DEFAULT sy-msgty
*                !number   TYPE sy-msgno DEFAULT sy-msgno
*                var1      TYPE sy-msgv1 DEFAULT sy-msgv1
*                var2      TYPE sy-msgv2 DEFAULT sy-msgv2
*                var3      TYPE sy-msgv3 DEFAULT sy-msgv3
*                var4      TYPE sy-msgv4 DEFAULT sy-msgv4.

    APPEND INITIAL LINE TO me->error_messages
           ASSIGNING FIELD-SYMBOL(<message>).

    <message> = VALUE bapiret2( id         = !class
                                type       = !type
                                number     = !number
                                message_v1 = !var1
                                message_v2 = !var2
                                message_v3 = !var3
                                message_v4 = !var4
                                log_msg_no = lines( me->error_messages ) ).
  ENDMETHOD.

**********************************************************************

  METHOD get_employee_number.
*      IMPORTING  reference_date         TYPE syst_datum DEFAULT sy-datum
*                 user_name              TYPE uname      DEFAULT sy-uname
*      RETURNING  VALUE(employee_number) TYPE persno
*      EXCEPTIONS error_code .

    CLEAR me->error_messages.
    DATA return_struct TYPE bapiret2.

    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING id             = !user_name
                begindate      = !reference_date
                enddate        = !reference_date
      IMPORTING return         = return_struct
                employeenumber = !employee_number.

    IF return_struct IS NOT INITIAL.
      APPEND return_struct TO me->error_messages.
      RAISE query_error.
    ENDIF.

  ENDMETHOD.

**********************************************************************

  METHOD is_manager.
*      IMPORTING  user_name         TYPE uname      DEFAULT sy-uname
*                 reference_date    TYPE syst_datum DEFAULT sy-datum
*                 person_number     TYPE persno
*      RETURNING  VALUE(is_manager) TYPE abap_bool
*      EXCEPTIONS query_error.

    DATA user_number TYPE persno.

    me->get_employee_number(
      EXPORTING  user_name       = sy-uname
                 reference_date  = sy-datum
      RECEIVING  employee_number = user_number
      EXCEPTIONS query_error     = 1
                 OTHERS          = 2 ).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " Obtiene unidad organizativa (infotipo 1)
    SELECT SINGLE orgeh FROM pa0001
      INTO ( me->employee_record-orgeh )
      WHERE pernr  = user_number
        AND subty  = space
        AND objps  = space
        AND sprps  = space
        AND endda >= !reference_date
        AND begda <= !reference_date
        AND seqnr  = space.

    IF sy-subrc <> 0.
      "> Usuario &1 con unidad organizativa en blanco.
      MESSAGE e001(zhcm_rap_pe) WITH user_number.
      me->add_message( ).
      RAISE query_error.
    ENDIF.

    " Obtener el jefe de la unidad organizativa
    DATA manager_person_number TYPE persno.
    CALL FUNCTION 'Z_HR_WF_LEE_RESPONS_CON_UNIDAD'
      EXPORTING ip_orgeh = me->employee_record-orgeh
      IMPORTING ep_pernr = manager_person_number.

    is_manager = xsdbool( user_number = manager_person_number ).

  ENDMETHOD.

**********************************************************************

  METHOD get_error_messages.
    error_message = me->error_messages.
  ENDMETHOD.

ENDCLASS.
