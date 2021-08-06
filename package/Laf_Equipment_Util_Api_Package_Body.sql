CREATE OR REPLACE PACKAGE BODY Laf_Equipment_Utils_Api is 


FUNCTION Laf_Get_Prev_Recorded_Value_By_Date (

   date_             IN DATE,
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   test_point_id_    IN VARCHAR2,
   parameter_code_   IN VARCHAR2) RETURN NUMBER
IS
   
   FUNCTION Core (
      date_         IN DATE,
      contract_         IN VARCHAR2,
      mch_code_         IN VARCHAR2,
      test_point_id_    IN VARCHAR2,
      parameter_code_   IN VARCHAR2) RETURN NUMBER
   IS
      temp_ EQUIPMENT_OBJECT_MEAS_TAB.MEASURED_VALUE%TYPE;
      CURSOR get_attr IS
         SELECT MEASURED_VALUE
         FROM   EQUIPMENT_OBJECT_MEAS_TAB 
         WHERE mch_code= mch_code_ 
         AND contract = contract_
         AND parameter_code = parameter_code_
         AND test_point_id = test_point_id_
         AND measurement_type = 'RecordedReading'
         AND reg_date < date_
         ORDER BY reg_date DESC;
   BEGIN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
      RETURN temp_;
   END Core;

BEGIN
   General_SYS.Init_Method(Laf_Equipment_Utils_Api.lu_name_, 'Laf_Equipment_Utils_Api', 'Laf_Get_Prev_Recorded_Value_By_Date');
   RETURN Core(date_, contract_, mch_code_, test_point_id_, parameter_code_);
END Laf_Get_Prev_Recorded_Value_By_Date;

-- CALCULO DE TEMPO EM MANUTENCAO DO EQUIPAMENTO SOMANDO AS DIFERENÇA DE INICIO E TERMINO DE CADA TAREFA SOMANDO OS RESULTADO E AGRUPANDO NO PERIODO MM/YYYY
FUNCTION Laf_Calc_TM_MTBF (

   date_             IN DATE,
   mch_code_         IN VARCHAR2,
   contract_         IN VARCHAR2) RETURN FLOAT
IS 
   FUNCTION CORE (
     date_           IN DATE,
     mch_code_       IN VARCHAR2,
     contract_       IN VARCHAR2) RETURN FLOAT
   IS
     temp_ FLOAT;
     CURSOR get_attr IS
     SELECT SUM(24*(JTU.actual_finish -JTU.actual_start)) HORAS
     FROM  IFSLAF.JT_TASK_UIV JTU
     WHERE JTU.work_type_id = 'COR'
     AND JTU.ACTUAL_OBJECT_ID = mch_code_
     AND JTU.SITE = contract_
     AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
     AND SUBSTR(JTU.actual_start,4,6) =  SUBSTR(date_,4,6)
     AND SUBSTR(JTU.actual_finish,4,6) = SUBSTR(date_,4,6)
     GROUP BY SUBSTR(JTU.actual_start,4,6) , SUBSTR(JTU.actual_finish,4,6);
     
     BEGIN
       OPEN get_attr;
       FETCH get_attr INTO temp_;
       CLOSE get_attr;
       RETURN temp_;
     END Core;

BEGIN
   General_SYS.Init_Method(Laf_Equipment_Utils_Api.lu_name_, 'Laf_Equipment_Utils_Api', 'Laf_Calc_TM_MTBF');
   RETURN Core(date_, mch_code_,contract_);
END Laf_Calc_TM_MTBF;

-- CALCULA A QTS DE OS ABERTA PARA O EQUIPAMENTO NESTE SITE NO PERIODO MM/YYYY
FUNCTION Laf_Calc_Qtd_Os (
  date_             IN DATE,
  mch_code_         IN VARCHAR2,
  contract_         IN VARCHAR2)RETURN NUMBER
IS
  FUNCTION CORE(
    date_           IN DATE,
    mch_code_       IN VARCHAR2,
    contract_       IN VARCHAR2) RETURN NUMBER
  IS
    temp_ JT_TASK_TAB.WO_NO%TYPE;
    CURSOR get_attr IS
      SELECT COUNT(WO_NO) AS OS
      FROM  IFSLAF.JT_TASK_UIV JTU
      WHERE JTU.work_type_id = 'COR'
      AND JTU.ACTUAL_OBJECT_ID = mch_code_
      AND JTU.SITE = contract_
      AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
      AND SUBSTR(JTU.actual_start,4,6) = SUBSTR(date_,4,6)
      AND SUBSTR(JTU.actual_finish,4,6) = SUBSTR(date_,4,6)
      GROUP BY SUBSTR(JTU.actual_start,4,6) , SUBSTR(JTU.actual_finish,4,6);
      
   BEGIN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
      RETURN temp_;
   END Core;
BEGIN
   General_SYS.Init_Method(Laf_Equipment_Utils_Api.lu_name_, 'Laf_Equipment_Utils_Api', 'Laf_Calc_Qtd_Os');
   RETURN Core(date_, mch_code_,contract_);
END Laf_Calc_Qtd_Os;

END Laf_Equipment_Utils_Api;