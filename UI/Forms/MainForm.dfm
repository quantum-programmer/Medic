object MainF: TMainForm
  Left = 0
  Top = 0
  Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1080#1077' '#1082#1072#1088#1090#1099
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 600
    Align = alClient
    TabOrder = 0
    Properties.ActivePage = tsPatientsList
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 596
    ClientRectLeft = 4
    ClientRectRight = 796
    ClientRectTop = 24
    object tsPatientsList: TcxTabSheet
      Caption = #1057#1087#1080#1089#1086#1082' '#1087#1072#1094#1080#1077#1085#1090#1086#1074
      ImageIndex = 0
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlControls: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 41
        Align = alTop
        TabOrder = 0
        object btnAdd: TButton
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btnAddClick
        end
        object btnEdit: TButton
          Left = 89
          Top = 8
          Width = 94
          Height = 25
          Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 1
          OnClick = btnEditClick
        end
        object btnDelete: TButton
          Left = 189
          Top = 8
          Width = 75
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btnDeleteClick
        end
        object edtSearch: TEdit
          Left = 270
          Top = 10
          Width = 200
          Height = 21
          TabOrder = 3
          TextHint = #1055#1086#1080#1089#1082' '#1087#1086' '#1060#1048#1054'...'
          OnChange = edtSearchChange
        end
      end
      object cxGrid: TcxGrid
        Left = 0
        Top = 41
        Width = 792
        Height = 531
        Align = alClient
        TabOrder = 1
        object cxGridDBTableView: TcxGridDBTableView
          OnDblClick = cxGridDBTableViewDblClick
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.GroupByBox = False
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
    end
  end
end
