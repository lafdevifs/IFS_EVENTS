-- Evento impeditivo que a O.S. seja criado sem horimetro lançado
-- LU: ActiveSeparate
-- Table: HISTORIVAL_WORK_ORDER_TAB
-- Quando : Novos e Alteração : WO_STATUS_ID
-- Campos: C_FAULT_DATE, CONTRACT, LINE_NO, WO_STATUS_ID, WO_NO, REG_DATE, MCH_CODE
-- Condição NEW:WO_STATUS_ID = FINISHED

DECLARE

  p1_ TIMESTAMP;

  p2_ TIMESTAMP;

  p3_ number;

BEGIN

  BEGIN
    SELECT MIN(t.actual_start)
      INTO p1_
      FROM Jt_Task_Uiv T
     where wo_no = '&NEW:WO_NO';
     dbms_output.put_line(p1_);
    
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('Not Data Found');
  END;

  BEGIN
    SELECT MAX(T.actual_finish)
      into p2_
      FROM Jt_Task_Uiv T
     where wo_no = '&NEW:WO_NO';
     dbms_output.put_line(p2_);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('Not Data Found');
  END;

  BEGIN

    select count(reg_date)
      into p3_
      from EQUIPMENT_OBJECT_MEAS a
     where mch_code = '&NEW:MCH_CODE'
       and a.reg_date between p1_ and p2_
       and parameter_code = 'HR';
       
       dbms_output.put_line(p3_);
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('Not Data Found');
  END;

  if p3_ = 0 THEN
  
    raise_application_error(-20100,
                           'Laf Mnt_001 Diz: Horímetro desatualizado registre uma marcação para concluir a Ordem de Serviço');
  
    dbms_output.put_line('Teste Lafa');
  end if;

END;