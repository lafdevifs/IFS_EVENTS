-- LU: ReturnMaterial
-- Table: RETURN_MATERIAL_TAB
-- NOVOS & ALTERADOS (ROWSTATE)
-- Acionamento RowState = Released
DECLARE 

attr_  VARCHAR2(3200);
order_id_ VARCHAR2(3200) := '&NEW:ORDER_NO';

BEGIN

  client_sys.Add_To_Attr('orderId_',order_id_, attr_);

  transaction_SYS.Deferred_Call('LAF_LOG_003', attr_,'Create RMA Logistics Order');


END;