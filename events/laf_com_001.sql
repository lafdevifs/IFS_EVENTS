-- LU: OrderQuotation
-- Tabela: ORDER_QUOTATION_TAB
-- Campos: ADDITIONAL_DISCOUNT - NEW & ALTER
-- Condição de Ação: ADDITIONAL_DISCOUNT > 0

DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  DISCOUNT_ALLOW_ NUMBER := 0;
  DISCOUNT_       NUMBER := NULL;

  CURSOR GET_DISCOUNT IS
    SELECT DISCOUNT
      FROM ORDER_QUOTATION_LINE
     WHERE QUOTATION_NO = '&NEW:QUOTATION_NO';

BEGIN

  SELECT (CF$_DISCOUNT * 100)
    INTO DISCOUNT_ALLOW_
    FROM IFSLAF.LAF_DISCOUNT_RANGE_CLV
   WHERE CF$_USER IN (SELECT PERSON_ID
                        FROM IFSLAF.FND_SESSION
                       INNER JOIN IFSLAF.PERSON_INFO
                          ON FND_USER = USER_ID);

  OPEN GET_DISCOUNT;
  LOOP
    FETCH GET_DISCOUNT
      INTO DISCOUNT_;
    EXIT WHEN GET_DISCOUNT%NOTFOUND;
  
    IF (&NEW:ADDITIONAL_DISCOUNT + DISCOUNT_) > DISCOUNT_ALLOW_ THEN
    
      RAISE_APPLICATION_ERROR(-20100,
                              'LAF_COM_001: Descont aplicado acimo do permitido para seu usuário!');
    
    END IF;
  END LOOP;

END;