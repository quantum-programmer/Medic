object PatientCardFrame: TPatientCardFrame
  Left = 0
  Top = 0
  Width = 601
  Height = 400
  TabOrder = 0
  object pnlButtons: TPanel
    Left = 0
    Top = 359
    Width = 601
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitWidth = 600
    object btnSave: TButton
      Left = 400
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 500
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object gbPatientInfo: TGroupBox
    Left = 0
    Top = 0
    Width = 601
    Height = 359
    Align = alClient
    Caption = 'Patient Information'
    TabOrder = 1
    ExplicitWidth = 600
    object lblName: TLabel
      Left = 16
      Top = 24
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object lblBirthDate: TLabel
      Left = 16
      Top = 80
      Width = 48
      Height = 13
      Caption = 'Birth Date'
    end
    object lblGender: TLabel
      Left = 16
      Top = 136
      Width = 35
      Height = 13
      Caption = 'Gender'
    end
    object lblPhone: TLabel
      Left = 16
      Top = 192
      Width = 30
      Height = 13
      Caption = 'Phone'
    end
    object lblWorkplace: TLabel
      Left = 16
      Top = 248
      Width = 50
      Height = 13
      Caption = 'Workplace'
    end
    object edtName: TEdit
      Left = 16
      Top = 43
      Width = 200
      Height = 21
      TabOrder = 0
    end
    object dtpBirthDate: TDateTimePicker
      Left = 16
      Top = 99
      Width = 200
      Height = 21
      Date = 43831.000000000000000000
      Time = 43831.000000000000000000
      TabOrder = 1
    end
    object cbGender: TComboBox
      Left = 16
      Top = 155
      Width = 200
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'Male'
      Items.Strings = (
        'Male'
        'Female'
        'Other')
    end
    object edtPhone: TEdit
      Left = 16
      Top = 211
      Width = 200
      Height = 21
      TabOrder = 3
    end
    object edtWorkplace: TEdit
      Left = 16
      Top = 267
      Width = 200
      Height = 21
      TabOrder = 4
    end
  end
end
