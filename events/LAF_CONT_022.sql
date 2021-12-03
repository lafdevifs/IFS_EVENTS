-- Lu: CustomerOrderLine
-- Table: Customer_order_line_tab
-- Ação: Alteração (Qaundo a linha for reservada o campos será alterada de null para o Serial)
-- Descrição : Imperdir que seriais com menos de 1 ano sejam reservados na Ordem de Venda do Tipo OV para o Id de operação Venda 
-- Atributos Customizados ORDER_ID = &AO.CUSTOMER_ORDER_API.Get_Order_Id(order_no => &NEW:ORDER_NO) STRING
-- Condição NEW:ROWSTATE = Reserved

DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  serial_no_       varchar2(3200) := null;
  acquisiton_date_ varchar2(3200);
  order_id_        varchar2(3200) :='&ORDER_ID';
  operation_id_ number := null;

BEGIN

select SERIAL_NO
INTO serial_no_
from ifslaf.SINGLE_MANUAL_RESERVATION_ALT
where SOURCE_REF1 =  '&NEW:ORDER_NO'
AND SOURCE_REF2 =  '&NEW:LINE_NO'
AND SOURCE_REF3 = '&NEW:REL_NO'
AND SOURCE_REF_TYPE_DB = 'CUSTOMER_ORDER'
FETCH FIRST 1 ROWS ONLY;

  select acquisition_date
    into acquisiton_date_
    from ifslaf.fa_object
   where object_id = serial_no_
   FETCH FIRST 1 ROWS ONLY;

  select operation_id
  into operation_id_ 
  from ifslaf.customer_order
  where order_no = '&NEW:ORDER_NO'
  FETCH FIRST 1 ROWS ONLY;
  
IF order_id_ = 'OV' THEN
    IF acquisiton_date_ > (sysdate - 365 ) and operation_id_ = 2040 THEN
    
      RAISE_APPLICATION_ERROR(-20100,
                              'Laf_Cont_022: Não é possível reservar o serial: ' || serial_no_ || ' com a operação fiscal de venda acima de um ano porque o bem adiquirido em: '||acquisiton_date_ );
    
   END IF;
   IF acquisiton_date_ < (sysdate - 365 )  and operation_id_ = 2039 THEN
    
      RAISE_APPLICATION_ERROR(-20100,
                              'Laf_Cont_022: Não é possível reservar o serial: ' || serial_no_ || ' com a operação fiscal de venda abaixo de um ano porque o bem adiquirido em: '||acquisiton_date_ );
    
   END IF;
END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
     dbms_output.put_line('Não foi encontrados dados!');
    END;
END;