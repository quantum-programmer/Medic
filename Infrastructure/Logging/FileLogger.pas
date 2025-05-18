unit FileLogger;

interface

uses
  System.SysUtils, System.IOUtils;

type
  ILogger = interface
    ['{E7EF536F-5CA9-4D8B-9D3A-2C7A1B4D6F8E}']
    procedure Log(const Msg: string);
  end;

  TFileLogger = class(TInterfacedObject, ILogger)
  private
    FLogFile: string;
  public
    constructor Create(const LogFile: string);
    procedure Log(const Msg: string);
  end;

implementation

constructor TFileLogger.Create(const LogFile: string);
begin
  FLogFile := LogFile;
  if not TDirectory.Exists(ExtractFilePath(FLogFile)) then
    TDirectory.CreateDirectory(ExtractFilePath(FLogFile));
end;

procedure TFileLogger.Log(const Msg: string);
begin
  TFile.AppendAllText(FLogFile, Format('%s: %s%s',
    [DateTimeToStr(Now), Msg, sLineBreak]));
end;

end.
