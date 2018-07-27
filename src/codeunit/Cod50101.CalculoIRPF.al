codeunit 50101 "Calculo IRPF"
{
    var
        PurchaseLine: Record "Purchase Line";
        GLAccount: Record "G/L Account";
        Item: Record Item;
        IRPFSetup: Record "IRPF Setup";
        Cantidad: Decimal;

    procedure CalculoImporte(DocmunetNo: Code[20])
    var


    begin
        IRPFSetup.Get();
        Clear(PurchaseLine);
        PurchaseLine.SetRange("Document No.", DocmunetNo);
        if PurchaseLine.FindSet() then
            repeat
                if PurchaseLine.Type = PurchaseLine.Type::Item then
                    if calculoIRPFProducto(PurchaseLine."No.", PurchaseLine."Document No.") then 
                        Cantidad += PurchaseLine."Line Amount";
                    

                if PurchaseLine.Type = PurchaseLine.Type::"G/L Account" then
                    if calculoIRPFCuenta(PurchaseLine."No.", PurchaseLine."Document No.") then 
                        Cantidad += PurchaseLine."Line Amount";
                    
            Until PurchaseLine.Next() = 0;
        CrearLinea(DocmunetNo, Cantidad);
    end;

    local procedure CrearLinea(DocumentNo: Code[20]; Importe: Decimal)
    var
        PurchaseHeader: Record 38;
    begin
        Clear(PurchaseLine);
        Clear(IRPFSetup);
        IRPFSetup.Get();
        if PurchaseHeader.Get(PurchaseHeader."Document Type"::Invoice, DocumentNo) then begin
            PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice;
            PurchaseLine."Document No." := DocumentNo;
            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
            PurchaseLine."Line No." := 11000;
            PurchaseLine.Validate("No.", IRPFSetup."Cuenta IRPF Compra");
            PurchaseLine.Insert();
            PurchaseLine.Validate(Quantity, (-(PurchaseHeader.IRPF / 100)));
            PurchaseLine.Validate("Direct Unit Cost", Importe);
            PurchaseLine.Modify();
        end;
    end;

    local procedure calculoIRPFProducto(No: code[20]; DocumentNo: code[20]): Boolean
    var
        GenPostinSetup: Record 252;
        GenProdPOstingGroup: Record 251;
        Resultado: Boolean;
        PurchaseHeader: Record 38;
    begin
        Clear(PurchaseHeader);
        if Item.get(No) then begin
            if GenProdPOstingGroup.get(Item."Gen. Prod. Posting Group") then begin
                PurchaseHeader.get(PurchaseHeader."Document Type"::Invoice, DocumentNo);
                if GenPostinSetup.GEt(PurchaseHeader."Gen. Bus. Posting Group", GenProdPOstingGroup.Code) then
                    if (GenPostinSetup."Purch. Account" = IRPFSetup."Cuenta Asociada 4") or
                    (GenPostinSetup."Purch. Account" = IRPFSetup."Cuenta Asociada 5") or
                    (GenPostinSetup."Purch. Account" = IRPFSetup."Cuenta Asociada 6") then
                        Resultado := true;
            end;
            exit(Resultado)
        end;
    end;


    local procedure calculoIRPFCuenta(No: code[20]; DocumentNo: code[20]): Boolean
    var
        GenPostinSetup: Record 252;
        GenProdPOstingGroup: Record 251;
        Resultado: Boolean;
        PurchaseHeader: Record 38;
    begin
        Clear(PurchaseHeader);
        if GLAccount.get(No) then begin
            if GenProdPOstingGroup.Get(GLAccount."Gen. Prod. Posting Group") then begin
                PurchaseHeader.get(PurchaseHeader."Document Type"::Invoice, DocumentNo);
                if GenPostinSetup.GEt(PurchaseHeader."Gen. Bus. Posting Group", GenProdPOstingGroup.Code) then
                    if (GenPostinSetup."Purch. Account" = IRPFSetup."Cuenta Asociada 4") or
                       (GenPostinSetup."Purch. Account" = IRPFSetup."Cuenta Asociada 5") or
                       (GenPostinSetup."Purch. Account" = IRPFSetup."Cuenta Asociada 6") then
                        Resultado := true;
        end;
            exit(Resultado)
        end;
    end;
}