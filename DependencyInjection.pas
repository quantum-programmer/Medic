unit DependencyInjection;

interface

uses
  IPatientServ,
  PatientService,
  IPatientRepo,
  JsonPatientRepository,
  FileLogger;

var
  PatientService: IPatientService;
  Logger: ILogger;

procedure InitializeDependencies;

implementation

procedure InitializeDependencies;
begin
  Logger := TFileLogger.Create('app.log');
  PatientService := TPatientService.Create(
    TJsonPatientRepository.Create('patients.json')
  );
end;

initialization
  InitializeDependencies;

end.
