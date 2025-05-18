unit JsonPatientRepository;

interface

uses
  System.JSON, System.IOUtils, System.SysUtils,
  IPatientRepo, Patient;

type
  TJsonPatientRepository = class(TInterfacedObject, IPatientRepository)
  private
    FFilePath: string;
    function PatientToJson(Patient: TPatient): TJSONObject;
    function JsonToPatient(Json: TJSONObject): TPatient;
  public
    constructor Create(const FilePath: string);
    function GetAll: TArray<TPatient>;
    function GetById(Id: Integer): TPatient;
    procedure AddOrUpdate(Patient: TPatient);
    procedure Delete(Id: Integer);
  end;

implementation

constructor TJsonPatientRepository.Create(const FilePath: string);
begin
  FFilePath := FilePath;
  if not FileExists(FFilePath) then
    TFile.WriteAllText(FFilePath, '[]');
end;

function TJsonPatientRepository.PatientToJson(Patient: TPatient): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('id', TJSONNumber.Create(Patient.Id));
  Result.AddPair('name', Patient.Name);
  Result.AddPair('birthDate', FormatDateTime('yyyy-mm-dd', Patient.BirthDate));
  Result.AddPair('gender', TJSONNumber.Create(Ord(Patient.Gender)));
  Result.AddPair('phone', Patient.Phone);
  Result.AddPair('workplace', Patient.Workplace);
end;

function TJsonPatientRepository.JsonToPatient(Json: TJSONObject): TPatient;
begin
  Result := TPatient.Create;
  Result.Id := Json.GetValue<Integer>('id');
  Result.Name := Json.GetValue<string>('name');
  Result.BirthDate := StrToDate(Json.GetValue<string>('birthDate'));
  Result.Gender := TGender(Json.GetValue<Integer>('gender'));
  Result.Phone := Json.GetValue<string>('phone');
  Result.Workplace := Json.GetValue<string>('workplace');
end;

function TJsonPatientRepository.GetAll: TArray<TPatient>;
var
  JsonArray: TJSONArray;
  i: Integer;
begin
  JsonArray := TJSONObject.ParseJSONValue(TFile.ReadAllText(FFilePath)) as TJSONArray;
  try
    SetLength(Result, JsonArray.Count);
    for i := 0 to JsonArray.Count - 1 do
      Result[i] := JsonToPatient(JsonArray.Items[i] as TJSONObject);
  finally
    JsonArray.Free;
  end;
end;

function TJsonPatientRepository.GetById(Id: Integer): TPatient;
var
  Patients: TArray<TPatient>;
  Patient: TPatient;
begin
  Patients := GetAll;
  for Patient in Patients do
    if Patient.Id = Id then
      Exit(Patient);
  Result := nil;
end;

procedure TJsonPatientRepository.AddOrUpdate(Patient: TPatient);
var
  Patients, NewPatients: TArray<TPatient>;
  i: Integer;
  Found: Boolean;
  JsonArray: TJSONArray;
begin
  Patients := GetAll;
  Found := False;
  for i := Low(Patients) to High(Patients) do
    if Patients[i].Id = Patient.Id then
    begin
      Patients[i] := Patient;
      Found := True;
      Break;
    end;

  if not Found then
  begin
    SetLength(Patients, Length(Patients) + 1);
    Patients[High(Patients)] := Patient;
  end;

  JsonArray := TJSONArray.Create;
  try
    for i := Low(Patients) to High(Patients) do
      JsonArray.AddElement(PatientToJson(Patients[i]));
    TFile.WriteAllText(FFilePath, JsonArray.ToJSON);
  finally
    JsonArray.Free;
  end;
end;

procedure TJsonPatientRepository.Delete(Id: Integer);
var
  Patients, NewPatients: TArray<TPatient>;
  i, j: Integer;
begin
  Patients := GetAll;
  j := 0;
  SetLength(NewPatients, Length(Patients));
  for i := Low(Patients) to High(Patients) do
    if Patients[i].Id <> Id then
    begin
      NewPatients[j] := Patients[i];
      Inc(j);
    end;
  SetLength(NewPatients, j);
  AddOrUpdate(nil); // Очищаем файл
  for i := Low(NewPatients) to High(NewPatients) do
    AddOrUpdate(NewPatients[i]);
end;

end.
