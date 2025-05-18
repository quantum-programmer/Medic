unit JsonPatientRepository;

interface

uses
  System.IOUtils, System.JSON, System.Generics.Collections, System.SysUtils, // Добавлен System.SysUtils
  Patient, IPatientRepo;

type
  TJsonPatientRepository = class(TInterfacedObject, IPatientRepository)
  private
    FFilePath: string;
    function LoadFromFile: TArray<TPatient>;
    procedure SaveToFile(const Patients: TArray<TPatient>);
  public
    constructor Create;

    function GetAllPatients: TArray<TPatient>;
    function GetPatientById(Id: Integer): TPatient;
    procedure SavePatient(Patient: TPatient);
    procedure DeletePatient(Id: Integer);
  end;

implementation

uses
  System.DateUtils; // Добавлен для работы с датами

{ TJsonPatientRepository }

constructor TJsonPatientRepository.Create;
begin
  inherited;
  FFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'patients.json');
end;

function TJsonPatientRepository.GetAllPatients: TArray<TPatient>;
begin
  Result := LoadFromFile;
end;

function TJsonPatientRepository.GetPatientById(Id: Integer): TPatient;
var
  Patients: TArray<TPatient>;
  Patient: TPatient;
begin
  Patients := LoadFromFile;
  for Patient in Patients do
    if Patient.Id = Id then
      Exit(Patient);
  Result := nil;
end;

procedure TJsonPatientRepository.SavePatient(Patient: TPatient);
var
  Patients, NewPatients: TArray<TPatient>;
  I: Integer;
  Found: Boolean;
begin
  Patients := LoadFromFile;
  Found := False;

  for I := 0 to High(Patients) do
    if Patients[I].Id = Patient.Id then
    begin
      Patients[I] := Patient;
      Found := True;
      Break;
    end;

  if not Found then
  begin
    SetLength(NewPatients, Length(Patients) + 1);
    for I := 0 to High(Patients) do
      NewPatients[I] := Patients[I];
    NewPatients[High(NewPatients)] := Patient;
    Patients := NewPatients;
  end;

  SaveToFile(Patients);
end;

procedure TJsonPatientRepository.DeletePatient(Id: Integer);
var
  Patients, NewPatients: TArray<TPatient>;
  I, J: Integer;
begin
  Patients := LoadFromFile;
  SetLength(NewPatients, Length(Patients) - 1);
  J := 0;

  for I := 0 to High(Patients) do
    if Patients[I].Id <> Id then
    begin
      if J <= High(NewPatients) then
        NewPatients[J] := Patients[I];
      Inc(J);
    end;

  SaveToFile(NewPatients);
end;

function TJsonPatientRepository.LoadFromFile: TArray<TPatient>;
var
  JsonArray: TJSONArray;
  JsonObj: TJSONObject;
  Patient: TPatient;
  JsonString: string;
  I: Integer;
  DateStr: string;
begin
  if not TFile.Exists(FFilePath) then
    Exit(nil);

  JsonString := TFile.ReadAllText(FFilePath);
  JsonArray := TJSONObject.ParseJSONValue(JsonString) as TJSONArray;
  try
    SetLength(Result, JsonArray.Count);
    for I := 0 to JsonArray.Count - 1 do
    begin
      JsonObj := JsonArray.Items[I] as TJSONObject;
      Patient := TPatient.Create;
      Patient.Id := JsonObj.GetValue<Integer>('id');
      Patient.Name := JsonObj.GetValue<string>('name');

      // Исправленное чтение даты
      DateStr := JsonObj.GetValue<string>('birthDate');
      Patient.BirthDate := ISO8601ToDate(DateStr, False);

      Patient.Gender := JsonObj.GetValue<string>('gender');
      Patient.Phone := JsonObj.GetValue<string>('phone');
      Patient.Workplace := JsonObj.GetValue<string>('workplace');
      Result[I] := Patient;
    end;
  finally
    JsonArray.Free;
  end;
end;

procedure TJsonPatientRepository.SaveToFile(const Patients: TArray<TPatient>);
var
  JsonArray: TJSONArray;
  JsonObj: TJSONObject;
  I: Integer;
begin
  JsonArray := TJSONArray.Create;
  try
    for I := 0 to High(Patients) do
    begin
      JsonObj := TJSONObject.Create;
      JsonObj.AddPair('id', TJSONNumber.Create(Patients[I].Id));
      JsonObj.AddPair('name', TJSONString.Create(Patients[I].Name));

      // Исправленное сохранение даты
      JsonObj.AddPair('birthDate',
        TJSONString.Create(DateToISO8601(Patients[I].BirthDate, False)));

      JsonObj.AddPair('gender', TJSONString.Create(Patients[I].Gender));
      JsonObj.AddPair('phone', TJSONString.Create(Patients[I].Phone));
      JsonObj.AddPair('workplace', TJSONString.Create(Patients[I].Workplace));
      JsonArray.AddElement(JsonObj);
    end;

    TFile.WriteAllText(FFilePath, JsonArray.ToJSON);
  finally
    JsonArray.Free;
  end;
end;

end.
