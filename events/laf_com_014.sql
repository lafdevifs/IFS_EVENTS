-- LU: OrderQuotaionLine
-- Tabela: ORDER_QUOTAION_LINE_TAB
-- Campos: ADDITIONAL_DISCOUNT, QUOTATION_NO, DISCOUNT - NEW & ALTER (DISCOUNT)
-- Acionamento: DISCOUNT != 0

DECLARE 

PRAGMA AUTONOMOUS_TRANSACTION;

DISCOUNT_ALLOW_ NUMBER := 0;
DISCOUNT_TOTAL_INPUT_ NUMBER :=0;

BEGIN

SELECT (CF$_DISCOUNT * 100)
INTO DISCOUNT_ALLOW_ 
FROM IFSLAF.LAF_DISCOUNT_RANGE_CLV 
WHERE CF$_USER IN (
SELECT PERSON_ID 
FROM IFSLAF.FND_SESSION
INNER JOIN IFSLAF.PERSON_INFO
ON FND_USER = USER_ID
);

SELECT SUM(
 (((SALE_UNIT_PRICE - CF$_UNITPRICE) *100) / SALE_UNIT_PRICE) 
)
INTO DISCOUNT_TOTAL_INPUT_
FROM ORDER_QUOTATION_LINE_CFV 
WHERE QUOTATION_NO ='&NEW:QUOTATION_NO';

IF (&NEW:ADDITIONAL_DISCOUNT + &NEW:DISCOUNT ) > DISCOUNT_ALLOW_  THEN 

   RAISE_APPLICATION_ERROR(-20100,'LAF_COM_014: Desconto aplicado acima do permitido para seu usuário!');
END IF;

END;

