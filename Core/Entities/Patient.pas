unit Patient;

interface

type
  TGender = (Male, Female, Other);

  TPatient = class
  private
    FId: Integer;
    FName: string;
    FBirthDate: TDate;
    FGender: TGender;
    FPhone: string;
    FWorkplace: string;
  public
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property BirthDate: TDate read FBirthDate write FBirthDate;
    property Gender: TGender read FGender write FGender;
    property Phone: string read FPhone write FPhone;
    property Workplace: string read FWorkplace write FWorkplace;
  end;

implementation

end.
