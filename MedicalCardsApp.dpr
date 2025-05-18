program MedicalCardsApp;

uses
  Vcl.Forms,
  Patient in 'Core\Entities\Patient.pas',
  IPatientRepo in 'Core\Repositories\IPatientRepo.pas',
  IPatientServ in 'Core\Services\IPatientServ.pas',
  JsonPatientRepository in 'Infrastructure\Repositories\JsonPatientRepository.pas',
  PatientService in 'Application\Services\PatientService.pas',
  MainFormUnit in 'UI\Forms\MainFormUnit.pas' {MainForm},
  PatientCardFrame in 'UI\Frames\PatientCardFrame.pas' {PatientCardFrame},
  DependencyInjection in 'DependencyInjection.pas';

{$R *.res}

begin
  Application.Initialize;
  DependencyInjection.RegisterServices;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
