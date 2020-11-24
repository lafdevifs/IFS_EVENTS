-- LU: DocIssue View: DOC_ISSUE_TAB

declare

  attr_ varchar2(32000);

begin

  client_sys.Add_To_Attr('DOC_CLASS', '&NEW:DOC_CLASS', attr_);
  client_sys.Add_To_Attr('DOC_NO', '&NEW:DOC_NO', attr_);
  client_sys.Add_To_Attr('DOC_SHEET', '&NEW:DOC_SHEET', attr_);
  client_sys.Add_To_Attr('DOC_REV', '&NEW:DOC_REV', attr_);

  transaction_SYS.Deferred_Call('LAF_SAVE_DOC_FOLDER',
                                attr_,
                                'Vincular Documento na Pasta');

end;