-- Evento para Bloqueio  Entradas de notas cuja Data de Emissão + Plano De Pagamento , crie um título já vencido a data da primeira parcela 
-- LU : FiscalNoteTemp
-- Tabela : FISCAL_NOTE_TEMP_TAB
-- Ação : Novos e Alateração (EMISSION_DATE)
-- Condições para execução NEW:ADDRESSEE_TYPE = 1, NEW:COMPANY != 40,  NEW:INPUT_OUTPUT_TYPE = 1

DECLARE
   -- Get dos dias a vencer a partir da data de emissão com base na condição de pagamento.
   p1_ NUMBER;
   -- data de emissão da NF pelo Cliente
   p2_ DATE;
   --  Calculo da data de venciemnto da primeira parcela 
   p3_ DATE;
   -- Data de hoje acrescida de dois dias 
   p4_ DATE := SYSDATE + 6;

   PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
   p1_ := payment_term_details_api.Get_Days_To_Due_Date('&NEW:COMPANY', '&NEW:PAY_TERM_ID', 1, 1);

   p2_ := to_date('&NEW:EMISSION_DATE', 'YYYY-MM-DD-HH24.MI.SS', 'NLS_CALENDAR=GREGORIAN');

   p3_ := (p2_ + p1_);

   dbms_output.put_line(p3_);
   dbms_output.put_line(p4_);

   IF ('&NEW:OPERATION_ID' != 1060 AND '&NEW:OPERATION_ID' != 1061) THEN
      IF (p3_ < p4_ AND p1_ <> 0) THEN
         raise_application_error(-20100, 'LAF_CENTRAL_NF_001: Data de vencimento da 1ª parcela é inferior a 7 dias corridos da data de emissão da nota!');
      END IF;
   END IF;
END;