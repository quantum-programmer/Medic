unit IPatientRepo;

interface

uses
  Patient;

type
  IPatientRepository = interface
    ['{A3B5E7D9-F2E1-4C8B-9D9F-6A1C3B5E7D9F}']
    function GetAllPatients: TArray<TPatient>;
    function GetPatientById(Id: Integer): TPatient;
    procedure SavePatient(Patient: TPatient);
    procedure DeletePatient(Id: Integer);
  end;

implementation

end.
