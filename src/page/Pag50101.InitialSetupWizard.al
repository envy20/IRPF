page 50101 "BCA Initial Setup Wizard"
{
    PageType = NavigatePage;
    Caption = 'Asistente de Instalación';
    SourceTable = "IRPF Setup";
    layout
    {
        area(Content)
        {
            group(WelcomeStep)
            {
                Visible = StepWelcomeVisible;
                group(WelcomeStep1)
                {
                    Caption = 'Bienvenido al asistente de Instalacion del modulo IRPF';
                    InstructionalText = 'Esta configuracíon te guiará para completar satisfactoriamente el proceso de  instalación';
                }
                group(WelcomStep2)
                {
                    Caption = '', locked = true;
                    InstructionalText = 'Elige Siguiente para empezar';
                }
            }
            group(pasoVentas)
            {
                Visible = StepVentasVisible;
                InstructionalText = 'Por favor rellena la cuentas destinadas a ventas';
                field("Cuenta IRPF Venta"; "Cuenta IRPF Venta")
                {
                    ApplicationArea = All;
                    Caption = 'Cuenta de IRPF para Venta';
                    ToolTip = 'Normalmente asociada a la cuenta 473. Es Obligatorio el uso de cuentas Auxiliares tipo 4730001';
                }
                field("Cuenta Asociada 1"; "Cuenta Asociada 1")
                {
                    ApplicationArea = All;
                    Caption = 'Cuenta Productos Venta 1';
                    ToolTip = 'Cuenta asociada a la venta de productos con IRPF (Ejemplo 721)';
                }
                field("Cuenta Asociada 2"; "Cuenta Asociada 2")
                {
                    ApplicationArea = All;
                    Caption = 'Cuenta Productos Venta 2';
                    ToolTip = 'Cuenta asociada a la venta de productos con IRPF (Ejemplo 721)';
                }
                field("Cuenta Asociada 3"; "Cuenta Asociada 3")
                {
                    ApplicationArea = All;
                    Caption = 'Cuenta Productos Venta 3';
                    ToolTip = 'Cuenta asociada a la venta de productos con IRPF (Ejemplo 721)';
                }
            }
            group(PasoCompras)
            {
                Visible = StepComprasVisible;
                InstructionalText = 'Por favor rellena la cuentas destinadas a Compras';
                field("Cuenta IRPF Compra"; "Cuenta IRPF Compra")
                {
                    ApplicationArea = All;
                    Caption = 'Cuenta de IRPF para Compra';
                    ToolTip = 'Normalmente asociada a la cuenta 4751. Es Obligatorio el uso de cuentas Auxiliares tipo 4751001';
                }
                field("Cuenta Asociada 4"; "Cuenta Asociada 4")
                {
                    ApplicationArea = All;
                    Caption = 'Cuenta Productos Compra 1';
                    ToolTip = 'Cuenta asociada a la compra de productos con IRPF (Ejemplo 623)';
                }
                field("Cuenta Asociada 5"; "Cuenta Asociada 5")
                {
                    ApplicationArea = All;
                    Caption = 'Cuenta Productos Compra 2';
                    ToolTip = 'Cuenta asociada a la compra de productos con IRPF (Ejemplo 623)';
                }
                field("Cuenta Asociada 6"; "Cuenta Asociada 6")
                {
                    ApplicationArea = All;
                    Caption = 'Cuenta Productos Compra 3';
                    ToolTip = 'Cuenta asociada a la compra de productos con IRPF (Ejemplo 623)';
                }
            }
            group(StepFinish)
            {
                Visible = StepFinishVisible;
                InstructionalText = 'Finalizar Instalación';
                group(StepFinish1)
                {
                    Caption = '';
                    InstructionalText = 'Para terminar la instalación, presion Finalizar';
                }

                group(StepFinish2)
                {
                    Caption = '';
                    InstructionalText = 'Aviso: se recmonienda rellenar los modulos (Compras/ ventas) que se tenga pensado utilizar';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Back)
            {
                Enabled = BackActionEnabled;
                Caption = 'Volver';
                Image = PreviousRecord;
                InFooterBar = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }
            action(Next)
            {
                Enabled = NextActionEnabled;
                Caption = 'Siguiente';
                Image = NextRecord;
                InFooterBar = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }
            action(Finish)
            {
                Enabled = FinishActionEnabled;
                Caption = 'Finalizar';
                Image = Approve;
                InFooterBar = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    FinishAction();
                end;
            }
        }
    }
    trigger OnInit()
    var
        IRPFSetup: Record "IRPF Setup";
    begin
        if not IRPFSetup.Get() then begin

            IRPFSetup.Init();
            IRPFSetup.Insert();
        end;

    end;
    local procedure EnableControls();
    begin
        if ("Cuenta IRPF Venta" <> '') or ("Cuenta IRPF Compra" <> '') then
            FinishActionEnabled := true
        else
            FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;
        StepWelcomeVisible := false;
        StepVentasVisible := false;
        StepComprasVisible := false;
        StepFinishVisible := false;
        case Step of
            Step::StepWelcome:
                begin
                    StepWelcomeVisible := true;
                    BackActionEnabled := false;
                    FinishActionEnabled := false;
                end;
            Step::StepVentas:
                StepVentasVisible := true;
            Step::StepCompras:
                StepComprasVisible := true;
            Step::StepFinish:
                begin
                    StepFinishVisible := true;
                    NextActionEnabled := false;
                end;
        end;
    end;

    local procedure NextStep(Backwards: Boolean);
    begin
        if Backwards then
            Step := Step - 1
        else
            Step := Step + 1;
        EnableControls();
    end;

    local procedure InsertRecord();
    var
        IRPFSetup: Record "IRPF Setup";
    begin
        if not IRPFSetup.Get() then
            IRPFSetup.Insert();
        if "Cuenta IRPF Venta" <> '' then
            IRPFSetup.Validate("Cuenta IRPF Venta", "Cuenta IRPF Venta");
        IRPFSetup.Validate("Cuenta Asociada 1", "Cuenta Asociada 1");
        IRPFSetup.Validate("Cuenta Asociada 2", "Cuenta Asociada 2");
        IRPFSetup.Validate("Cuenta Asociada 3", "Cuenta Asociada 3");
        if "Cuenta IRPF Compra" <> '' then
            IRPFSetup.Validate("Cuenta IRPF Compra", "Cuenta IRPF Compra");
        IRPFSetup.Validate("Cuenta Asociada 4", "Cuenta Asociada 4");
        IRPFSetup.Validate("Cuenta Asociada 5", "Cuenta Asociada 5");
        IRPFSetup.Validate("Cuenta Asociada 6", "Cuenta Asociada 6");
        IRPFSetup.Modify(true);
    end;

    local procedure FinishAction();
    begin
        InsertRecord();
        CurrPage.Close();
    end;

    trigger OnOpenPage();
    begin
        EnableControls();
    end;

    var
        Step: Option StepWelcome,StepVentas,StepCompras,StepFinish;
        NextActionEnabled: Boolean;
        BackActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        StepWelcomeVisible: Boolean;
        StepVentasVisible: Boolean;
        StepComprasVisible: Boolean;
        StepFinishVisible: Boolean;

}