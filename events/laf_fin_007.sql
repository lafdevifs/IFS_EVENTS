-- LU: OrderQuotation
-- Table: ORDER_QUOTATION_TAB
-- Campos: QUOTATION_NO, ROWSTATE - NEW & ALTER
-- Acionamento  ROWSTATE = Released

DECLARE
   -- p0 -> __lsResult
   p0_ VARCHAR2(32000) := NULL;

   -- p1 -> __sObjid
   p1_ VARCHAR2(32000) := NULL;

   -- p2 -> __lsObjversion
   p2_ VARCHAR2(32000) := NULL;

   -- p3 -> __lsAttr
   p3_ VARCHAR2(32000) := 'CF$_QUOTATION_NO'||chr(31)|| '&NEW:QUOTATION_NO'||chr(30);

   -- p4 -> __sAction
   p4_ VARCHAR2(32000) := 'DO';

BEGIN
    
IFSLAF.LAF_CREDIT_ANALYSIS_CLP.NEW__( p0_ , p1_ , p2_ , p3_ , p4_ );

END;

