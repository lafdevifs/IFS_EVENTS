-- LU: FiscalNoteTemp
-- Table: FISCAL_NOTE
-- Campos: FNE_SEFAZ_STATUS_CODE = 100
-- Acionamentos: 

DECLARE

  attr_     VARCHAR2(3200);
  fiscal_note_id_    number :=&NEW:FISCAL_NOTE_ID;

BEGIN

  client_sys.Add_To_Attr('fnNoteId_', fiscal_note_id_, attr_);

  transaction_SYS.Deferred_Call('LAF_NF_001', attr_, 'Confirm and Print Fiscal Note with return 100 SEFAZ');


END;