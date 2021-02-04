-- LU: CustomerOrderLine
-- TABLE: CUSTOMER_ORDER_LINE_TAB
-- Ação: Novos e Alterações
-- Campo: ROWSATE

DECLARE

PRAGMA AUTONOMOUS_TRANSACTION;

  pcp_date_ varchar2(3200) := null;

BEGIN

  select cf$_pcp_date
    into pcp_date_
    from customer_order_line_cfv
   where order_no = '&NEW:ORDER_NO'
     and line_no = '&NEW:LINE_NO'
     and rel_no = '&NEW:REL_NO';

  IF pcp_date_ IS NULL THEN
  
    RAISE_APPLICATION_ERROR(-20100,
                            'Não é possível reservar linha, sem preencher a Data do PCP. Volte na Linhas da Ordem de Venda e informe a data do PCP da Ordem : ' ||
                            '&NEW:ORDER_NO' || '  linha :  '||
                            '&NEW:LINE_NO' || '  rel_no : '|| '&NEW:REL_NO');
  
  END IF;

END;