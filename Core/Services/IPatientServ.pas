unit IPatientServ;

interface

uses
  Patient;

type
  IPatientService = interface
    ['{7D1A3E2F-4C8B-4E9D-9F6A-1C3B5E7D9F2E}']
    function GetAllPatients: TArray<TPatient>;
    function GetPatientById(Id: Integer): TPatient;
    procedure SavePatient(Patient: TPatient);
    procedure DeletePatient(Id: Integer);
    function GetNewPatientId: Integer;
  end;

implementation

end.
