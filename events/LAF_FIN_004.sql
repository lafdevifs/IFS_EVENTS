DECLARE

   OBJKEY_ VARCHAR2(3200) := &NEW:ROWKEY;
   USER_RESPONSE_ VARCHAR2(3200) := NULL;
   RESPONSE_DATE_ANALYSIS_ VARCHAR2(3200) := NULL;
   attr_ VARCHAR(3200) := NULL;

BEGIN

SELECT FND_USER 
INTO USER_RESPONSE_
FROM FND_SESSION;

  client_sys.Add_To_Attr('objKey_',OBJKEY_, attr_);
  client_sys.Add_To_Attr('userResponse_',USER_RESPONSE_ , attr_);

  transaction_SYS.Deferred_Call('LAF_FIN_004', attr_,'Save Date Approved Analysis e Person');

END;