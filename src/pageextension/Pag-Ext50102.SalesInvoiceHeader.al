pageextension 50102 "IRPF Sales Invoice"extends "Sales Invoice" //MyTargetPageId
{
    layout
    {
        addafter("VAT Bus. Posting Group")
        {
            field(IRPF; IRPF)
            {
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        addlast(Processing)
        {
            action("Calcular IRPF")
            {
                ApplicationArea = All;
                Image = CalculateLines;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CalculoIRPF: Codeunit "Calculo IRPF";
                begin
                    //CalculoIRPF.CalculoImporte("No.");
                    CurrPage.Update();
                end;
            }
        }
        
    }
}