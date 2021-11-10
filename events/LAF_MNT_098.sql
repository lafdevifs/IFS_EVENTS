-- Atualização do valor inicial do critério do programa de tarefa com base no valor inicial da ultima revisão.
-- LU: PmAction
-- Tabela: PM_ACTION_TAB
-- Quando: Novos 
-- Campos: PM_PROGRAM_ID, PM_PROGRAM_REV, MCH_CODE_CONTRACT, MCH_CODE, ACTION_CODE_ID
-- Acionamento : 

DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  RESULT_      VARCHAR2(32000) := NULL;
  OBJID_       VARCHAR2(32000) := NULL;
  OBJVERSION_  VARCHAR2(32000) := NULL;
  ATTR_        VARCHAR2(32000) := NULL;
  ACTION_      VARCHAR2(32000) := 'DO';
  START_VALUE_ NUMBER := NULL;

  CURSOR GET_DATA IS
  
    SELECT B.OBJID, B.OBJVERSION, D.ACC_START_VALUE
    
      FROM IFSLAF.PM_PROGRAM_TASK_TEMPLATE A,
           IFSLAF.PM_PROGRAM_MAINT_TRIGGER B,
           IFSLAF.PM_ACTION                C,
           IFSLAF.PM_ACTION_CRITERIA       D
           
     WHERE A.PM_PROGRAM_ID = B.PM_PROGRAM_ID
       AND A.PM_PROGRAM_REV = B.PM_PROGRAM_REV
       AND A.TASK_TEMPLATE_ID = B.TASK_TEMPLATE_ID
       AND A.TASK_TEMPLATE_REV = B.TASK_TEMPLATE_REV
       AND A.PM_PROGRAM_ID = C.PM_PROGRAM_ID
       AND A.PM_PROGRAM_REV = C.PM_PROGRAM_REV
       AND A.ACTION_CODE_ID = C.ACTION_CODE_ID
       AND C.PM_NO = D.PM_NO
       AND C.PM_REVISION = D.PM_REVISION
       --AND A.PM_PROGRAM_ID = '&NEW:PM_PROGRAM_ID'
       --AND A.PM_PROGRAM_REV = '&NEW:PM_PROGRAM_REV'
       AND C.MCH_CODE_CONTRACT = '&NEW:MCH_CODE_CONTRACT'
       AND C.MCH_CODE = '&NEW:MCH_CODE'
       AND C.ACTION_CODE_ID = '&NEW:ACTION_CODE_ID'
       AND C.OBJSTATE = 'Active';

BEGIN

  OPEN GET_DATA;
  FETCH GET_DATA
    INTO OBJID_, OBJVERSION_, START_VALUE_;
  CLOSE GET_DATA;

  IF START_VALUE_ IS NOT NULL THEN
  
    ATTR_ := 'ACC_START_VALUE' || chr(31) || START_VALUE_ || chr(30);
  
    IFSLAF.PM_PROGRAM_MAINT_TRIGGER_API.MODIFY__(RESULT_,
                                                   OBJID_,
                                                   OBJVERSION_,
                                                   ATTR_,
                                                   ACTION_);
  
    COMMIT;
  END IF;
END;