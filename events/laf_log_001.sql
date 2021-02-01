-- LU: CustomerOrder
-- Table: CUSTOMER_ORDER_TAB
-- CAMPOS: ORDER_NO, ORDER_ID, ROWSTATE
-- Condição de execução ORDER_ID != SEO

DECLARE 


attr_  VARCHAR2(3200);
order_id_ VARCHAR2(3200) := '&NEW:ORDER_NO';
quotation_no_ VARCHAR2(3200) :='&NEW:QUOTATION_NO';
agreement_id_  VARCHAR2(3200) := '&NEW:C_AGREEMENT_ID';

BEGIN

IF '&NEW:ORDER_ID' = 'OV' OR '&NEW:ORDER_ID' = 'OR' OR '&NEW:ORDER_ID' ='SBT' THEN

  client_sys.Add_To_Attr('orderId_',order_id_, attr_);
  client_sys.Add_To_Attr('agreementId_',agreement_id_, attr_);
  client_sys.Add_To_Attr('quotationId_',quotation_no_, attr_);

  transaction_SYS.Deferred_Call('LAF_LOG_001', attr_,'Create Logistics Order');

END IF;

EXCEPTION WHEN NO_DATA_FOUND THEN 
BEGIN

dbms_output.put_line('Dados não encontrados');

END;
END;