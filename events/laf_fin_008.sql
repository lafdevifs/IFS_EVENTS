-- LU: CRecAfreementItem
-- Table: C_REC_AGREEMENT_ITEM_TAB
-- Campos: AGREEMENT_ID, ROWSTATE, LINE_NO - NEW & ALTER
-- Acionamentos: ROWSTATE = Released

DECLARE
  -- p0 -> __lsResult
  p0_ VARCHAR2(32000) := NULL;

  -- p1 -> __sObjid
  p1_ VARCHAR2(32000) := NULL;

  -- p2 -> __lsObjversion
  p2_ VARCHAR2(32000) := NULL;

  -- p3 -> __lsAttr
  p3_ VARCHAR2(32000) := NULL;


  -- p4 -> __sAction
  p4_ VARCHAR2(32000) := 'DO';

  REQUEST_DATE_  VARCHAR(3200);

BEGIN
select TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS')
INTO REQUEST_DATE_
from dual;

p3_  := 'CF$_AGREEMENT_ID' || chr(31) ||
                         '&NEW:AGREEMENT_ID' || chr(30) ||
                         'CF$_AGREEMENT_LINE_NO' || chr(31) ||
                         '&NEW:LINE_NO' || chr(30) ||  'CF$_APPROVED_ANALYSIS_CRED_DB' || chr(31) ||
                         '2' || chr(30)  ||  'CF$_ANALYSIS_REQUEST' || chr(31) ||  REQUEST_DATE_ || chr(30);

    

      IFSLAF.LAF_CREDIT_ANALYSIS_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);


END;