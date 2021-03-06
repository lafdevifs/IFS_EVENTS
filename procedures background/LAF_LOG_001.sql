create or replace procedure laf_log_001(attr_ in varchar2) is

  PRAGMA AUTONOMOUS_TRANSACTION;

  -- p0 -> __lsResult
  p0_ VARCHAR2(32000) := '';

  -- p1 -> __sObjid
  p1_ VARCHAR2(32000) := '';

  -- p2 -> __lsObjversion
  p2_ VARCHAR2(32000) := '';

  -- p3 -> __lsAttr
  p3_ VARCHAR2(32000) := '';

  -- p4 -> __sAction
  p4_ VARCHAR2(32000) := 'DO';

  EXISTS_SERVICE_ VARCHAR2(3200) := NULL;
  ORDER_NO_       VARCHAR2(3200) := client_sys.Get_Item_Value('orderId_',
                                                              attr_);
  LINE_NO_        VARCHAR2(3200) := '';
  REL_NO_         VARCHAR2(3200) := '';
  QUOTATION_ID_   VARCHAR2(3200) := client_sys.Get_Item_Value('quotationId_',
                                                              attr_);
  AGREEMENT_ID_   VARCHAR2(3200) := client_sys.Get_Item_Value('agreementId_',
                                                              attr_);

  CURSOR GET_SALES_ORDER IS
    SELECT ORDER_NO, LINE_NO, REL_NO
      FROM CUSTOMER_ORDER_LINE
     WHERE ORDER_NO = ORDER_NO_;

  CURSOR GET_EXISTS_SERVICES IS
    select *
      from dual
     where EXISTS (select *
              from c_rec_agreement_item_serv ais
             inner join c_rec_agreement_item ai
                on ais.agreement_id = ai.agreement_id
             where ai.agreement_id = AGREEMENT_ID_
               and ai.delivery_order_no = ORDER_NO_)
        OR EXISTS (select *
              from order_quotation_line
             where catalog_type = 'Mat Não Estocável'
               and quotation_no = QUOTATION_ID_);

BEGIN

  OPEN GET_EXISTS_SERVICES;
  FETCH GET_EXISTS_SERVICES
    INTO EXISTS_SERVICE_;
  CLOSE GET_EXISTS_SERVICES;

  IF EXISTS_SERVICE_ IS NOT NULL THEN
  
    OPEN GET_SALES_ORDER;
    LOOP
      FETCH GET_SALES_ORDER
        INTO ORDER_NO_, LINE_NO_, REL_NO_;
    
      p3_ := 'CF$_ORDER_NO' || chr(31) || ORDER_NO_ || chr(30) ||
             'CF$_TYPE_LOGISTICS' || chr(31) || 'MOBILIZACAO' || chr(30) ||
             'CF$_ORDER_LINE_NO' || chr(31) || LINE_NO_ || chr(30) ||
             'CF$_ORDER_REL_NO' || chr(31) || REL_NO_ || chr(30) ||
             'CF$_STATUS_LOGISTICS_DB' || chr(31) || 'NO' || chr(30);
    
      EXIT WHEN GET_SALES_ORDER%NOTFOUND;
      IFSLAF.LAF_LOGISTICS_SOLUTION_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
    
    END LOOP;
    CLOSE GET_SALES_ORDER;
  
    COMMIT;
  END IF;
END;
