program Restarter;

uses
  Forms,
  Restart in 'Restart.pas' {Form1},
  Spec in 'Spec.pas' {Spec1},
  engine in 'engine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSpec1, Spec1);
  Application.Run;
end.
