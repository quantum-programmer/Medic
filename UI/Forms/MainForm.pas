unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPC, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, Vcl.StdCtrls, Vcl.ExtCtrls,
  Patient, IPatientServ, PatientCardFrame,
  dxBarBuiltInMenu, dxUIAClasses, dxScrollbarAnnotations, Data.DB, cxDBData;

type
  TMainForm = class(TForm)
    cxPageControl: TcxPageControl;
    tsPatientsList: TcxTabSheet;
    pnlControls: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    edtSearch: TEdit;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure cxGridDBTableViewDblClick(Sender: TObject);
  private
    FPatientService: IPatientService;
    procedure LoadPatients(const Filter: string = '');
    procedure OpenPatientCard(PatientId: Integer);
    function GetSelectedPatientId: Integer;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  MainF: TMainForm;

implementation

{$R *.dfm}

uses
  DependencyInjection;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPatientService := PatientService;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Настройка грида
  cxGridDBTableView.CreateColumn;
  cxGridDBTableView.Columns[0].Caption := 'ID';
  cxGridDBTableView.Columns[0].DataBinding.ValueType := 'Integer';
  cxGridDBTableView.Columns[0].Width := 50;

  cxGridDBTableView.CreateColumn;
  cxGridDBTableView.Columns[1].Caption := 'ФИО';
  cxGridDBTableView.Columns[1].Width := 200;

  LoadPatients;
end;

procedure TMainForm.LoadPatients(const Filter: string);
var
  Patients: TArray<TPatient>;
  Patient: TPatient;
begin
  Patients := FPatientService.GetAllPatients;
  cxGridDBTableView.DataController.RecordCount := 0;

  for Patient in Patients do
  begin
    if (Filter = '') or (Pos(LowerCase(Filter), LowerCase(Patient.Name)) > 0) then
    begin
      cxGridDBTableView.DataController.AppendRecord;
      cxGridDBTableView.DataController.Values[
        cxGridDBTableView.DataController.RecordCount - 1, 0] := Patient.Id;
      cxGridDBTableView.DataController.Values[
        cxGridDBTableView.DataController.RecordCount - 1, 1] := Patient.Name;
    end;
  end;
end;

function TMainForm.GetSelectedPatientId: Integer;
begin
  if cxGridDBTableView.DataController.FocusedRecordIndex >= 0 then
    Result := cxGridDBTableView.DataController.Values[
      cxGridDBTableView.DataController.FocusedRecordIndex, 0]
  else
    Result := -1;
end;

procedure TMainForm.OpenPatientCard(PatientId: Integer);
var
  Tab: TcxTabSheet;
  Frame: TPatientCardFrame;
  Patient: TPatient;
begin
  Patient := FPatientService.GetPatientById(PatientId);
  if Patient = nil then Exit;

  // Создаем вкладку DevExpress
  Tab := TcxTabSheet.Create(cxPageControl);
  Tab.Caption := Patient.Name;
  Tab.PageControl := cxPageControl;

  // Создаем фрейм
  Frame := TPatientCardFrame.Create(Tab);
  Frame.Parent := Tab;
  Frame.Align := alClient;
  Frame.LoadPatient(Patient);

  Frame.OnSave := procedure
  begin
    FPatientService.SavePatient(Patient);
    Tab.Free;
  end;

  Frame.OnCancel := procedure
  begin
    Tab.Free;
  end;
end;

procedure TMainForm.btnAddClick(Sender: TObject);
var
  NewPatient: TPatient;
begin
  NewPatient := TPatient.Create;
  try
    NewPatient.Id := Random(1000000);
    OpenPatientCard(NewPatient.Id);
  except
    NewPatient.Free;
    raise;
  end;
end;

procedure TMainForm.btnEditClick(Sender: TObject);
var
  PatientId: Integer;
begin
  PatientId := GetSelectedPatientId;
  if PatientId > 0 then
    OpenPatientCard(PatientId);
end;

procedure TMainForm.btnDeleteClick(Sender: TObject);
var
  PatientId: Integer;
begin
  PatientId := GetSelectedPatientId;
  if (PatientId > 0) and (MessageDlg('Удалить пациента?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    FPatientService.DeletePatient(PatientId);
    LoadPatients;
  end;
end;

procedure TMainForm.edtSearchChange(Sender: TObject);
begin
  LoadPatients(edtSearch.Text);
end;

procedure TMainForm.cxGridDBTableViewDblClick(Sender: TObject);
begin
  btnEdit.Click;
end;

end.
