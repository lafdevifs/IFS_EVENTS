CREATE OR REPLACE PROCEDURE LAF_GCON_001(attr_ IN VARCHAR2) IS

  fn_note_id_ VARCHAR2(3200) := client_sys.Get_Item_Value('fnNoteId_', attr_);  
  flag_ varchar2(3200) := client_sys.Get_Item_Value('fnNoteId_', attr_);
  OBJKEY_     VARCHAR2(3200);
  
BEGIN

  SELECT OBJEKY
    INTO OBJKEY_
    FROM FISCAL_NOTE
   WHERE FISCAL_NOTE_ID = fn_note_id_;

  update fiscal_note_cfT FN
     set FN.CF$_MOBILIZACAO_DESMONTADA = flag_
   where FN.ROWKEY = OBJEKY_;

  COMMIT;

END;
