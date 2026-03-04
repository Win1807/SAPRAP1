

FORM valor_modulo_valora_indirecta  USING    pi_lgart TYPE ptbindbw-lgart
                                             pi_molga TYPE molga
                                             pi_p0001 STRUCTURE p0001"#EC NEEDED
                                             pi_endda TYPE endda
                                    CHANGING po_modna TYPE ptbindbw-modna
                                             pi_t511  TYPE zhcmtt_t511_dc.
  DATA: lwa_t511 TYPE zhcms_t511_dc.

  READ TABLE pi_t511 INTO lwa_t511 WITH  KEY molga = pi_molga
                                                  lgart = pi_lgart
                                                  endda = pi_endda.
  IF sy-subrc EQ 0.
    po_modna = lwa_t511-modna.
  ELSE.
    SELECT molga lgart endda modna
           FROM t511
           APPENDING TABLE pi_t511
           WHERE molga = pi_molga AND
                 lgart = pi_lgart AND
                 endda = pi_endda.
    IF sy-subrc EQ 0.
      READ TABLE pi_t511 INTO lwa_t511 WITH  KEY molga = pi_molga
                                                      lgart = pi_lgart
                                                      endda = pi_endda.
      po_modna = lwa_t511-modna.
    ENDIF.
  ENDIF.

ENDFORM.                    " valor_modulo_valora_indirecta
