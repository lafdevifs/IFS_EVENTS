-- LU: CRecAgreementItem
-- Tabela: C_REC_AGREEMENT_ITEM_SERV_TAB
-- Campos: AGREEMENT_ID, DISCOUNT NEW & ALTER (DISCOUNT)
-- Acionamentos: DISCOUNT != DISCOUNT

DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  DISCOUNT_ALLOW_ NUMBER := 0;
  DISCOUNT_INPUTED_ NUMBER :=NULL;

BEGIN

  SELECT CF$_DISCOUNT
    INTO DISCOUNT_ALLOW_
    FROM IFSLAF.LAF_DISCOUNT_RANGE_CLV
   WHERE CF$_USER IN (SELECT PERSON_ID
                        FROM IFSLAF.FND_SESSION
                       INNER JOIN IFSLAF.PERSON_INFO
                          ON FND_USER = USER_ID);

  IF (&NEW:DISCOUNT+0) > DISCOUNT_ALLOW_ THEN
  
    RAISE_APPLICATION_ERROR(-20100,'Desconto aplicado acima do permitido para seu usuário! Seu usuário possui permissão de  : ' || DISCOUNT_ALLOW_ || '%');
  
  END IF;
  exception
  when no_data_found then
  begin

      RAISE_APPLICATION_ERROR(-20100,'Vendedor não possui desconto parametrizado');

  end;

END;
