DECLARE

  user_id_ varchar2(100) := null;
  user_name_ varchar2(100) := null;

BEGIN

  SELECT CF$_USER
    INTO user_id_
    FROM IFSLAF.LAF_DISCOUNT_RANGE_CLT
   WHERE CF$_USER = '&NEW:CF$_USER';

   SELECT USER_ID
   INTO user_name_
   FROM PERSON_INFO
   WHERE objkey = '&NEW:CF$_USER';
        
    IF user_id_ IS NOT NULL THEN
  
    RAISE_APPLICATION_ERROR(-20100, 'LAF_COM_010: O Vendedor(a): ' || user_name_ || ' , já possui alçada de desconto cadastrada, de ' ||&NEW:CF$_DISCOUNT||'% !');

    END IF;

    EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
    BEGIN 
        dbms_output.put_line(''); 
    END; 
END;