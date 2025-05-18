unit PatientCardFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.ComCtrls, Patient;

type
  TPatientCardFrame = class(TFrame)
    pnlButtons: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    gbPatientInfo: TGroupBox;
    lblName: TLabel;
    edtName: TEdit;
    lblBirthDate: TLabel;
    dtpBirthDate: TDateTimePicker;
    lblGender: TLabel;
    cbGender: TComboBox;
    lblPhone: TLabel;
    edtPhone: TEdit;
    lblWorkplace: TLabel;
    edtWorkplace: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FPatient: TPatient;
    FOnSave: TProc;
    FOnCancel: TProc;
  public
    procedure LoadPatient(Patient: TPatient);
    property OnSave: TProc read FOnSave write FOnSave;
    property OnCancel: TProc read FOnCancel write FOnCancel;
  end;

implementation

{$R *.dfm}

procedure TPatientCardFrame.LoadPatient(Patient: TPatient);
begin
  FPatient := Patient;
  edtName.Text := Patient.Name;
  dtpBirthDate.Date := Patient.BirthDate;
  cbGender.ItemIndex := Ord(Patient.Gender);
  edtPhone.Text := Patient.Phone;
  edtWorkplace.Text := Patient.Workplace;
end;

procedure TPatientCardFrame.btnSaveClick(Sender: TObject);
begin
  FPatient.Name := edtName.Text;
  FPatient.BirthDate := dtpBirthDate.Date;
  FPatient.Gender := TGender(cbGender.ItemIndex);
  FPatient.Phone := edtPhone.Text;
  FPatient.Workplace := edtWorkplace.Text;
  if Assigned(FOnSave) then FOnSave;
end;

procedure TPatientCardFrame.btnCancelClick(Sender: TObject);
begin
  if Assigned(FOnCancel) then FOnCancel;
end;

end.