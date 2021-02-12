-- LU: Laf_LogisticsSolution
-- Table: LAF_LOGISTICS_SOLUTION_CLT
-- Acionamento: Novos e Alterções
-- Campos: CF$_LOGISTICS_RESCHEDULING
-- Descrição: Não permitir a Data de Reagendamento logistico diferente de NULL com data diferente da data do PCP + 1 sem que o campos motivo do reagendamento esteja preenchido

DECLARE

  DATE_LOGISTICA_ VARCHAR2(3200) := NULL;

BEGIN
  SELECT CF$_DATE_LOGISTICA
    INTO DATE_LOGISTICA_
    FROM CUSTOMER_ORDER_LINE_CFV
   WHERE ORDER_NO = '&NEW:CF$_ORDER_NO'
     AND LINE_NO = '&NEW:CF$_ORDER_LINE_NO'
     AND REL_NO = '&NEW:CF$_ORDER_LINE_NO';

  IF '&NEW:CF$_LOGISTICS_RESCHEDULING' IS NOT NULL THEN
  
   IF '&NEW:CF$_LOGISTICS_RESCHEDULING' != DATE_LOGISTICA_ AND '&NEW:CF$_RESCHEDULING_REASON' IS NULL THEN
  
    RAISE_APPLICATION_ERROR(-20100,
                            ' LAF_LOG_004: Favor informar motivo do reagendamento da logísitca, não é possível reagendar sem motivo');
  
  END IF;

END IF;

END;