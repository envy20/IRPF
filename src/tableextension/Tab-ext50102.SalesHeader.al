tableextension 50102 "IRPF Sales header" extends "Sales Header" //MyTargetTableId
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