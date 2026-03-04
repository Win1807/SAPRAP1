CLASS zcx_staff_report DEFINITION
  PUBLIC
  INHERITING FROM cx_rap_query_provider
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  constants: BEGIN OF without_authority,
             msgid type symsgid value 'ZHCM_RAP_PE',
             msgno type symsgno value '001',
             attr1 type scx_attrname value 'MATRICULA',
             attr2 type scx_attrname value '',
             attr3 type scx_attrname value '',
             attr4 type scx_attrname value '',
             END OF WITHOUT_AUTHORITY.


    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_staff_report IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
