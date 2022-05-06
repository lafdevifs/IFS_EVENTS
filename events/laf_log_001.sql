create or replace procedure LAF_LOG_001 (attr_ in varchar2) is

  PRAGMA AUTONOMOUS_TRANSACTION;


  cte_id_       VARCHAR2(3200) := client_sys.Get_Item_Value('idCte_',     attr_);
  cte_ov_       number;
  c_order_no_   VARCHAR2(3200) := NULL;
  po_order_no_  VARCHAR2(3200) := NULL;                                                                        
  forma_pag_    VARCHAR2(3200);
  cod_pag_      VARCHAR2(3200);
  vendedor_     VARCHAR2(3200); 

BEGIN
  
  SELECT CTE.CF$_ORDER_NO, CTE.CF$_PURCHASE_ORDER_NO, CTE.CTE_ORDER_NO
  INTO c_order_no_, po_order_no_, cte_ov_
  FROM C_CTE_BILL_OF_LADING_CFV CTE
  WHERE CTE.C_BILL_OF_LADDING_ID = cte_id_;
  
  IF c_order_no_ IS NOT NULL THEN
    
        SELECT CO.PAY_TERM_ID, CO.C_WAY_ID, co.SALESMAN_CODE
        INTO forma_pag_, cod_pag_, vendedor_
        FROM CUSTOMER_ORDER CO 
        WHERE  CO.ORDER_NO = c_order_no_;
        
        UPDATE CUSTOMER_ORDER_TAB CO
        SET CO.PAY_TERM_ID = forma_pag_
        ,CO.C_WAY_ID =  cod_pag_
        ,CO.SALESMAN_CODE =  vendedor_
        WHERE CO.ORDER_NO = cte_ov_;
        
        COMMIT;     
     
   ELSIF po_order_no_ IS NOT NULL THEN 
     
     SELECT PO.CF$_FORM_OF_PAYMENT, PO.PAY_TERM_ID
     INTO forma_pag_, cod_pag_
     FROM PURCHASE_ORDER_CFV PO
     WHERE PO.ORDER_NO = po_order_no_;

        UPDATE CUSTOMER_ORDER_TAB CO
        SET CO.PAY_TERM_ID = forma_pag_
        ,CO.C_WAY_ID =  cod_pag_
        WHERE CO.ORDER_NO = cte_ov_;

        COMMIT; 
  
  END IF;  

END;
