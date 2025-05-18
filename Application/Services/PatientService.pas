unit PatientService;

interface

uses
  IPatientServ,
  IPatientRepo,
  Patient;

type
  TPatientService = class(TInterfacedObject, IPatientService)
  private
    FRepository: IPatientRepository;
  public
    constructor Create(ARepository: IPatientRepository);
    function GetAllPatients: TArray<TPatient>;
    function GetPatientById(Id: Integer): TPatient;
    procedure SavePatient(Patient: TPatient);
    procedure DeletePatient(Id: Integer);
  end;

implementation

constructor TPatientService.Create(ARepository: IPatientRepository);
begin
  FRepository := ARepository;
end;

function TPatientService.GetAllPatients: TArray<TPatient>;
begin
  Result := FRepository.GetAll;
end;

function TPatientService.GetPatientById(Id: Integer): TPatient;
begin
  Result := FRepository.GetById(Id);
end;

procedure TPatientService.SavePatient(Patient: TPatient);
begin
  FRepository.AddOrUpdate(Patient);
end;

procedure TPatientService.DeletePatient(Id: Integer);
begin
  FRepository.Delete(Id);
end;

end.
