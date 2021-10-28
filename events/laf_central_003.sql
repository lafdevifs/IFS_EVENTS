-- Confere igualdade entre condições de pagamento da ordem de compra e da NF 
-- LU : FiscalNoteTemp
-- Table: FISCAL_NOTE_TEMP_TAB
-- Ação: Novos
-- Campos : INPUT_OUTPUT_TYPE,  FISCAL_NOTE_TYPE
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;

  PAY_TERM_PO_ VARCHAR2(50);
  INPUT_PAY_TERM_ VARCHAR2(50) := '&NEW:PAY_TERM_ID';

  CURSOR GET_PAY_TERM_PO IS
    SELECT PURCHASE_ORDER_API.Get_Pay_Term_Id(ORDER_NO)
      FROM FN_CUST_PURC_ORDER
     WHERE FISCAL_NOTE_ID = &NEW:FISCAL_NOTE_ID;

BEGIN

  OPEN GET_PAY_TERM_PO;
  LOOP
    FETCH GET_PAY_TERM_PO
      INTO PAY_TERM_PO_;

  IF PAY_TERM_PO_ <> INPUT_PAY_TERM_  THEN
    
      raise_application_error(-20100,
                              'Laf_Central_NF_003 Diz: Condição de Pagamento inserida ' || INPUT_PAY_TERM_ || ' é difere da proposta na ordem de compra '||PAY_TERM_PO_ || ' !' );
    
    END IF;
  
    EXIT WHEN GET_PAY_TERM_PO%NOTFOUND;
  
  END LOOP;
  CLOSE GET_PAY_TERM_PO;

END;