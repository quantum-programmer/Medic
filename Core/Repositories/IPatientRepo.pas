unit IPatientRepo;

interface

uses
  Patient;

type
  IPatientRepository = interface
    ['{3B8B0E3F-5A1F-4D7A-9C3D-2F7E1A4B6C9D}']
    function GetAll: TArray<TPatient>;
    function GetById(Id: Integer): TPatient;
    procedure AddOrUpdate(Patient: TPatient);
    procedure Delete(Id: Integer);
  end;

implementation

end.
