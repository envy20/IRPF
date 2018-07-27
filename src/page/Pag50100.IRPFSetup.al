page 50100 "IRPF Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "IRPF Setup";
    
    layout
    {
        area(Content)
        {
            group(Ventas)
            {
                field("Cuenta IRPF Venta";"Cuenta IRPF Venta")
                {
                    ApplicationArea = All;
                }
                field("Cuenta Asociada 1";"Cuenta Asociada 1")
                {
                    ApplicationArea = All;
                }
                field("Cuenta Asociada 2";"Cuenta Asociada 2")
                {
                    ApplicationArea = All;
                }
                field("Cuenta Asociada 3";"Cuenta Asociada 3")
                {
                    ApplicationArea = All;
                }
                
            }
            group(Compras)
            {
                field("Cuenta IRPF Compra";"Cuenta IRPF Compra")
                {
                    ApplicationArea = All;
                }
                field("Cuenta Asociada 4";"Cuenta Asociada 4")
                {
                    ApplicationArea = All;
                }
                field("Cuenta Asociada 5";"Cuenta Asociada 5")
                {
                    ApplicationArea = All;
                }
                field("Cuenta Asociada 6";"Cuenta Asociada 6")
                {
                    ApplicationArea = All;
                }
                
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                
                trigger OnAction()
                begin
                    
                    
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}