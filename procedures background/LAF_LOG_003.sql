create or replace procedure laf_log_003(attr_ in varchar2) is

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

  ORDER_NO_         VARCHAR2(3200) := client_sys.Get_Item_Value('orderId_',attr_);
  LINE_NO_          VARCHAR2(3200) := '';
  REL_NO_           VARCHAR2(3200) := '';
  RMA_NO_           VARCHAR2(3200) := '';

  CURSOR GET_RETURN_ORDER IS
    SELECT ORDER_NO, LINE_NO, REL_NO, RMA_NO
      FROM RETURN_MATERIAL_LINE
     WHERE ORDER_NO = ORDER_NO_;

BEGIN


        OPEN GET_RETURN_ORDER;
        LOOP
          FETCH GET_RETURN_ORDER
            INTO ORDER_NO_, LINE_NO_, REL_NO_, RMA_NO_;

          p3_ := 'CF$_ORDER_NO' || chr(31) || ORDER_NO_ || chr(30) ||
                 'CF$_TYPE_LOGISTICS' || chr(31) || 'DESMOBILIZACAO' ||
                 chr(30) || 'CF$_ORDER_LINE_NO' || chr(31) || LINE_NO_ ||
                 chr(30) || 'CF$_ORDER_REL_NO' || chr(31) || REL_NO_ ||
                 chr(30) || 'CF$_RMA_NO' || chr(31) || RMA_NO_ ||
                 chr(30) || 'CF$_STATUS_LOGISTICS_DB' || chr(31) || 'NO' ||
                 chr(30);

          EXIT WHEN GET_RETURN_ORDER%NOTFOUND;
          IFSLAF.LAF_LOGISTICS_SOLUTION_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);

        END LOOP;
        CLOSE GET_RETURN_ORDER;

        COMMIT;
END;
