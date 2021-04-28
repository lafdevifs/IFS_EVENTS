create or replace procedure laf_FIN_004(attr_ in varchar2) is

  USER_RESPONSE_          VARCHAR2(3200) := client_sys.Get_Item_Value('userResponse_',
                                                                       attr_);
  RESPONSE_DATE_ANALYSIS_ VARCHAR2(3200) := NULL;
  p0_ VARCHAR2(32000) := NULL;
  p1_ VARCHAR2(32000) := NULL;
  p2_ VARCHAR2(32000) := NULL;
  p3_ VARCHAR2(32000) := NULL;
  p4_ VARCHAR2(32000) := 'DO';

BEGIN

  select TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
    INTO RESPONSE_DATE_ANALYSIS_
    from dual;
    
    SELECT OBJKEY, OBJVERSION
    INTO p1_, p2_
    FROM LAF_CREDIT_ANALYSIS_CLV
    WHERE OBJKEY = client_sys.Get_Item_Value('objKey_', attr_);    
    
    
  p3_ := 'CF$_USER_RESPONSE_ANALYSIS' || chr(31) || USER_RESPONSE_ ||
         chr(30) || 'CF$_REPONSE_ANALYSIS_DATE' || chr(31) ||
         RESPONSE_DATE_ANALYSIS_ || chr(30);

  IFSLAF.LAF_CREDIT_ANALYSIS_CLP.MODIFY__(p0_, p1_, p2_, p3_, p4_);

END;