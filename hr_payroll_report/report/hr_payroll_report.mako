<!DOCTYPE html SYSTEM "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <style type="text/css">
            .account_level_1 {
                text-transform: uppercase;
                font-size: 15px;
                background-color:#F0F0F0;
            }

            .account_level_2 {
                font-size: 12px;
                background-color:#F0F0F0;
            }

            .regular_account_type {
                font-weight: normal;
            }

            .view_account_type {
                font-weight: bold;
            }

            .account_level_consol {
                font-weight: normal;
                font-style: italic;
            }

            ${css}

            .list_table .act_as_row {
                margin-top: 10px;
                margin-bottom: 10px;
                font-size:10px;
            }
        </style>
    </head>
    <body class = "data">
        %for payslip in objects :
        <div style="font-size: 20px; font-weight: bold; text-align: center;"> ${company.partner_id.name | entity} - ${company.currency_id.name | entity}</div>
        <div style="font-size: 25px; font-weight: bold; text-align: center;"> Comprobante pago de salario</div>
        <%setLang(user.context_lang)%>        
        <div style="font-size: 20px; font-weight: bold; text-align: center;"> ${payslip.name or payslip.employee_id.name}</div>
        <br></br>        
        <div class="act_as_table list_table">
            <div class="act_as_thead">
                <div class="act_as_row labels" style="font-weight: bold; font-size: 11x;">
                    <div class="act_as_cell first_column" style="vertical-align: middle">${_('Name')}</div>
                    <div class="act_as_cell">${_('ID card')}</div>
                    <div class="act_as_cell">${_('Bank account')}</div>
                    <div class="act_as_cell">${_('Job')}</div>
                    <div class="act_as_cell">${_('Reference')}</div>
                    <div class="act_as_cell">${_('Date from')}</div>
                    <div class="act_as_cell">${_('Date to')}</div>
                    <div class="act_as_cell">${_('Salary structure')}</div>
                </div>
            </div>
            <div class="act_as_tbody">
                <div class="act_as_row lines">
                    <div class="act_as_cell">${payslip.employee_id.name or '-'}</div>
                    <div class="act_as_cell">${payslip.employee_id.ssnid or '-'}</div> 
                    <div class="act_as_cell">${payslip.employee_id.bank_account_id.name or '-'}</div>                   
                    <div class="act_as_cell">${payslip.contract_id.job_id.name or '-'}</div>
                    <div class="act_as_cell">${payslip.number or '-'}</div>
                    <div class="act_as_cell">${payslip.date_from or '-'}</div>
                    <div class="act_as_cell">${payslip.date_to or '-'}</div>
                    <div class="act_as_cell">${payslip.struct_id.name or '-'}</div>
                </div>
            </div>   
        </div>        
        <br></br><br></br>
        ##Worked days
        <% worked_lines_ids = get_worked_lines(cr,uid,payslip.id,payslip.contract_id.schedule_pay) %>
        <div style="font-size: 16px; font-weight: bold; text-align: left;"> ${_('Worked Days')} </div>
        <div class="act_as_table list_table">
            <div class="act_as_thead">
                <div class="act_as_row labels" style="font-weight: bold; font-size: 11x;">
                    <div class="act_as_cell first_column" style="vertical-align: middle">${_('Name')}</div>
                    <div class="act_as_cell amount">${_('Code')}</div>
                    <div class="act_as_cell amount">${_('Number of days')}</div>
                    <div class="act_as_cell amount">${_('Number of hours')}</div>
                    <div class="act_as_cell amount">${_('Contract')}</div>
                </div>
            </div>
            <div class="act_as_tbody">  
                <% flag = not_HE(cr,uid,worked_lines_ids) %>
                %for line in worked_lines_ids:
                <div class="act_as_row lines">
                    <div class="act_as_cell">${line.name or '-'}</div>
                    <div class="act_as_cell amount">${line.code or '-'}</div>                    
                    <div class="act_as_cell amount">${formatLang(line.number_of_days) or '-'}</div>
                    <div class="act_as_cell amount">${formatLang(line.number_of_hours) or '-'}</div>
                    <div class="act_as_cell amount">${payslip.contract_id.name}</div>
                </div>
                %endfor
                %if flag is False:
                    <div class="act_as_row lines">
                        <div class="act_as_cell">${_('Dont exist extra hours registred')}</div>
                        <div class="act_as_cell amount">${'HE'}</div>                    
                        <div class="act_as_cell amount">${formatLang(0) or '-'}</div>
                        <div class="act_as_cell amount">${formatLang(0) or '-'}</div>
                        <div class="act_as_cell amount">${payslip.contract_id.name}</div>
                    </div>
                %endif
            </div> 
            <br></br><br></br>
            ##Salary Computation
            <div style="font-size: 16px; font-weight: bold; text-align: left;">${_('Salary Computation')} </div>
            <div class="act_as_table list_table">
                <div class="act_as_thead">
                    <div class="act_as_row labels" style="font-weight: bold; font-size: 11x;">
                        <div class="act_as_cell first_column" style="vertical-align: middle">${_('Name')}</div>
                        <div class="act_as_cell">${_('Code')}</div>
                        <div class="act_as_cell">${_('Category')}</div>
                        <div class="act_as_cell amount">${_('Quantity')}</div>
                        <div class="act_as_cell amount">${_('Rate')}</div>
                        <div class="act_as_cell amount">${_('Amount')}</div>
                        <div class="act_as_cell amount">${_('Total')}</div>
                    </div>
                </div>
                <div class="act_as_tbody">
                    <% payslip_lines = get_payslip_lines(cr,uid,payslip.id) %>
                    %for line in payslip_lines:
                    <div class="act_as_row lines">
                        <div class="act_as_cell first_column">${line.name or '-'}</div>
                        <div class="act_as_cell">${line.code or '-'}</div>                    
                        <div class="act_as_cell">${line.category_id.name or '-'}</div>
                        <div class="act_as_cell amount">${line.quantity or '-'}</div>                        
                        <div class="act_as_cell amount">${company.currency_id.symbol}${formatLang(line.rate) or '-'}</div>
                        <div class="act_as_cell amount">${company.currency_id.symbol}${formatLang(line.amount) or '-'}</div>
                        <div class="act_as_cell amount">${company.currency_id.symbol}${formatLang(line.total) or '-'}</div>
                    </div>
                    %endfor
                </div>  
            </div>    
        <br></br>
        <div class="act_as_table data_table" style="margin-top:30px">
        <div class="act_as_tbody">
        <div class="act_as_row" style="vertical-align: bottom">
            <div class="act_as_cell" style="padding-top:80px;padding-bottom:5px"> ${_('Received and accepted: ')}${payslip.employee_id.name} ${_('ID card: ')} ${payslip.employee_id.ssnid}  </div>
        </div>
         %endfor
    </div>   
    <p style="page-break-after:always"></p>        
    </body>
</html>
