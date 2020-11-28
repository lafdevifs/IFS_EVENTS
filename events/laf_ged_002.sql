-- LU: DocIssue VIEW: DOC_ISSUE_TAB

DECLARE

USER_ALLOWED_CLASS_ VARCHAR(100);

CURSOR GET_ALLOWED_CLASS IS
SELECT doc_class
FROM DOCUMENT_ACCESS_TEMPLATE ac
INNER JOIN document_group_members gp
ON ac.group_id = gp.group_id  
WHERE ac.doc_class ='&NEW:DOC_CLASS' and gp.person_ID = '&NEW:DOC_RESP_SIGN';


BEGIN

OPEN GET_ALLOWED_CLASS;
FETCH GET_ALLOWED_CLASS INTO USER_ALLOWED_CLASS_;
CLOSE GET_ALLOWED_CLASS;

IF USER_ALLOWED_CLASS_ IS NULL THEN

RAISE_APPLICATION_ERROR(-20100,'VOCÊ NÃO POSSUI ACESSO PARA SALVAR NESTA CLASSE');

END IF;


END;