DECLARE
  -- p0 -> __lsResult
  p0_ VARCHAR2(32000) := NULL;

  -- p1 -> __sObjid
  p1_ VARCHAR2(32000) := NULL;

  -- p2 -> __g_Bind.s[0]
  p2_ VARCHAR2(32000) := 'CF$_DOCUMENT_STATE' || chr(31) ||
                         'LIBERADO PELA DIRETORIA' || chr(30);

  -- p3 -> __lsAttr
  p3_ VARCHAR2(32000) := '';

  -- p4 -> __sAction
  p4_ VARCHAR2(32000) := 'DO';

  Gerente_Comercial_ VARCHAR(3200) := NULL;

BEGIN
    SELECT POS_CODE INTO Gerente_Comercial_ FROM IFSLAF.COMPANY_PERSON_ALL WHERE PERSON_ID = (SELECT PERSON_ID FROM IFSLAF.PERSON_INFO_ALL WHERE USER_ID = (SELECT FND_USER FROM IFSLAF.FND_SESSION));

    select objid
      into p1_
      from ORDER_QUOTATION
     where QUOTATION_NO =
           :i_hWndFrame.frmOrderQuotation_Cust.ecmbsQuotationNo;

  IF Gerente_Comercial_ = '133' THEN
    IFSLAF.ORDER_QUOTATION_CFP.Cf_Modify__(p0_, p1_, p2_, p3_, p4_);
  ELSE
    RAISE_APPLICATION_ERROR(-20100, 'BDM: Você não tem permissão para executar esta ação');
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      RAISE_APPLICATION_ERROR(-20100, 'Erro para exutar o BDM');
    END;
  
END;
