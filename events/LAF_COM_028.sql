DECLARE

  SALES_ALLOW_          VARCHAR2(3200) := NULL;
  REPRESENTATIVE_ALLOW_ VARCHAR2(3200) := NULL;

  CURSOR GET_SALES_ALLOW IS
  SELECT 1
    FROM LAF_SALES_MAN_REGION_CLV
   WHERE CF$_DISTRICT_CODE IN
         (select DISTRICT_CODE
            from cust_ord_customer_address_ent
           where customer_id = '&NEW:CUSTOMER_ID'
             and address_id = '&NEW:SHIP_ADDR_NO')
     AND CF$_SALESMAN IN
         (select person_id
            from person_info_all
           where user_id in (select fnd_user from fnd_session));

BEGIN

OPEN GET_SALES_ALLOW;
FETCH GET_SALES_ALLOW INTO SALES_ALLOW_;
CLOSE GET_SALES_ALLOW;

  SELECT REPRESENTATIVE_ID
    INTO REPRESENTATIVE_ALLOW_
    FROM BUSINESS_REPRESENTATIVE
   WHERE REPRESENTATIVE_ID IN
         (select person_id
            from person_info_all
           where user_id in (select fnd_user from fnd_session));

    IF REPRESENTATIVE_ALLOW_ IS NULL THEN
        IF SALES_ALLOW_ IS NULL 

        RAISE_APPLICATION_ERROR(-20100,
                                'Laf_Com_028 Diz : A cidade da entrega esta fora da sua região de atuação');
        END IF;

    END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
    
      RAISE_APPLICATION_ERROR(-20100,
                              'Laf_Com_028 Diz : Vendedor não possui área de atuação parametrizada, favor inserir na tela de Vendedor por região, em dados básicos de Vendas');
    
    END;
  
END;
