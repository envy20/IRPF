codeunit 50101 "Calculo IRPF"
{
    var
        PurchaseLine: Record "Purchase Line";
        GLAccount: Record "G/L Account";
        Item: Record Item;
        IRPFSetup: Record "IRPF Setup";
        Cantidad: Decimal;
        SalesLine: Record "Sales Line";
        GenPostinSetup: Record 252;
        GenProdPOstingGroup: Record 251;
        PurchaseHeader: Record 38;
        SalesHeader: Record 36;

    procedure CalculoImporte(DocmunetNo: Code[20])
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
    begin
        Clear(PurchaseLine);
        Clear(IRPFSetup);
        Clear(PurchaseHeader);
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
        Resultado: Boolean;
    begin
        Clear(PurchaseHeader);
        Clear(GenProdPOstingGroup);
        Clear(GenPostinSetup);
        if Item.get(No) then begin
            if GenProdPOstingGroup.get(Item."Gen. Prod. Posting Group") then begin
                PurchaseHeader.get(PurchaseHeader."Document Type"::Invoice, DocumentNo);
                if GenPostinSetup.GEt(PurchaseHeader."Gen. Bus. Posting Group", GenProdPOstingGroup.Code) then
                    if (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 4")) <> 0) or
                    (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 5")) <> 0) or
                    (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 6")) <> 0) then
                        Resultado := true;
            end;
            exit(Resultado)
        end;
    end;


    local procedure calculoIRPFCuenta(No: code[20]; DocumentNo: code[20]): Boolean
    var
        Resultado: Boolean;
    begin
        Clear(PurchaseHeader);
        Clear(GenProdPOstingGroup);
        Clear(GenPostinSetup);
        if GLAccount.get(No) then begin
            if GenProdPOstingGroup.Get(GLAccount."Gen. Prod. Posting Group") then begin
                PurchaseHeader.get(PurchaseHeader."Document Type"::Invoice, DocumentNo);
                if GenPostinSetup.GEt(PurchaseHeader."Gen. Bus. Posting Group", GenProdPOstingGroup.Code) then
                    if (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 4")) <> 0) or
                       (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 5")) <> 0) or
                       (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 6")) <> 0) then
                        Resultado := true;
            end;
            exit(Resultado)
        end;
    end;

    procedure CalculoImporteVenta(DocmunetNo: Code[20])
    begin
        IRPFSetup.Get();
        Clear(SalesLine);
        Clear(Cantidad);
        SalesLine.SetRange("Document No.", DocmunetNo);
        if SalesLine.FindSet() then
            repeat
                if SalesLine.Type = SalesLine.Type::Item then
                    if calculoIRPFProductoVenta(SalesLine."No.", SalesLine."Document No.") then
                        Cantidad += SalesLine."Line Amount";


                if SalesLine.Type = SalesLine.Type::"G/L Account" then
                    if calculoIRPFCuentaVenta(SalesLine."No.", SalesLine."Document No.") then
                        Cantidad += SalesLine."Line Amount";

            Until SalesLine.Next() = 0;
        CrearLineaVenta(DocmunetNo, Cantidad);
    end;

    local procedure CrearLineaVenta(DocumentNo: Code[20]; Importe: Decimal)
    begin
        Clear(SalesLine);
        Clear(SalesHeader);
        Clear(IRPFSetup);
        IRPFSetup.Get();
        if SalesHeader.Get(SalesHeader."Document Type"::Invoice, DocumentNo) then begin
            SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
            SalesLine."Document No." := DocumentNo;
            SalesLine.Type := SalesLine.Type::"G/L Account";
            SalesLine."Line No." := 11000;
            SalesLine.Validate("No.", IRPFSetup."Cuenta IRPF Compra");
            SalesLine.Insert();
            SalesLine.Validate(Quantity, (-(SalesHeader.IRPF / 100)));
            SalesLine.Validate("Unit Price", Importe);
            SalesLine.Modify();
        end;
    end;

    local procedure calculoIRPFProductoVenta(No: code[20]; DocumentNo: code[20]): Boolean
    var
        Resultado: Boolean;
    begin
        Clear(SalesHeader);
        Clear(GLAccount);
        Clear(GenProdPOstingGroup);
        Clear(GenPostinSetup);
        if Item.get(No) then begin
            if GenProdPOstingGroup.get(Item."Gen. Prod. Posting Group") then begin
                Salesheader.get(Salesheader."Document Type"::Invoice, DocumentNo);
                if (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 1")) <> 0) or
                    (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 2")) <> 0) or
                    (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 3")) <> 0) then
                    Resultado := true;
            end;
            exit(Resultado)
        end;
    end;


    local procedure calculoIRPFCuentaVenta(No: code[20]; DocumentNo: code[20]): Boolean
    var
        Resultado: Boolean;
    begin
        Clear(Salesheader);
        Clear(GLAccount);
        Clear(GenProdPOstingGroup);
        Clear(GenPostinSetup);
        if GLAccount.get(No) then begin
            if GenProdPOstingGroup.Get(GLAccount."Gen. Prod. Posting Group") then begin
                Salesheader.get(Salesheader."Document Type"::Invoice, DocumentNo);
                if GenPostinSetup.GEt(Salesheader."Gen. Bus. Posting Group", GenProdPOstingGroup.Code) then
                    if (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 1")) <> 0) or
                        (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 2")) <> 0) or
                        (StrPos(Format(GenPostinSetup."Purch. Account"), Format(IRPFSetup."Cuenta Asociada 3")) <> 0) then
                        Resultado := true;
            end;
            exit(Resultado)
        end;
    end;
}