-- LU: DocReferenceObject Table: DOC_REFERENCE_OBJECT_TAB

DECLARE

  FOLDER_CLASS_ VARCHAR2(100);

  CURSOR GET_FOLDER_CLASS IS
    SELECT NOTE
      FROM DOC_FOLDER
     WHERE FOLDER_SEQUENCE =
           client_Sys.Get_Key_Reference_Value('&NEW:KEY_REF',
                                              'FOLDER_SEQUENCE');

BEGIN

  OPEN GET_FOLDER_CLASS;
  FETCH GET_FOLDER_CLASS
    INTO FOLDER_CLASS_;
  CLOSE GET_FOLDER_CLASS;

  IF '&NEW:DOC_CLASS' != FOLDER_CLASS_ THEN
  
    raise_application_error(-20100,
                            'ESTE DOCUMENTO NÃO PODE SER SALVO NESTA PASTA');
  
  END IF;

END;