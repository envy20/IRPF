pageextension 50103 "IRPF Customer Card" extends "Customer Card" //MyTargetPageId
{
    layout
    {
        addafter("Customer Posting Group")
        {
            field("% IRPf"; "% IRPf")
            {
                ApplicationArea = All;
            }

        }
    }
}