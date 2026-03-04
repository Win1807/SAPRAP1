*&---------------------------------------------------------------------*
*& Report Z_HR_INFOTYPE_OPERATION_JOB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_hr_infotype_operation_job.

*&--------------------------------------------------------------------&*
*&            S E L E C T I O N - S C R E E N                         &*
*&--------------------------------------------------------------------&*
SELECTION-SCREEN : BEGIN OF BLOCK b_00 WITH FRAME TITLE TEXT-t00.
  PARAMETERS:
*    p_p0082 TYPE p0082,
    p_infty TYPE  prelp-infty,
    p_pernr TYPE  p0001-pernr,
    p_subty TYPE  p0001-subty,
    p_endda TYPE  p0001-endda,
    p_begda TYPE  p0001-begda,
    p_opera TYPE  pspar-actio,
    p_nocom TYPE  bapi_stand-no_commit.
SELECTION-SCREEN END OF BLOCK b_00.
*LOAD-OF-PROGRAM.
***__ To avoid the Dump

START-OF-SELECTION.
  PERFORM do_nothing(sapfp50p).
  PERFORM infotype_operations.

*&---------------------------------------------------------------------*
*& Form CALL_RFC_INFOTYPE_OPERATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*FORM call_rfc_infotype_operation .
*  CALL FUNCTION 'Z_HR_INFOTYPE_OPERATION' DESTINATION 'NONE'
*    EXPORTING
*      infty         = p_infty
*      number        = p_pernr
*      subtype       = p_subty
*      validityend   = p_endda
*      validitybegin = p_begda
*      record        = p_p0082
*      operation     = 'INS'
*      nocommit      = 'X'
*    IMPORTING
*      return        = lws_struc2
*      key           = lws_key
*    EXCEPTIONS
*      OTHERS        = 0.
*ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  INFOTYPE_OPERATIONS
*&---------------------------------------------------------------------*
FORM infotype_operations.

  DATA:
        ls_p0082  TYPE p0082,
        RECORD  TYPE p0082,
        ls_return TYPE bapireturn1,
        ls_key    TYPE bapipakey.


import RECORD = RECORD FROM  MEMORY ID p_pernr.

ls_p0082 = record.
if ls_p0082 is INITIAL.
  p_opera = 'INS'.
  p_nocom  =
  ls_p0082-infty = p_infty.
  ls_p0082-subty = p_subty.
  ls_p0082-pernr = p_pernr.
  ls_p0082-endda = p_endda.
  ls_p0082-begda = p_begda.
  ls_p0082-idate = sy-datum.
ENDIF.

  CALL FUNCTION 'HR_INITIALIZE_BUFFER'
    EXPORTING
      tclas = 'A'
      pernr = ls_p0082-pernr.

**__ Lock the  Employee
  CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
    EXPORTING
      number = ls_p0082-pernr
    IMPORTING
      return = ls_return.

**__ Infotype Operation
  CALL FUNCTION 'HR_INFOTYPE_OPERATION'
    EXPORTING
      infty         = p_infty
      number        = p_pernr
      subtype       = p_subty
      validityend   = p_endda
      validitybegin = p_begda
      record        = ls_p0082
*      opera         = 'INS' "-@0001
      OPERATION         = 'INS'
*      nocom         = 'X' "-@0001
      nocommit = p_nocom"'X'"+@0001
    IMPORTING
      return        = ls_return
      key           = ls_key.

      commit WORK AND WAIT.

**__ Dequeue Employee
  CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
    EXPORTING
      number = ls_p0082-pernr
    IMPORTING
      return = ls_return.

**__ Initialize Buffer
  CALL FUNCTION 'HR_PSBUFFER_INITIALIZE'.

ENDFORM.
