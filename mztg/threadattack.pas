unit threadattack;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, hybridgen;

type
  TThreadAttack = class(TThread)
  private
    { Private declarations }
    Text : String;
  protected
    { Protected declarations }
    procedure Execute; override;
  public
    procedure Settext(s:String);
  end;

var
  nStatusCounter, nThreadMax, nThreadCount : Integer;

implementation



uses main, brute, apputils;

 procedure TThreadAttack.SetText(s:String);
 begin
   Text := s;
 end;



procedure TThreadAttack.Execute;
begin
    AppendFile( Text );
    nThreadCount  -= 1;
end;


end.
