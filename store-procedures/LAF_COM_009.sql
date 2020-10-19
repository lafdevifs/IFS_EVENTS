CREATE OR REPLACE PROCEDURE LAF_COM_009 (attr_ IN VARCHAR2) IS
--ação do evento para que as oportunidades de negécio sejam fechadas após criada um cotação de venda para a mesma
    r0_ VARCHAR2(32000) := '';

   -- r1 -> numero da oportunidade
   r1_ VARCHAR2(32000) := NULL;

   -- p0 -> numero da oportunidade
   p0_ VARCHAR2(32000) := NULL;

   -- p1 -> motivo de fechamento
   p1_ VARCHAR2(32000) := 'WON';

   -- p2 -> motivo de ganho da oportunidade
   p2_ VARCHAR2(32000) := '13';

   -- p3 -> i_hWndFrame.frmOpportunity.dfsLostTo
   p3_ VARCHAR2(32000) := '';

   -- p4 -> i_hWndFrame.frmOpportunity.dfsReasonNote
   p4_ VARCHAR2(32000) := '';

BEGIN
     r1_ := client_sys.Get_Item_Value('OPP_NUM', attr_);
     p0_ := client_sys.Get_Item_Value('OPP_NUM', attr_);
     IFSLAF.Log_SYS.Init_Debug_Session_('bp');

     r0_ := IFSLAF.Business_Opportunity_API.Is_Lines_In_Progress(r1_ );

     IFSLAF.BUSINESS_OPPORTUNITY_API.Set_Closed(
          p0_ ,
 p1_ ,
 p2_ ,
 p3_ ,
 p4_ );


END;
