create or replace procedure laf_pcp_001(attr_ in varchar2) is

-- p0 -> __lsResult
  p0_ VARCHAR2(32000) := NULL;

  -- p1 -> __sObjid
  p1_ VARCHAR2(32000) := client_sys.Get_Item_Value('objId_', attr_);

  -- p2 -> __g_Bind.s[0]
  p2_ VARCHAR2(32000) := NULL;

  -- p3 -> __lsAttr
  p3_ VARCHAR2(32000) := 'SET_TAX_FROM_ORIGINAL' || chr(31) ||
                         'FALSE' || chr(30) || 'MULTIPLE_TAX_LINES' ||
                         chr(31) || 'FALSE' || chr(30) ||
                         'TAX_CLASS_ID' || chr(31) || '' || chr(30);
  -- p4 -> __sAction
  p4_ VARCHAR2(32000) := 'DO';

  first_date_pcp_ VARCHAR2(32000) := NULL;
  rowkey_ varchar2(3200) := client_sys.Get_Item_Value('rowKey_', attr_);

BEGIN

  select cf$_pcp_date
  into first_date_pcp_
  from customer_order_line_cft
  where rowkey = rowkey_;

  p2_ := 'CF$_FIRST_DATE_PCP' || chr(31) || to_date(first_date_pcp_,'yyyy-mm-dd') || chr(30);

  IFSLAF.CUSTOMER_ORDER_LINE_CFP.Cf_Modify__(p0_, p1_, p2_, p3_, p4_);

END;
