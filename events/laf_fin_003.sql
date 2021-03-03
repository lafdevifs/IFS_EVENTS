-- LU: PurchaseOrder
-- Table: PURCHASE_ORDER_TAB
-- Campos: ROW_STATE 
-- Acionamentos: ROW_STATE != Released 

DECLARE

PAYMENT_FORM_ VARCHAR(3200) := NULL;

CURSOR GET_PAYMENT_FORM IS
SELECT 1 
FROM PURCHASE_ORDER_CFT
WHERE ROWKEY = '&NEW:ROWKEY';

BEGIN

OPEN GET_PAYMENT_FORM;
FETCH GET_PAYMENT_FORM INTO PAYMENT_FORM_;
CLOSE GET_PAYMENT_FORM;

IF '&NEW:ROWSTATE' = 'Released' OR '&NEW:ROWSTATE' = 'Confirmed' THEN

IF PAYMENT_FORM_ IS NULL THEN

RAISE_APPLICATION_ERROR (-20100, ' A Ordem de compra não pode ser fechada com a Forma de pagamento em Branco, Favor informar a forma de pagamento');

END IF;

END IF;

END;