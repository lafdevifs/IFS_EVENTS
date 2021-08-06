create or replace procedure LAF_NF_001 (attr_ in VARCHAR2) is

  PRAGMA AUTONOMOUS_TRANSACTION;
  
  p0_ VARCHAR2 (3200);
  
  fn_note_id_ VARCHAR2(3200) := client_sys.Get_Item_Value('fnNoteId_', attr_);
  
  -- p1 -> __FiscalNoteId
  p1_ NUMBER ;

BEGIN
  p1_ := to_number(fn_note_id_);
  begin
        p0_ := IFSLAF.Fiscal_Note_Temp_API.Is_Send_Allowed(fiscal_note_id_ => p1_);
        EXCEPTION 
        WHEN IFSLAF.Error_SYS.Err_Security_Checkpoint THEN 
        raise; 
        WHEN OTHERS THEN 
        rollback; 
        raise; 
    end;
    begin
        p0_ := IFSLAF.Fiscal_Note_Temp_API.Is_Remove_Fn_Allowed(fiscal_note_id_ =>  p1_ ); 
        EXCEPTION 
        WHEN IFSLAF.Error_SYS.Err_Security_Checkpoint THEN 
        raise; 
        WHEN OTHERS THEN 
        rollback; 
        raise; 
    end;  
    begin        
        p0_ := IFSLAF.Fiscal_Note_Temp_API.Is_Send_Void_Allowed(fiscal_note_id_ => p1_ ); 
        EXCEPTION 
        WHEN IFSLAF.Error_SYS.Err_Security_Checkpoint THEN 
        raise; 
        WHEN OTHERS THEN 
        rollback; 
        raise; 
    end;
    begin 
      p0_ := IFSLAF.Fiscal_Note_Temp_API.Is_Void_Allowed(fiscal_note_id_ => p1_ ); 
      EXCEPTION 
      WHEN IFSLAF.Error_SYS.Err_Security_Checkpoint THEN 
      raise; 
      WHEN OTHERS THEN 
      rollback; 
      raise; 
    end;
    begin 
        p0_ := IFSLAF.Fiscal_Note_Temp_API.Is_Confirm_Allowed(fiscal_note_id_ =>  p1_ ); 
        EXCEPTION 
        WHEN IFSLAF.Error_SYS.Err_Security_Checkpoint THEN 
        raise; 
        WHEN OTHERS THEN 
        rollback; 
        raise; 
    end;
    begin 
        IFSLAF.Fiscal_Note_Temp_Util_API.Generate_Final_Fn_Co(fiscal_note_id_ =>  p1_ ); 
        EXCEPTION 
        WHEN IFSLAF.Error_SYS.Err_Security_Checkpoint THEN 
        raise; 
        WHEN OTHERS THEN 
        rollback; 
        raise; 
    end;
    begin 
        p0_ := IFSLAF.Fiscal_Note_API.C_Is_Document_Model_Rec(fiscal_note_id_ => p1_ ); 
        commit; 
        EXCEPTION 
        WHEN IFSLAF.Error_SYS.Err_Security_Checkpoint THEN 
        raise; 
        WHEN OTHERS THEN 
        rollback; 
        raise; 
    end;
END;
