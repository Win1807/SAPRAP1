function zhcmf_get_basic_emoluments.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(PI_MOLGA) TYPE  MOLGA
*"     REFERENCE(PI_ENDDA) TYPE  ENDDA
*"  TABLES
*"      PT_TBINDBW STRUCTURE  ZHCMS_TBINDBW
*"      PI_P0001 STRUCTURE  P0001
*"      PI_P0007 STRUCTURE  P0007
*"  CHANGING
*"     REFERENCE(PI_P0008) TYPE  P0008
*"     REFERENCE(PI_T511) TYPE  ZHCMTT_T511_DC
*"----------------------------------------------------------------------

constants: gc_vecesimp    TYPE i     VALUE  40.

  DATA: lc_lgart LIKE pa0008-lga01,
        ln_betrg LIKE pa0008-bet01,
        lp_anznn LIKE pa0008-anz01,
        lc_indnn LIKE pa0008-ind01,
        lc_opknn LIKE pa0008-opk01.
  DATA: lc_seqnr(3)     TYPE p,
        li_subrc TYPE sysubrc.

  lc_seqnr = 0.
  DO gc_vecesimp TIMES
     VARYING lc_lgart FROM pi_p0008-lga01  "cc-nomina
                      NEXT pi_p0008-lga02
     VARYING ln_betrg FROM pi_p0008-bet01  "importe
                      NEXT pi_p0008-bet02
     VARYING lp_anznn FROM pi_p0008-anz01  "cantidad
                      NEXT pi_p0008-anz02
     VARYING lc_indnn FROM pi_p0008-ind01  "Indicadores
                      NEXT pi_p0008-ind02
     VARYING lc_opknn FROM pi_p0008-opk01  "Indicador de operación para CC-nóminas
                      NEXT pi_p0008-opk02.

*...Se crea Tab.Int.solo si hay valores p.el campo CC-nomina
*...p.luego ser usada en el perform sgte.
    IF NOT lc_lgart IS INITIAL.
      CLEAR: pt_tbindbw.
      ADD 1 TO lc_seqnr.
      UNPACK lc_seqnr      TO pt_tbindbw-seqnr.
      MOVE: lc_lgart       TO pt_tbindbw-lgart,
            lc_opknn       TO pt_tbindbw-opken,
            ln_betrg       TO pt_tbindbw-betrg,
            pi_p0008-waers TO pt_tbindbw-waers,
            lc_indnn       TO pt_tbindbw-indbw,
            lp_anznn       TO pt_tbindbw-anzhl.
      CLEAR pt_tbindbw-modna.
      PERFORM valor_modulo_valora_indirecta USING  pt_tbindbw-lgart
                                                   pi_molga
                                                   pi_p0001
                                                   pi_endda
                                         CHANGING  pt_tbindbw-modna
                                                   pi_t511.
      APPEND pt_tbindbw.
    ENDIF.
  ENDDO.

* Se consigue el importe indirecto segun indicador
  LOOP AT pt_tbindbw WHERE indbw = 'I'.
    EXIT.
  ENDLOOP.
  IF sy-subrc EQ 0.
*    PERFORM get_importe_indirecto_0008 TABLES pt_tbindbw
*                                       USING pi_molga
*                                             pi_p0001
*                                             pi_p0007
*                                             pi_p0008
*                                    CHANGING li_subrc.

  ENDIF.






ENDFUNCTION.
