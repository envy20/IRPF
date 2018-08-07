tableextension 50104 "MovsContabilidad" extends 17    
{
    fields
    {
        field(50000; "Nombre Proveedor"; Text[150])
        {
           Caption = 'Nombre proveedor';
           FieldClass = FlowField;
           CalcFormula = lookup("Purch. Inv. Header"."Pay-to Name" WHERE ("No."=field("Document No.")));
             
        }
    }
}