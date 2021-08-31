CREATE OR REPLACE PROCEDURE LAF_JUR_001(attr_ in varchar2) is

  PRAGMA AUTONOMOUS_TRANSACTION;

  -- p1 -> __sObjid
  p1_ VARCHAR2(32000) := client_sys.Get_Item_Value('objId_', attr_);
  identity_ VARCHAR2(3200) := client_sys.Get_Item_Value('identityId_', attr_);
  
  -- Date input Type Invoice 
  date_now_ VARCHAR2(3200);
  company_ VARCHAR2(3200);
  invoice_id_ NUMBER;
  installment_id_ NUMBER;

BEGIN
  SELECT SYSDATE INTO date_now_ FROM DUAL;

  SELECT APP.company, APP.invoice_id, APP.installment_id
    INTO company_, invoice_id_,installment_id_
    FROM ABSTRACT_PAYMENT_PLAN2 APP
   WHERE APP.objid = p1_;

  BEGIN
    
  UPDATE PAYMENT_PLAN_TAB A
  SET A.C_CNPJ_JURIDICAL_DATE = date_now_
  WHERE A.COMPANY = company_
  AND A.IDENTITY = identity_
  AND A.INVOICE_ID = invoice_id_
  AND A.INSTALLMENT_ID = installment_id_;
  
    commit;
  EXCEPTION
    WHEN IFSLAF.Error_SYS.Err_Security_Checkpoint THEN
      raise;
    WHEN OTHERS THEN
      rollback;
      raise;
  END;

END;
