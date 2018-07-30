codeunit 50100 "IRPF Management"
{
    [EventSubscriber(ObjectType::Table, 38, 'OnAfterInsertEvent', '', false, false)]
    local procedure ValidateIRPF_OnAfterValidateEvent(var Rec: Record "Purchase Header")
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(Rec."Buy-from Vendor No.") then begin
            Rec.IRPF := Vendor."% IRPf";
            Rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Page, 51, 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure COnfirm_OnBeforeActionEvent(var Rec: Record "Purchase Header")
    var
        Pregunta: Label '¿Desea realizar un calculo del IRPF para esta factura?';
        CalculoIRPF: Codeunit 50101;
        SalesLine: Record 39;
        IRPF: Boolean;
    begin
        Clear(IRPF);
        Clear(SalesLine);
        if (rec.IRPF <> 0) then begin
            SalesLine.SetRange("Document No.", Rec."No.");
            if SalesLine.FindSet() then
                repeat
                    if SalesLine.Quantity < 0 then
                        IRPF := true;
                until SalesLine.Next() = 0;
            if not IRPF then
                if Confirm(Pregunta, false) then
                    CalculoIRPF.CalculoImporte(Rec."No.");

        end;
    end;

    [EventSubscriber(ObjectType::Table, 36  , 'OnAfterInsertEvent', '', false, false)]
    local procedure ValidateIRPF_OnAfterInsertEventSalesHeader(var Rec: Record "sales Header")
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(Rec."Sell-to Customer No.") then begin
            Rec.IRPF := Vendor."% IRPf";
            Rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Page, 43, 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure COnfirm_OnBeforeActionEventSalesInvoice(var Rec: Record "Sales Header")
    var
        Pregunta: Label '¿Desea realizar un calculo del IRPF para esta factura?';
        CalculoIRPF: Codeunit 50101;
        SalesLine: Record 37;
        IRPF: Boolean;
    begin
        Clear(IRPF);
        Clear(SalesLine);
        if (rec.IRPF <> 0) then begin
            SalesLine.SetRange("Document No.", Rec."No.");
            if SalesLine.FindSet() then
                repeat
                    if SalesLine.Quantity < 0 then
                        IRPF := true;
                until SalesLine.Next() = 0;
            if not IRPF then
                if Confirm(Pregunta, false) then
                    CalculoIRPF.CalculoImporteVenta(Rec."No.");

        end;
    end;
}