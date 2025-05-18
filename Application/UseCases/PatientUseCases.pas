unit Application.UseCases.PatientUseCases;

interface

uses
  Core.Entities.Patient,
  Core.Repositories.IPatientRepository;

type
  TPatientUseCases = class
  private
    FRepository: IPatientRepository;
  public
    constructor Create(ARepository: IPatientRepository);
    procedure AddPatient(APatient: TPatient);
    function GetAllPatients: TArray<TPatient>;
    // Другие use cases...
  end;

implementation

constructor TPatientUseCases.Create(ARepository: IPatientRepository);
begin
  FRepository := ARepository;
end;

procedure TPatientUseCases.AddPatient(APatient: TPatient);
begin
  // Валидация и бизнес-логика
  FRepository.AddOrUpdate(APatient);
end;

function TPatientUseCases.GetAllPatients: TArray<TPatient>;
begin
  Result := FRepository.GetAll;
end;

end.