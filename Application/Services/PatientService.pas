unit PatientService;

interface

uses
  Patient, IPatientServ, IPatientRepo, System.Generics.Collections;

type
  TPatientService = class(TInterfacedObject, IPatientService)
  private
    FPatientRepository: IPatientRepository;
  public
    constructor Create(APatientRepository: IPatientRepository);

    function GetAllPatients: TArray<TPatient>;
    function GetPatientById(Id: Integer): TPatient;
    procedure SavePatient(Patient: TPatient);
    procedure DeletePatient(Id: Integer);
    function GetNewPatientId: Integer;
  end;

implementation

{ TPatientService }

constructor TPatientService.Create(APatientRepository: IPatientRepository);
begin
  inherited Create;
  FPatientRepository := APatientRepository;
end;

function TPatientService.GetAllPatients: TArray<TPatient>;
begin
  Result := FPatientRepository.GetAllPatients;
end;

function TPatientService.GetPatientById(Id: Integer): TPatient;
begin
  Result := FPatientRepository.GetPatientById(Id);
end;

procedure TPatientService.SavePatient(Patient: TPatient);
begin
  FPatientRepository.SavePatient(Patient);
end;

procedure TPatientService.DeletePatient(Id: Integer);
begin
  FPatientRepository.DeletePatient(Id);
end;

function TPatientService.GetNewPatientId: Integer;
var
  Patients: TArray<TPatient>;
  HighestId: Integer;
  I: Integer;
begin
  Patients := GetAllPatients;

  if Length(Patients) = 0 then
    Exit(1);

  HighestId := Patients[0].Id;
  for I := 1 to High(Patients) do
  begin
    if Patients[I].Id > HighestId then
      HighestId := Patients[I].Id;
  end;

  Result := HighestId + 1;
end;

end.
