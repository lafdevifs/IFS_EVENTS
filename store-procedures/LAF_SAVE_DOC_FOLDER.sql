CREATE OR REPLACE PROCEDURE LAF_SAVE_DOC_FOLDER(attr_ IN VARCHAR2) IS

  p0_ VARCHAR2(32000) := NULL;
  p1_ VARCHAR2(32000) := NULL;
  p2_ VARCHAR2(32000) := NULL;
  p3_ VARCHAR2(32000) := NULL;
  p4_ VARCHAR2(32000) := 'DO';

  p5_ VARCHAR2(3200); /*key ref*/

  doc_class_ varchar2(32000);
  doc_no_    varchar2(32000);
  doc_sheet_ varchar2(32000);
  doc_rev_   varchar2(32000);

  CURSOR GET_KEY_REF IS
    SELECT client_Sys.Get_Key_Reference_From_Objkey('DocFolder', OBjkey)
      FROM DOC_FOLDER
     WHERE NOTE = doc_class_; /*VARIAVEL*/

BEGIN

  doc_class_ := client_sys.Get_Item_Value('DOC_CLASS', attr_);
  doc_no_    := client_sys.Get_Item_Value('DOC_NO', attr_);
  doc_sheet_ := client_sys.Get_Item_Value('DOC_SHEET', attr_);
  doc_rev_   := client_sys.Get_Item_Value('DOC_REV', attr_);

  /*  p3_ := 'LU_NAME' || chr(31) || 'DocFolder' || chr(30) || 'KEY_REF' ||
           chr(31) || 'FOLDER_SEQUENCE=1000008^' || chr(30) || 'DOC_CLASS' ||
           chr(31) || 'UBH-GTI-INF' || chr(30) || 'DOC_NO' || chr(31) ||
           '1000031' || chr(30) || 'DOC_SHEET' || chr(31) || '1' || chr(30) ||
           'KEEP_LAST_DOC_REV' || chr(31) || 'Fixo' || chr(30) || 'DOC_REV' ||
           chr(31) || 'A1' || chr(30) || 'COPY_FLAG' || chr(31) || 'OK' ||
           chr(30) || 'SURVEY_LOCKED_FLAG' || chr(31) || 'Desbloqueado' ||
           chr(30);
  */

  OPEN GET_KEY_REF;
  FETCH GET_KEY_REF
    INTO p5_;
  CLOSE GET_KEY_REF;

  p3_ := 'LU_NAME' || chr(31) || 'DocFolder' || chr(30) || 'KEY_REF' ||
         chr(31) || p5_ || chr(30) || 'DOC_CLASS' || chr(31) || doc_class_ ||
         chr(30) || 'DOC_NO' || chr(31) || doc_no_ || chr(30) ||
         'DOC_SHEET' || chr(31) || doc_sheet_ || chr(30) ||
         'KEEP_LAST_DOC_REV' || chr(31) || 'Fixo' || chr(30) || 'DOC_REV' ||
         chr(31) || doc_rev_ || chr(30) || 'COPY_FLAG' || chr(31) || 'OK' ||
         chr(30) || 'SURVEY_LOCKED_FLAG' || chr(31) || 'Desbloqueado' ||
         chr(30);

  IFSLAF.Log_SYS.Init_Debug_Session_('bp');

  IFSLAF.DOC_REFERENCE_OBJECT_API.NEW__(p0_, p1_, p2_, p3_, p4_);

END LAF_SAVE_DOC_FOLDER;
