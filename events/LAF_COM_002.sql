DECLARE

attr_ VARCHAR2(3200);
address_id_ VARCHAR2(3200):= '&NEW:ADDRESS_ID';
customer_id_ VARCHAR2(3200):= '&NEW:CUSTOMER_ID';


BEGIN

  client_sys.Add_To_Attr('customerId_',customer_id_, attr_);
  client_sys.Add_To_Attr('addressId_',address_id_, attr_);

  transaction_SYS.Deferred_Call('LAF_COM_002', attr_,'Registrar Imposto de Cliente');

END;