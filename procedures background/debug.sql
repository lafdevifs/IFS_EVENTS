

DECLARE
   -- p0 -> i_hWndFrame.frmManualSupplierInvoice_Ext.sFinalResult
   p0_ VARCHAR2(32000) := '';

   -- p1 -> i_hWndFrame.frmManualSupplierInvoice_Ext.nVoucherNoTemp
   p1_ FLOAT := NULL;

   -- p2 -> i_hWndFrame.frmManualSupplierInvoice_Ext.sMessage
   p2_ VARCHAR2(32000) := NULL;

   -- p3 -> i_hWndFrame.frmManualSupplierInvoice_Ext.sPoMessage
   p3_ VARCHAR2(32000) := '';

   -- p4 -> i_hWndFrame.frmManualSupplierInvoice_Ext.sCompany
   p4_ VARCHAR2(32000) := '01';

   -- p5 -> i_hWndFrame.frmManualSupplierInvoice_Ext.dfnInvoiceId
   p5_ FLOAT := 1341;

   -- p6 -> i_hWndFrame.frmManualSupplierInvoice_Ext.cmbsVouType
   p6_ VARCHAR2(32000) := 'I';

   -- p7 -> i_hWndFrame.frmManualSupplierInvoice_Ext.cmbsUserGroup
   p7_ VARCHAR2(32000) := 'AC';

   -- p8 -> i_hWndFrame.frmManualSupplierInvoice_Ext.dfdVouDate
   p8_ DATE := to_date('2020-10-27-00.00.00','YYYY-MM-DD-HH24.MI.SS','NLS_CALENDAR=GREGORIAN');

   -- p9 -> i_hWndFrame.frmManualSupplierInvoice_Ext.sOriginalState
   p9_ VARCHAR2(32000) := 'Contabilizado';

   -- p10 -> i_hWndFrame.frmManualSupplierInvoice_Ext.cmbAutomaticPayAuth
   p10_ VARCHAR2(32000) := 'Não';

   -- p11 -> i_hWndFrame.frmManualSupplierInvoice_Ext.dfsAuthId
   p11_ VARCHAR2(32000) := '*';

   -- p12 -> i_hWndFrame.frmManualSupplierInvoice_Ext.sIsNewInvoice
   p12_ VARCHAR2(32000) := 'FALSE';

   -- p13 -> i_hWndFrame.frmManualSupplierInvoice_Ext.sCreateJVoucher
   p13_ VARCHAR2(32000) := 'FALSE';

   -- p14 -> i_hWndFrame.frmManualSupplierInvoice_Ext.sCallingMethod
   p14_ VARCHAR2(32000) := '';

   -- p15 -> i_hWndFrame.frmManualSupplierInvoice_Ext.lsInfo
   p15_ VARCHAR2(32000) := '';

   -- p16 -> i_hWndFrame.frmManualSupplierInvoice.sCompany
   p16_ VARCHAR2(32000) := '01';

   -- p17 -> i_hWndFrame.frmManualSupplierInvoice.dfnInvoiceId
   p17_ FLOAT := 1341;

   -- p18 -> i_hWndFrame.frmManualSupplierInvoice.sTaxCodes
   p18_ VARCHAR2(32000) := NULL;

   -- p19 -> i_hWndFrame.frmManualSupplierInvoice.dfsStateDb
   p19_ VARCHAR2(32000) := 'Posted';

BEGIN
    IFSLAF.Log_SYS.Init_Debug_Session_('bp');
    
DECLARE current_row_state_ VARCHAR2(30) ;
    BEGIN
 IFSLAF.Man_Supp_Invoice_API.Data_Source_Save_Check_Ok__( p0_ , p1_ , p2_ , p3_ , p4_ , p5_ , p6_ , p7_ , p8_ , p9_ , p10_ , p11_ , p12_ , p13_ , p14_ );
    p15_ := IFSLAF.PAYMENT_PLAN_API.Get_Info_Message(p16_ , p17_ );
    current_row_state_ := IFSLAF.invoice_api.Get_Objstate(p16_ , p17_ );
    p18_ := IFSLAF.Tax_Handling_Invoic_Util_API.Get_Supp_Taxes_No_Liab_Date( p16_ , p17_ , p19_ , current_row_state_ );
    END;



END;
