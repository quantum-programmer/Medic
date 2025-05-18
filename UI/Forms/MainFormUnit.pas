unit MainFormUnit;

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
    procedure OpenPatientCard(Patient: TPatient; IsNewPatient: Boolean = False);
    function GetSelectedPatientId: Integer;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  DependencyInjection;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPatientService := DependencyInjection.PatientService;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Настройка колонок грида
  with cxGridDBTableView do
  begin
    ClearItems;

    // Колонка ID
    CreateColumn;
    Columns[0].Caption := 'ID';
    Columns[0].DataBinding.ValueType := 'Integer';
    Columns[0].Width := 50;

    // Колонка ФИО
    CreateColumn;
    Columns[1].Caption := 'ФИО пациента';
    Columns[1].DataBinding.ValueType := 'String';
    Columns[1].Width := 250;

    // Включаем сортировку
    OptionsCustomize.ColumnSorting := True;
    OptionsView.HeaderAutoHeight := True;
    OptionsView.HeaderHeight := 25;
  end;

  // Загружаем данные
  LoadPatients;
end;

procedure TMainForm.LoadPatients(const Filter: string = '');
var
  Patients: TArray<TPatient>;
  Patient: TPatient;
begin
  cxGridDBTableView.BeginUpdate;
  try
    cxGridDBTableView.DataController.RecordCount := 0;
    Patients := FPatientService.GetAllPatients;

    for Patient in Patients do
    begin
      // Сравниваем без учета регистра
      if (Filter = '') or
         (Pos(AnsiUpperCase(Filter), AnsiUpperCase(Patient.Name)) > 0) then
      begin
        cxGridDBTableView.DataController.AppendRecord;
        cxGridDBTableView.DataController.Values[
          cxGridDBTableView.DataController.RecordCount - 1, 0] := Patient.Id;
        cxGridDBTableView.DataController.Values[
          cxGridDBTableView.DataController.RecordCount - 1, 1] := Patient.Name;
      end;
    end;

    // Сортировка по ФИО по возрастанию
    if cxGridDBTableView.ColumnCount > 1 then
    begin
      cxGridDBTableView.Columns[1].SortIndex := 0;
      cxGridDBTableView.Columns[1].SortOrder := TcxDataSortOrder.soAscending;
    end;
  finally
    cxGridDBTableView.EndUpdate;
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

procedure TMainForm.OpenPatientCard(Patient: TPatient; IsNewPatient: Boolean);
var
  Tab: TcxTabSheet;
  Frame: TPatientCardFrame;
begin
  Tab := TcxTabSheet.Create(cxPageControl);
  try
    Tab.Caption := Patient.Name;
    Tab.PageControl := cxPageControl;

    Frame := TPatientCardFrame.Create(Tab);
    Frame.Parent := Tab;
    Frame.Align := alClient;
    Frame.LoadPatient(Patient);

    Frame.OnSave := procedure
    begin
      FPatientService.SavePatient(Patient);
      LoadPatients(edtSearch.Text);
      Tab.Free;
    end;

    Frame.OnCancel := procedure
    begin
      if IsNewPatient then
        FPatientService.DeletePatient(Patient.Id);
      Tab.Free;
    end;

    cxPageControl.ActivePage := Tab;
  except
    Tab.Free;
    raise;
  end;
end;

procedure TMainForm.btnAddClick(Sender: TObject);
var
  NewPatient: TPatient;
begin
  NewPatient := TPatient.Create;
  try
    NewPatient.Id := FPatientService.GetNewPatientId;
    NewPatient.Name := 'Новый пациент';
    NewPatient.BirthDate := Now;
    NewPatient.Gender := 'Мужской';
    NewPatient.Phone := '';
    NewPatient.Workplace := '';

    OpenPatientCard(NewPatient, True);
  except
    NewPatient.Free;
    raise;
  end;
end;

procedure TMainForm.btnEditClick(Sender: TObject);
var
  PatientId: Integer;
  Patient: TPatient;
begin
  PatientId := GetSelectedPatientId;
  if PatientId > 0 then
  begin
    Patient := FPatientService.GetPatientById(PatientId);
    if Assigned(Patient) then
      OpenPatientCard(Patient);
  end;
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
