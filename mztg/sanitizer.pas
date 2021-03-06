unit sanitizer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMacroRecorder, SynEdit, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Buttons, Spin, ComCtrls, LCLType;

type

  { TfrmSanitizer }

  TfrmSanitizer = class(TForm)
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    ReplaceDialog1: TReplaceDialog;
    SaveDialog1: TSaveDialog;
    speditMax: TSpinEdit;
    speditMin: TSpinEdit;
    Memo1: TSynEdit;
    StatusBar1: TStatusBar;
    SynMacroRecorder1: TSynMacroRecorder;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ReplaceDialog1Find(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
    procedure speditMaxChange(Sender: TObject);
    procedure speditMinChange(Sender: TObject);
    procedure SynMacroRecorder1StateChange(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
  private
    { private declarations }

  public
    { public declarations }
    sFileName : String;
    bDocChanged : Boolean;
  end;

var
  frmSanitizer: TfrmSanitizer;

implementation
uses apputils, main;
{$R *.lfm}

{ TfrmSanitizer }


procedure TfrmSanitizer.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:= caFree;
end;

procedure TfrmSanitizer.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := True;
  if bDocChanged then
       if MessageDlg('Save before Close?', mtWarning,[mbYes,mbNo],0)=mrYes then           ToolButton1.Click;
end;

procedure TfrmSanitizer.FormCreate(Sender: TObject);
begin
   LoadTranslation( frmMain.strPath+'lang'+PathDelim+frmMain.strLang+PathDelim , self);
//     WriteTranslation( frmMain.strPath+'lang'+PathDelim+frmMain.strLang+PathDelim , frmSanitizer);
end;

procedure TfrmSanitizer.Memo1Change(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:= 'Lines: '+IntToStr(Memo1.Lines.Count);
  bDocChanged := True;
end;

procedure TfrmSanitizer.Memo1Click(Sender: TObject);
begin
   StatusBar1.Panels[1].Text:= 'Row: '+IntToStr(Memo1.CaretX)+ '  Col: '+IntToStr(Memo1.CaretY);
end;


procedure TfrmSanitizer.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = LCLType.VK_F) and (ssCtrl in Shift) then ToolButton3.Click;
  if (Key = LCLType.VK_F3) then ReplaceDialog1Find(Self);

   StatusBar1.Panels[1].Text:= 'Row: '+IntToStr(Memo1.CaretX)+ '  Col: '+IntToStr(Memo1.CaretY);
end;



procedure TfrmSanitizer.ReplaceDialog1Find(Sender: TObject);
var
 n, nTemp : Integer;
 stemp : string;
begin
  bDocChanged := True;
  stemp := StringReplace(StringReplace(ReplaceDialog1.FindText, '\n', #10#13, [rfReplaceAll]), '\t', #9, [rfReplaceAll]);
  if length(Memo1.Text) > 0 then begin
    nTemp :=  Length(stemp);

      n := Pos(stemp,  Memo1.Text);
      if (n > 0) then begin
         Memo1.SelStart:= n;
         Memo1.SelEnd := n+nTemp;
      end;
  end;
end;




procedure TfrmSanitizer.ReplaceDialog1Replace(Sender: TObject);
var
 sTemp  : string;
begin
  sTemp := Memo1.Lines.Text;

  ReplaceDialog1.FindText := StringReplace(StringReplace(ReplaceDialog1.FindText, '\n', #10#13, [rfReplaceAll]), '\t', #9, [rfReplaceAll]);
  ReplaceDialog1.ReplaceText := StringReplace(StringReplace(ReplaceDialog1.ReplaceText, '\n', #10#13, [rfReplaceAll]), '\t', #9, [rfReplaceAll]);

  sTemp := StringReplace(sTemp, ReplaceDialog1.FindText, ReplaceDialog1.ReplaceText, [rfReplaceAll]);
  Memo1.Lines.Text := sTemp
end;

procedure TfrmSanitizer.speditMaxChange(Sender: TObject);
begin
  speditMin.MaxValue := speditMax.Value;
  if speditMin.Value > speditMin.MaxValue then speditMin.Value := speditMin.MinValue;
  Memo1.RightEdge:= speditMax.Value;
end;

procedure TfrmSanitizer.speditMinChange(Sender: TObject);
begin
  speditMax.MinValue := speditMin.Value;
  if speditMax.Value < speditMax.MinValue then speditMax.Value := speditMax.MinValue;
end;

procedure TfrmSanitizer.SynMacroRecorder1StateChange(Sender: TObject);
begin
  if SynMacroRecorder1.State = msStopped then
     ToolButton9.ImageIndex:= 5
  else
     ToolButton9.ImageIndex:= 8;


end;

procedure TfrmSanitizer.ToolButton11Click(Sender: TObject);
begin
 SynMacroRecorder1.PlaybackMacro(Memo1);
  bDocChanged := true;
end;

procedure TfrmSanitizer.ToolButton12Click(Sender: TObject);
var
  Count, MaxExec :Integer;
begin
MaxExec := Memo1.Lines.Count * 3;
bDocChanged := true;
Count := 0;
Memo1.Lines.BeginUpdate;
if Memo1.Lines.Count > 0 then
   while (Memo1.Carety <> Memo1.Lines.Count ) do begin
     if ( Count > MaxExec  ) then begin
         ShowMessage('Too Sloow! Infinite loop?');
         Break;
     end
     else begin
        SynMacroRecorder1.PlaybackMacro(Memo1);
        Count +=1;
     end;
end;
Memo1.Lines.EndUpdate;
end;

procedure TfrmSanitizer.ToolButton13Click(Sender: TObject);
Var
  List : TStringList;
  n1, n2 : integer;
  stemp, stemp2 : string;
begin
  if ( OpenDialog1.Execute ) then
       if (OpenDialog1.FileName <> '') then begin
           bDocChanged := true;
           List := TStringList.Create();
           List.LoadFromFile(OpenDialog1.FileName);
           Memo1.Lines.BeginUpdate;
           ProgressBar1.Visible := True;
           Memo1.Enabled:= False;
           ProgressBar1.Max:= Memo1.Lines.Count-1;

           for n1 :=  Memo1.Lines.Count-1 downto 0 do begin
               ProgressBar1.Position:= n1;
               stemp := Memo1.Lines[n1];
               if (stemp <> '') then
                  for n2 := List.Count-1 downto 0 do begin
                      stemp2 := List.Strings[n2];
                      if stemp2 <> '' then
                         if lowercase(stemp) = lowercase(stemp2) then
                            Memo1.Lines.Delete(n1);
                  end;
               Application.ProcessMessages;
           end;
           List.Free();
           Memo1.Lines.EndUpdate;
           ProgressBar1.Visible := False;
           Memo1.Enabled:= True;
       end;
end;

procedure TfrmSanitizer.ToolButton15Click(Sender: TObject);
begin
  OpenDialog1.FileName:= sFileName;
  if (OpenDialog1.Execute) then
    if (OpenDialog1.FileName <> '') then begin
       Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
       sFileName := OpenDialog1.FileName;
    end;


end;

procedure TfrmSanitizer.ToolButton16Click(Sender: TObject);
var
 list : TStringList;
begin
  list := TStringList.Create();
  list.BeginUpdate;
  list.Text := Memo1.Lines.Text;
  list.Sort();
  RemoveDuplicated(list);
  list.CustomSort( @MyListCompare );
  list.EndUpdate;
  Memo1.Lines.Text := list.Text;
  list.Free;
end;


procedure TfrmSanitizer.ToolButton1Click(Sender: TObject);
begin
  bDocChanged := False;
  SaveDialog1.FileName:= sFileName;
  if (SaveDialog1.Execute) then
    if (SaveDialog1.FileName <> '') then begin
       Memo1.Lines.SaveToFile(SaveDialog1.FileName);
       sFileName := SaveDialog1.FileName;
    end;
end;

procedure TfrmSanitizer.ToolButton2Click(Sender: TObject);
var
 list : TStringList;
 n : Integer;
begin
   list := TStringList.Create();
   list.Text := Memo1.Text;
   bDocChanged := true;

   list.BeginUpdate;
   list.Sort;
   for n := 0 to list.Count do
       if list.Strings[0] = '' then
          list.Delete(0)
       else
           Break;

   list.EndUpdate;

   Memo1.Text := list.Text ;
   list.Free;
   {
     list := TStringList.Create();
     list.AddStrings( Memo1.Lines );
     list.Sort;
     Memo1.Clear;
     Memo1.Lines.AddStrings(list);
     list.Free;}

end;

procedure TfrmSanitizer.ToolButton3Click(Sender: TObject);
begin
  ReplaceDialog1.Execute;
end;

procedure TfrmSanitizer.ToolButton5Click(Sender: TObject);
var
 list : TStringList;
begin
   list := TStringList.Create();
   bDocChanged := true;
   list.Text := Memo1.Text;
   list.CustomSort( @MyListCompare );
   Memo1.Text := list.Text ;
end;

procedure TfrmSanitizer.ToolButton7Click(Sender: TObject);
var
  List1 : TStringList;
  n, nTemp : integer;
  sTemp1, sTemp2 : string;
begin
  List1 := TStringList.create();
  bDocChanged := True;
  Memo1.Enabled := False;
  List1.BeginUpdate;
  sTemp1  := Memo1.Lines.Text;
  ProgressBar1.Visible := True;
  ProgressBar1.Max := length(sTemp1);

  for n := 1 to length(sTemp1) do begin
      ProgressBar1.position := n;
      if ( sTemp1[n] in ['(',')', '[', ']', #9, ' '] )   then
         AppendStr(sTemp2, #10#13)
      else
          if not ( sTemp1[n] in ['''', ','] )   then
             AppendStr(sTemp2, sTemp1[n]);
  end;
  List1.Text := sTemp2;
  List1.EndUpdate;

  RemoveSpecialChar(List1);

  List1.BeginUpdate;

  ProgressBar1.Visible := True;
  ProgressBar1.Max := List1.Count-1;
  Application.ProcessMessages;
  for n := List1.Count-1 downto 0 do begin
        ProgressBar1.Position:= n;
        Application.ProcessMessages;
        sTemp1 := List1.Strings[n];
        nTemp := Length( sTemp1 );
	if (nTemp < speditMin.Value) or  (nTemp > speditMax.Value) then
           List1.delete(n)
        else
            if IsStrANumber(sTemp1) then List1.delete(n);
  end;
  List1.EndUpdate;

  List1.Sort();
  RemoveDuplicated(List1);
  ProgressBar1.Visible := False;
  List1.BeginUpdate;
  List1.CustomSort( @MyListCompare );
  List1.EndUpdate;
  Application.ProcessMessages;
  Memo1.Lines.Text := List1.Text;
  Memo1.Enabled := True;
  List1.Free;
end;

procedure TfrmSanitizer.ToolButton9Click(Sender: TObject);
begin
  if ( SynMacroRecorder1.State = msStopped ) then
    SynMacroRecorder1.RecordMacro(Memo1)
  else
      SynMacroRecorder1.Stop;


end;



end.
