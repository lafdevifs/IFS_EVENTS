-- LU: ManSuppInvoice
-- Table: INVOICE_TAB
-- Campos: ADV_INV, IDENTITY, PO_REF_NUMBER
-- Acionamento: ADV_INV = TRUE

DECLARE

  GROUP_FOR_NACIONAIS_ VARCHAR2(10);

  CURSOR GET_GROUP_FOR_NACIONAIS IS
    SELECT 1
      FROM IDENTITY_INVOICE_INFO A
     WHERE A.IDENTITY = '&NEW:IDENTITY'
       AND A.GROUP_ID = 'FORN. NACIONAIS';

BEGIN

  OPEN GET_GROUP_FOR_NACIONAIS;
  FETCH GET_GROUP_FOR_NACIONAIS
    INTO GROUP_FOR_NACIONAIS_;
  CLOSE GET_GROUP_FOR_NACIONAIS;

  IF '&NEW:PO_REF_NUMBER' IS NULL THEN
  
    RAISE_APPLICATION_ERROR(-20100,
                            'FLAG TÍTULO ANTECIPADO MARCADO DEVE CONTER REF PO INFORMADO');
  
  END IF;

    IF GROUP_FOR_NACIONAIS_ IS NULL THEN
      RAISE_APPLICATION_ERROR(-20100,
                              'O FORNECEDOR NÃO PERTERCE AO GRUPO DE FORNECEDORES NACIONAIS!');
    END IF;

END;
