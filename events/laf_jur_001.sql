DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  attr_       VARCHAR2(3200);
  objid_      VARCHAR2(3200) := NULL;
  identityid_ VARCHAR2(3200) := '&NEW:IDENTITY';

BEGIN
    SELECT APP.objid
    INTO objid_
      FROM ABSTRACT_PAYMENT_PLAN2 APP
     WHERE APP.OBJKEY = '&NEW:ROWKEY';

  client_sys.Add_To_Attr('objId_', objid_, attr_);
  client_sys.Add_To_Attr('identityId_', identityid_, attr_);

  transaction_SYS.Deferred_Call('LAF_JUR_001', attr_, 'Data JurIdico');

commit;

END;