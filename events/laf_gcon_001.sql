DECLARE

  attr_     VARCHAR2(3200);
  fiscal_note_id_    number :=&NEW:FISCAL_NOTE_ID;
  flag_  number:= &FLAG_MOB_DESMONTADA_;


BEGIN

  client_sys.Add_To_Attr('fnNoteId_', fiscal_note_id_, attr_);
  client_sys.Add_To_Attr('fnNoteFlag_',flag_, attr_);
  transaction_SYS.Deferred_Call('LAF_GCON_001', attr_, 'Flag Mobilizacao Desmontada');

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      DBMS_OUTPUT.PUT_LINE('');
    END;

END;