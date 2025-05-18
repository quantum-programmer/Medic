unit DependencyInjection;

interface

uses
  Patient, IPatientRepo, IPatientServ, JsonPatientRepository, PatientService;

var
  PatientService: IPatientService;

procedure RegisterServices;

implementation

procedure RegisterServices;
var
  PatientRepository: IPatientRepository;
begin
  PatientRepository := TJsonPatientRepository.Create;
  PatientService := TPatientService.Create(PatientRepository);
end;

end.
