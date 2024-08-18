object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Consultar CEP'
  ClientHeight = 273
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 454
    Height = 273
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 450
    ExplicitHeight = 640
    object Label1: TLabel
      Left = 15
      Top = 11
      Width = 24
      Height = 15
      Caption = 'Cep:'
    end
    object Label3: TLabel
      Left = 15
      Top = 75
      Width = 65
      Height = 15
      Caption = 'Logradouro:'
    end
    object Label4: TLabel
      Left = 15
      Top = 125
      Width = 34
      Height = 15
      Caption = 'Bairro:'
    end
    object Label5: TLabel
      Left = 223
      Top = 125
      Width = 60
      Height = 15
      Caption = 'Localidade:'
    end
    object Label6: TLabel
      Left = 392
      Top = 125
      Width = 17
      Height = 15
      Caption = 'UF:'
    end
    object Label7: TLabel
      Left = 15
      Top = 179
      Width = 80
      Height = 15
      Caption = 'Complemento:'
    end
    object btnCep: TButton
      Left = 366
      Top = 239
      Width = 75
      Height = 25
      Caption = 'Consultar'
      TabOrder = 6
      OnClick = btnCepClick
    end
    object edLogradouro: TEdit
      Left = 15
      Top = 96
      Width = 426
      Height = 23
      TabOrder = 1
    end
    object edLocalidade: TEdit
      Left = 223
      Top = 146
      Width = 163
      Height = 23
      TabOrder = 3
    end
    object edBairro: TEdit
      Left = 16
      Top = 146
      Width = 201
      Height = 23
      TabOrder = 2
    end
    object edUF: TEdit
      Left = 392
      Top = 146
      Width = 49
      Height = 23
      TabOrder = 4
    end
    object edComplemento: TEdit
      Left = 16
      Top = 200
      Width = 426
      Height = 23
      TabOrder = 5
    end
    object rdTipoResult: TRadioGroup
      Left = 301
      Top = 11
      Width = 140
      Height = 59
      Caption = 'Tipo de Resultado  '
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'JSON'
        'XML')
      TabOrder = 7
    end
    object edCep: TEdit
      Left = 16
      Top = 32
      Width = 121
      Height = 23
      MaxLength = 9
      TabOrder = 0
      OnExit = edCepExit
      OnKeyPress = edCepKeyPress
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 248
    Top = 16
  end
end
