program Main;

uses
  Vcl.Forms,
  Patient in 'Core\Entities\Patient.pas',
  IPatientRepo in 'Core\Repositories\IPatientRepo.pas',
  IPatientServ in 'Core\Services\IPatientServ.pas',
  JsonPatientRepository in 'Infrastructure\Repositories\JsonPatientRepository.pas',
  FileLogger in 'Infrastructure\Logging\FileLogger.pas',
  PatientService in 'Application\Services\PatientService.pas',
  MainForm in 'UI\Forms\MainForm.pas' {MainForm},
  MainForm.dfm in 'UI\Forms\MainForm.dfm',
  PatientCardFrame in 'UI\Frames\PatientCardFrame.pas' {PatientCardFrame},
  PatientCardFrame.dfm in 'UI\Frames\PatientCardFrame.dfm',
  DependencyInjection in 'DependencyInjection.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainF);
  Application.Run;
end.
