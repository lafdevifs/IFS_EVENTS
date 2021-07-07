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
      temp_ EQUIPMENT_OBJECT_MEAS_TAB.RECORDED_VALUE%TYPE;
      CURSOR get_attr IS
         SELECT RECORDED_VALUE
         FROM   EQUIPMENT_OBJECT_MEAS_TAB
         WHERE mch_code= mch_code_ 
         AND contract = contract_
         AND parameter_code = parameter_code_
         AND test_point_id = test_point_id_
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

END Laf_Equipment_Utils_Api;