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
        PurchaseLine: Record 39;
        IRPF: Boolean;
    begin
        Clear(IRPF);
        Clear(PurchaseLine);
        if (rec.IRPF <> 0) then begin
            PurchaseLine.SetRange("Document No.", Rec."No.");
            if PurchaseLine.FindSet() then
                repeat
                    if PurchaseLine.Quantity < 0 then
                        IRPF := true;
                until PurchaseLine.Next() = 0;
            if not IRPF then
                if Confirm(Pregunta, false) then
                    CalculoIRPF.CalculoImporte(Rec."No.");

        end;
    end;
}