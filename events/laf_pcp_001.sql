-- LU: CustomerOrderLine
-- Table: CUSTOMER_ORDER_LINE_CFT
-- Campos: CF$_PCP_DATE (NEW & OLD), ROWKEY - NEW & ALTER
-- Acionamentos: 

DECLARE

  attr_     varchar2(3200);
  objid_    varchar2(3200);
  rowkey_ varchar2(3200);

BEGIN

IF '&NEW:CF$_PCP_DATE' IS NOT NULL THEN

IF '&OLD:CF$_PCP_DATE'  is null THEN

select objid, objkey
into objid_, rowkey_
from customer_order_line
where objkey = '&NEW:ROWKEY';

  client_sys.Add_To_Attr('objId_', objid_, attr_);
  client_sys.Add_To_Attr('rowKey_', rowkey_, attr_);

  transaction_SYS.Deferred_Call('LAF_PCP_001', attr_, 'First Date PCP');
END IF;

END IF;

END;