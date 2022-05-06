declare

  empresa_            varchar2(100):= null;
  empresa_name_       varchar2(3200) := null;
  empresa_cnpj_       varchar2(100) :=null;
  id_cliente_         varchar2(100):= null;
  nome_cliente_       varchar2(3200):= null;
  cnpj_               varchar2(100):= null;
  data_envio_         varchar2(100):= null;
  data_vencimento_    varchar2(100):=null;
  order_no_           varchar2(100):= null;
  contract_           varchar2(100):= null;
  agreement_id_       number := 0;
  id_contato_agree_   varchar2(100):= null;
  nome_contato_agree_ varchar2(3200):= null;
  email_contato_      varchar2(3200):= null;
  invoice_no_         varchar2(100):= null;
  ledger_date_        varchar2(100):= null;
  open_amount_        varchar2(100):= null;
  addr_no_            varchar2(100):= null;
  addr_name_          varchar2(3200):= null;
  operation_id_       number := 0;
  operation_name_     varchar2(3200) := null;
  
  text_               varchar2(3200);
  
  msg_text_           varchar2(3200);
  tit_text_           varchar2(3200);
  days_alert_         varchar2(100);
  ass_text_           varchar2(3200);
  empresa_text_       varchar2(100);
  
  cursor alertas_de_vencimento is 
   select rl.level_description,rl.reminder_text, rl.min_days_to_next_reminder, rl.company
     --into msg_text_, tit_text_
     from reminder_level rl
     where rl.company = '01'
     and rl.min_days_to_next_reminder > 0
     and rl.template_id = 1;
                                

begin
      
OPEN alertas_de_vencimento;
LOOP 
     FETCH alertas_de_vencimento
           INTO tit_text_, msg_text_,days_alert_, empresa_text_;
           
        EXIT WHEN alertas_de_vencimento%NOTFOUND; 
             
         select ciif.company,
         Company_api.Get_Name(company_ => ciif.company),
         company_br_tax_info_api.Get_Cnpj(company_ => ciif.company,address_id_ => customer_order_api.Get_Contract(order_no_ => ciif.order_reference)) Company_CNPJ,
         ciif.identity,
         ciif.identity_name,
         ciif.c_cnpj,
         trunc(sysdate) Data_Envio,
         ciif.c_due_date_org,
         ciif.order_reference Order_no,
         customer_order_api.Get_Contract(order_no_ => ciif.order_reference) contract,
         c_recurrent_agreement_api.Get_Main_Contact_Id(opportunity_no_ => customer_order_api.Get_C_Opportunity_No(order_no_ => ciif.order_reference),
                                                       agreement_id_   => customer_order_api.Get_C_Agreement_Id(order_no_ => ciif.order_reference)) Main_contact,
         customer_order_api.Get_C_Agreement_Id(order_no_ => ciif.order_reference) Agree,
         ciif.invoice_no,
         ciif.ledger_date,
         TO_CHAR(ciif.open_amount,'L99G999D99MI') Valor,
         customer_order_api.Get_Ship_Addr_No(order_no_ => ciif.order_reference) Addr_no,
         Customer_Info_Address_API.Get_Name(customer_id_ => ciif.identity,
                                            address_id_  => customer_order_api.Get_Ship_Addr_No(order_no_ => ciif.order_reference)) Addr_Name,
         customer_order_api.Get_Operation_Id(order_no_ => ciif.order_reference) ID_Opercaocao,
         Customer_Order_API.Get_Operation_Description(customer_order_api.Get_Operation_Id(order_no_ => ciif.order_reference)) Operacao
   into empresa_, empresa_name_ ,empresa_cnpj_ ,id_cliente_, nome_cliente_, cnpj_ , data_envio_, data_vencimento_ , order_no_, contract_,id_contato_agree_, agreement_id_, invoice_no_, ledger_date_, open_amount_, addr_no_, addr_name_, operation_id_, operation_name_
    from CUST_INV_INTEREST_FINE_QRY ciif
   where ciif.C_DUE_DATE_ORG = trunc(sysdate +days_alert_)
     and ciif.OPEN_AMOUNT > 0
     and ciif.company = empresa_text_
     --and ciif.order_reference = '316314'
     and ciif.CLIENT_INV_STATE != 'Cancelado'
     FETCH FIRST 1 ROWS ONLY;
     
      select NVL(CONTACT_ID,'10416'),
         Person_Info_API.Get_Name(NVL(CONTACT_ID,'10416')),
         --'lucas.moura@lafaete.com.br'
         Comm_Method_API.Get_Value('PERSON',
                                  CONTACT_ID,
                                   Comm_Method_Code_API.Decode('E_MAIL'),
                                   1,
                                   CONTACT_ADDRESS,
                                   sysdate)
    INTO id_contato_agree_,nome_contato_agree_,email_contato_
    from BUSINESS_OBJECT_CONTACT
   where contact_id = id_contato_agree_
   and business_object_id = agreement_id_
   and business_object_type_db = 'RECURRENT_AGREEMENT';
   
     text_ := 
        'Belo Horizonte , ' || data_envio_ || chr(10) || -- Local e Data de Envio
       
     
        'À ' || nome_cliente_ ||chr(10) ||
         'CNPJ : '|| cnpj_ || chr(10) || chr(10) || chr(10) || 
        
        'Prezado Cliente, ' || chr(10) ||
        'Pedimos gentileza de verificar se a(s) nota(s) fiscal/fiscais, descrita(s) abaixo esta(ão) programada(s) para pagamento conforme vencimento: ' || chr(10) || chr(10) ||chr(10) ||
        
        --'Nome do Contato : '|| nome_contato_agree_ || chr(10) ||
        --'Email do Contato : '|| email_contato_ || chr(10) ||
        'Número do Título : '|| invoice_no_ ||chr(10) ||
        'Data da Emissão : '|| ledger_date_ || chr(10) ||
        'Data do Vencimento : ' || data_vencimento_ || chr(10) ||
        'Valor em Aberto :'||open_amount_ || chr(10) ||
        'Contrato Recorrente : '||  agreement_id_ ||chr(10) ||
        'Natureza da Operação : ' || operation_name_ || chr(10) ||
        
         msg_text_ || chr(10) || chr(10) || chr(10) ||
        
        ' Em caso afirmativo, dúvidas ou demais solicitações, pedimos a gentileza de responder este e-mail Para o endereço creditoecobranca@lafaete.com.br. ' || chr(10) ||  chr(10) || chr(10) ||
        
        'Outros contatos:' || chr(10) ||
          'Crédito e Cobrança: (31) 2519-2969 / 2519-2989 / 2519-2973 ' || chr(10) ||
          'Agradecemos sua atenção e pronto retorno. É sempre um prazer atende-los! ' || chr(10) ||
          'Ficamos ao seu dispor,' || chr(10) ||
          'Equipe Financeira – Crédito e Cobrança ' || chr(10) ||  chr(10) || chr(10) ||
        
        'Grupo Lafaete : '|| chr(10)||
               empresa_name_ || ' / ' || 'CNPJ:' || empresa_cnpj_ || chr(10) || chr(10) ||
              ass_text_
       ;
       
         
       command_sys.Mail( 
                   from_user_name_ => 'ti@lafaete.com.br',
                   to_user_name_   => email_contato_,
                   subject_        => tit_text_,
                   text_           => text_
                   
                   );
           
           
END LOOP;
CLOSE alertas_de_vencimento;
END;
