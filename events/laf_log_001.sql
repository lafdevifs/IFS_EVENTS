-- LU: CustomerOrder
-- Table: CUSTOMER_ORDER_TAB
-- CAMPOS: ORDER_NO, ORDER_ID, ROWSTATE
-- Condição de execução ROWSTATE = Released

DECLARE 

attr_  VARCHAR2(3200);
order_id_ VARCHAR2(3200) := '&NEW:ORDER_NO';

BEGIN

IF '&NEW:ORDER_ID' = 'OV' OR '&NEW:ORDER_ID' ='OR' OR '&NEW:ORDER_ID' ='SCT' THEN

  client_sys.Add_To_Attr('orderId_',order_id_, attr_);

  transaction_SYS.Deferred_Call('LAF_LOG_001', attr_,'Create Logistics Order');

END IF;

END;