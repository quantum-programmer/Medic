unit PatientCardFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Patient, Vcl.ComCtrls;

type
  TPatientCardFrame = class(TFrame)
    pnlButtons: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    gbPatientInfo: TGroupBox;
    lblName: TLabel;
    lblBirthDate: TLabel;
    lblGender: TLabel;
    lblPhone: TLabel;
    lblWorkplace: TLabel;
    edtName: TEdit;
    dtpBirthDate: TDateTimePicker;
    cbGender: TComboBox;
    edtPhone: TEdit;
    edtWorkplace: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FPatient: TPatient;
    FOnSave: TProc;
    FOnCancel: TProc;
  public
    procedure LoadPatient(Patient: TPatient);
    function ValidateData: Boolean;
    property OnSave: TProc read FOnSave write FOnSave;
    property OnCancel: TProc read FOnCancel write FOnCancel;
  end;

implementation

{$R *.dfm}

{ TPatientCardFrame }

procedure TPatientCardFrame.LoadPatient(Patient: TPatient);
begin
  if not Assigned(Patient) then
    raise Exception.Create('Patient object is nil');

  FPatient := Patient;

  // Заполняем элементы управления данными пациента
  edtName.Text := Patient.Name;
  dtpBirthDate.Date := Patient.BirthDate;

  // Устанавливаем пол (если не найден - добавляем)
  if cbGender.Items.IndexOf(Patient.Gender) = -1 then
    cbGender.Items.Add(Patient.Gender);
  cbGender.ItemIndex := cbGender.Items.IndexOf(Patient.Gender);

  edtPhone.Text := Patient.Phone;
  edtWorkplace.Text := Patient.Workplace;
end;

function TPatientCardFrame.ValidateData: Boolean;
begin
  Result := False;

  if Trim(edtName.Text) = '' then
  begin
    ShowMessage('Введите ФИО пациента');
    edtName.SetFocus;
    Exit;
  end;

  if cbGender.ItemIndex = -1 then
  begin
    ShowMessage('Выберите пол пациента');
    cbGender.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TPatientCardFrame.btnSaveClick(Sender: TObject);
begin
  if not ValidateData then
    Exit;

  // Сохраняем данные из элементов управления в объект пациента
  FPatient.Name := edtName.Text;
  FPatient.BirthDate := dtpBirthDate.Date;
  FPatient.Gender := cbGender.Text;
  FPatient.Phone := edtPhone.Text;
  FPatient.Workplace := edtWorkplace.Text;

  // Вызываем обработчик сохранения
  if Assigned(FOnSave) then
    FOnSave();
end;

procedure TPatientCardFrame.btnCancelClick(Sender: TObject);
begin
  // Вызываем обработчик отмены
  if Assigned(FOnCancel) then
    FOnCancel();
end;

end.
