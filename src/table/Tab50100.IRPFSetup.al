table 50100 "IRPF Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Cuenta Asociada 1"; Code[20])
        {
            Caption = 'Cuenta Asociada 1';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(3; "Cuenta Asociada 2"; Code[20])
        {
            Caption = 'Cuenta Asociada 2';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(4; "Cuenta Asociada 3"; Code[20])
        {
            Caption = 'Cuenta Asociada 3';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(5; "Cuenta Asociada 4"; Code[20])
        {
            Caption = 'Cuenta Asociada 4';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(6; "Cuenta Asociada 5"; Code[20])
        {
            Caption = 'Cuenta Asociada 5';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(7; "Cuenta Asociada 6"; Code[20])
        {
            Caption = 'Cuenta Asociada 6';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(8; "Cuenta IRPF Venta"; Code[20])
        {
            Caption = 'Cuenta IRPF Venta';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            trigger OnValidate()
            var
                GLAcount: Record "G/L Account";
            begin
                if "Cuenta IRPF Venta"<>'' then begin
                    if GLAcount.Get("Cuenta IRPF Venta") then 
                    GLAcount.TestField("Account Type",GLAcount."Account Type"::Posting);
                end;
                
            end;
        }
        field(9; "Cuenta IRPF Compra"; Code[20])
        {
            Caption = 'Cuenta IRPF Compra';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            trigger OnValidate()
            var
                GLAcount: Record "G/L Account";
            begin
                if "Cuenta IRPF Compra"<>'' then begin
                    if GLAcount.Get("Cuenta IRPF Compra") then 
                    GLAcount.TestField("Account Type",GLAcount."Account Type"::Posting);
                end;
                
            end;
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}