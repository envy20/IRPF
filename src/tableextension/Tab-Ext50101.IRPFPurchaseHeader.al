tableextension 50101 "IRPF PurchaseHeader" extends "Purchase Header" //MyTargetTableId
{
    fields
    {
        field(50000; "IRPF"; Integer)
        {
            Caption = '% IRPF';
            DataClassification = ToBeClassified;
        }
        
    }
    
}