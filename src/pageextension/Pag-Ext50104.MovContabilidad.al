pageextension 50104 "MovContabilidad" extends 20
{
    layout
    {
        addbefore("Entry No.")
        {
            field("Nombre Proveedor";"Nombre Proveedor")
            {
                ApplicationArea = All;  
            }
        }
    }
    
}