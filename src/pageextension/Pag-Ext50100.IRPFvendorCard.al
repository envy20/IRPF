pageextension 50100 "IRPF vendor Card" extends "Vendor Card" //MyTargetPageId
{
    layout
    {
        addafter("Vendor Posting Group")
        {
            field("% IRPf"; "% IRPf")
            {
                ApplicationArea = All;
            }

        }
    }
}