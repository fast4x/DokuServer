unit unit1client;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, MRUList, IdLogEvent, IdFTP, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, IdComponent,
  IdAntiFreeze, types, IdFTPList, IdFTPCommon, IdCompressorZLib, IdCoderMIME,
  IdCoderXXE, IdServerInterceptLogFile;

type

  { TMainForm }

  TMainForm = class(TForm)
    AbortButton: TButton;
    Back2: TMenuItem;
    BackButton: TButton;
    CmdUserRightsButton: TButton;
    ChDirButton: TButton;
    CurrentDirEdit: TComboBox;
    CommandPanel: TPanel;
    ConnectButton: TButton;
    CreateDirButton: TButton;
    DebugListBox: TListBox;
    Delete2: TMenuItem;
    DeleteButton: TButton;
    DirectoryListBox: TListBox;
    FilePopupMenu: TPopupMenu;
    Downloadfile: TMenuItem;
    DownloadButton: TButton;
    FileListBox: TListBox;
    FTPServerEdit: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    IdAntiFreeze1: TIdAntiFreeze;
    IdCompressorZLib1: TIdCompressorZLib;
    IdFTP1: TIdFTP;
    IdLogEvent1: TIdLogEvent;
    Image1: TImage;
    Label1: TLabel;
    FileListView: TListView;
    DirectoryListView: TListView;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LogGroupBox: TGroupBox;
    Lserver: TLabel;
    Download1: TMenuItem;
    Delete1: TMenuItem;
    Back1: TMenuItem;
    lUserID: TLabel;
    lUserID1: TLabel;
    N2: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PasswordEdit: TEdit;
    ProgressBar1: TProgressBar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    TabGen: TTabSheet;
    TabPref: TTabSheet;
    TabSheet1: TTabSheet;
    TraceCheckBox: TCheckBox;
    Upload1: TMenuItem;
    N1: TMenuItem;
    DirectoryPopupMenu: TPopupMenu;
    SaveDialog1: TSaveDialog;
    Upload2: TMenuItem;
    UploadButton: TButton;
    UploadOpenDialog1: TOpenDialog;
    UsePassive: TCheckBox;
    UserIDEdit: TEdit;
    procedure AbortButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure CmdUserRightsButtonClick(Sender: TObject);
    procedure ChDirButtonClick(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure CreateDirButtonClick(Sender: TObject);
    procedure DebugListBoxDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure Delete2Click(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure DirectoryListBoxClick(Sender: TObject);
    procedure DirectoryListBoxDblClick(Sender: TObject);
    procedure DirectoryListBoxDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure DirectoryListViewDblClick(Sender: TObject);
    procedure DownloadButtonClick(Sender: TObject);
    procedure DownloadfileClick(Sender: TObject);
    procedure FileListBoxDblClick(Sender: TObject);
    procedure FileListViewDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure IdFTP1AfterClientLogin(Sender: TObject);
    procedure IdFTP1Disconnected(Sender: TObject);
    procedure IdFTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure IdLogEvent1Received(ASender: TComponent; const AText,
      AData: string);
    procedure IdLogEvent1Sent(ASender: TComponent; const AText, AData: string);
    procedure Label3Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);

    procedure Panel1Click(Sender: TObject);
    procedure TraceCheckBoxClick(Sender: TObject);
    procedure UploadButtonClick(Sender: TObject);
    procedure UsePassiveClick(Sender: TObject);
  private
    { private declarations }
    AbortTransfer: Boolean;

    TransferrignData: Boolean;

    BytesToTransfer: LongWord;

    STime: TDateTime;
    CanDelDir, CanDelFile, CanCreaDir, CanUpload, CanDownl, CanChgDir: boolean;

    procedure ChageDir(DirName: String);

    procedure SetFunctionButtons(AValue: Boolean);

    procedure SaveFTPHostInfo(Datatext, iheader: String);

    function GetHostInfo(iheader: String): String;

    procedure PutToDebugLog(Operation, S1: String);

    procedure AddDirToMRUList(DirName: string);
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation
Uses
  IniFiles, LCLIntf;


Var

  AverageSpeed: Double = 0;


{$R *.lfm}

{ TMainForm }

procedure TMainForm.AddDirToMRUList(DirName: string);
begin
    currentdiredit.Text:=Dirname;
    if currentdiredit.Items.IndexOf(DirName) < 0 then
         currentdiredit.Items.Insert(0,DirName);

end;

procedure TMainForm.SetFunctionButtons(AValue: Boolean);

Var

  i: Integer;

begin

  with CommandPanel do

    for i := 0 to ControlCount - 1 do

      if (Controls[i].Name <> 'AbortButton')  then Controls[i].Enabled := AValue;



  with DirectoryPopupMenu do

    for i := 0 to Items.Count - 1 do Items[i].Enabled := AValue;


 ConnectButton.Enabled:=true;

 delete1.Enabled:= CanDelDir;
 delete2.Enabled:= CanDelFile;
 CreateDirButton.Enabled:=CanCreaDir;
 upload1.Enabled:=CanUpload;
 upload2.Enabled:=CanUpload;
 uploadbutton.Enabled:=CanUpload;
 downloadfile.Enabled:=CanDownl;
 downloadbutton.Enabled:=CanDownl;
 currentdiredit.Enabled:=CanChgDir;
 chdirbutton.Enabled:=CanChgDir;
 backbutton.Enabled:=CanChgDir;
 groupbox3.Visible:=CanChgDir;


end;


procedure TMainForm.ConnectButtonClick(Sender: TObject);
var ini:tinifile;
begin
  ConnectButton.Enabled := false;

    if IdFTP1.Connected then try

      if TransferrignData then IdFTP1.Abort;

      IdFTP1.Quit;

       CanDelDir:=false;
      CanDelFile:=false;
      CanCreaDir:=false;
      CanUpload:=false;
      CanDownl:=false;
      CanChgDir:=false;

    finally

      //CurrentDirEdit.Text := '/';
      AddDirToMRUList('/');

      DirectoryListBox.Items.Clear;
      FileListBox.Items.Clear;
      DirectoryListView.Items.Clear;
      FileListView.Items.Clear;


      SetFunctionButtons(false);

      ConnectButton.Caption := 'Connetti';

      ConnectButton.Enabled := true;

      ConnectButton.Default := true;

    end

    else with IdFTP1 do try

      ini:= TINIfile.Create(extractfilepath(application.ExeName)+'/dokuclient.ini');

      Username := ini.ReadString('DokuServer','Utente','');

      Password := ini.ReadString('DokuServer','Password','');

      Host := ini.ReadString('DokuServer','Server','127.0.0.1');

      Port := ini.ReadInteger('DokuServer','Porta',8383);

      Connect;

      Self.ChageDir(CurrentDirEdit.Text);

      SetFunctionButtons(true);

      SaveFTPHostInfo(FtpServerEdit.Text, 'FTPHOST');

    finally

      ConnectButton.Enabled := true;

      if Connected then begin

        ConnectButton.Caption := 'Disconnetti';

        ConnectButton.Default := false;

      end;

    end;
end;

procedure TMainForm.CreateDirButtonClick(Sender: TObject);

  Var

    S: String;

  begin

    S := InputBox('Crea una nuova cartella', 'Nome da assegnare', '');

    if S <> '' then

      try

        SetFunctionButtons(false);

        IdFTP1.MakeDir(S);

        ChageDir(CurrentDirEdit.Text);

      finally

        SetFunctionButtons(true);

      end;
end;

procedure TMainForm.DebugListBoxDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
(*
  if Pos('>>', DebugListBox.Items[index]) > 1 then

      DebugListBox.Canvas.Font.Color := clRed

    else

      DebugListBox.Canvas.Font.Color := clBlue;



    if odSelected in State then begin

      DebugListBox.Canvas.Brush.Color := $00895F0A;

      DebugListBox.Canvas.Font.Color := clWhite;

    end

    else

      DebugListBox.Canvas.Brush.Color := clWindow;



    DebugListBox.Canvas.FillRect(Rect);



    DebugListBox.Canvas.TextOut(Rect.Left, Rect.Top, DebugListBox.Items[index]);

*)
end;

procedure TMainForm.Delete2Click(Sender: TObject);
  Var  dName: String;

  begin

    if not IdFTP1.Connected then exit;

    //dName :=  IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].FileName;
    if FileListView.ItemIndex > -1 then
       dName :=  FileListView.Items[FileListView.ItemIndex].Caption
    else exit;

  (*  if FileListBox.Items.Count > 0 then begin
      showmessage('Impossibile rimuovere la cartella perchè contiene documenti.');
      exit;
    end;
  *)
   // if IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].ItemType = ditDirectory then
   try

      SetFunctionButtons(false);

      idftp1.Delete(dName);
      showmessage(idftp1.LastCmdResult.Text[0]);

      ChageDir(idftp1.RetrieveCurrentDir);

    finally

    end
  (*
    else

    try

      SetFunctionButtons(false);

      idftp1.Delete(dName);

      ChageDir(idftp1.RetrieveCurrentDir);

    finally

    end;
  *)
  end;


procedure TMainForm.AbortButtonClick(Sender: TObject);
begin
  AbortTransfer := true;
end;

procedure TMainForm.BackButtonClick(Sender: TObject);
begin
   if not IdFTP1.Connected then exit;

  try

    ChageDir('..');

  finally end;
end;

procedure TMainForm.CmdUserRightsButtonClick(Sender: TObject);
begin
   if idFtp1.SendCmd('GETUSERRIGHT') <> -1 then
   begin
//     if (idFtp.LastCmdResult.TextCode = '250') then

//      showmessage(idftp1.LastCmdResult.Text.CommaText);
     if idftp1.LastCmdResult.Text.IndexOf('candeldir=True') <> -1 then CanDelDir:=true else CanDelDir:=false;
     if idftp1.LastCmdResult.Text.IndexOf('candelfile=True') <> -1 then CanDelFile:=true else CanDelFile:=false;
     if idftp1.LastCmdResult.Text.IndexOf('cancreadir=True') <> -1 then CanCreaDir:=true else CanCreaDir:=false;
     if idftp1.LastCmdResult.Text.IndexOf('canupload=True') <> -1 then CanUpload:=true else CanUpload:=false;
     if idftp1.LastCmdResult.Text.IndexOf('candownl=True') <> -1 then CanDownl:=true else CanDownl:=false;
     if idftp1.LastCmdResult.Text.IndexOf('canchgdir=True') <> -1 then CanChgDir:=true else CanChgDir:=false;

   end;

end;

procedure TMainForm.ChDirButtonClick(Sender: TObject);
begin
  SetFunctionButtons(false);

  ChageDir(CurrentDirEdit.Text);

  SetFunctionButtons(true);
end;

procedure TMainForm.DeleteButtonClick(Sender: TObject);
Var  dName: String;

begin

  if not IdFTP1.Connected then exit;

  //dName :=  IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].FileName;
  if DirectoryListView.ItemIndex > -1 then
     dName :=  DirectoryListView.Items[DirectoryListView.ItemIndex].Caption
  else exit;

(*  if FileListBox.Items.Count > 0 then begin
    showmessage('Impossibile rimuovere la cartella perchè contiene documenti.');
    exit;
  end;
*)
 // if IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].ItemType = ditDirectory then
 try

    SetFunctionButtons(false);

    idftp1.RemoveDir(dName);

    ChageDir(idftp1.RetrieveCurrentDir);

  finally

  end
(*
  else

  try

    SetFunctionButtons(false);

    idftp1.Delete(dName);

    ChageDir(idftp1.RetrieveCurrentDir);

  finally

  end;
*)
end;

procedure TMainForm.DirectoryListBoxClick(Sender: TObject);
begin
  if not IdFTP1.Connected then exit;

(*
  if DirectoryListBox.ItemIndex > -1 then begin

  if IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].ItemType = ditDirectory then DownloadButton.Caption := 'Change dir'

    else DownloadButton.Caption := 'Download';

  end;
*)
end;

procedure TMainForm.DirectoryListBoxDblClick(Sender: TObject);
Var

  bName{, Line}: String;

begin

  if not IdFTP1.Connected then exit;

  //Line := DirectoryListBox.Items[DirectoryListBox.ItemIndex];

  //bName := IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].FileName;
  if DirectoryListBox.ItemIndex > -1 then
  bName := DirectoryListBox.Items[DirectoryListBox.ItemIndex]
  else exit;

//  if IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].ItemType = ditDirectory then begin

    // Change directory

    SetFunctionButtons(false);

    ChageDir(bName);

    SetFunctionButtons(true);

//  end
(*
  else begin

    try

      SaveDialog1.FileName := bName;

      if SaveDialog1.Execute then begin

        SetFunctionButtons(false);



        IdFTP1.TransferType := ftBinary;

        BytesToTransfer := IdFTP1.Size(bName);



        if FileExists(bName) then begin

          case MessageDlg('File aready exists. Do you want to resume the download operation?',

            mtConfirmation, mbYesNoCancel, 0) of

            mrYes: begin

              BytesToTransfer := BytesToTransfer - FileSize(bName);

              IdFTP1.Get(bName, SaveDialog1.FileName, false, true);

            end;

            mrNo: begin

              IdFTP1.Get(Name, SaveDialog1.FileName, true);

            end;

            mrCancel: begin

              exit;

            end;

          end;

        end

        else begin

          IdFTP1.Get(bName, SaveDialog1.FileName, false);

        end;

      end;

    finally

      SetFunctionButtons(true);

    end;

  end;
  *)
end;

procedure TMainForm.DirectoryListBoxDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);

(*
  Const Widths : array[0..5] of integer = (70,20,40,40,40,50);



  function getWidth (x:integer):integer;



  begin

   {$IFDEF FPC}

      Result:=Widths[x];

   {$ELSE}



      Result:=HeaderControl1.Sections.Items[i].Width;

  {$ENDIF}



  end;

  Var

    R: TRect;
*)
  begin
(*
    if odSelected in State then begin

      DirectoryListBox.Canvas.Brush.Color := $00895F0A;

      DirectoryListBox.Canvas.Font.Color := clWhite;

    end

    else

      DirectoryListBox.Canvas.Brush.Color := clWindow;



    if Assigned(IdFTP1.DirectoryListing) and (IdFTP1.DirectoryListing.Count > Index) then begin

      DirectoryListBox.Canvas.FillRect(Rect);

      with IdFTP1.DirectoryListing.Items[Index] do begin

        DirectoryListBox.Canvas.TextOut(Rect.Left, Rect.Top, FileName);

        R := Rect;



        R.Left := Rect.Left + getWidth (0);

        R.Right := R.Left + getWidth (1);



        DirectoryListBox.Canvas.FillRect(R);

        DirectoryListBox.Canvas.TextOut(R.Left, Rect.Top, IntToStr(Size));



        R.Left := R.Right;

        R.Right := R.Left + getWidth (2);

        DirectoryListBox.Canvas.FillRect(R);



        if ItemType = ditDirectory then begin

          DirectoryListBox.Canvas.TextOut(R.Left, Rect.Top, 'Directory');

        end

        else

          DirectoryListBox.Canvas.TextOut(R.Left, Rect.Top, 'File');



        R.Left := R.Right;

        R.Right := R.Left + getWidth (3);

        DirectoryListBox.Canvas.FillRect(R);

        DirectoryListBox.Canvas.TextOut(R.Left, Rect.Top, FormatDateTime('mm/dd/yyyy hh:mm', ModifiedDate));



        R.Left := R.Right;

        R.Right := R.Left + getWidth (4);

        DirectoryListBox.Canvas.FillRect(R);

        DirectoryListBox.Canvas.TextOut(R.Left, Rect.Top, GroupName);



        R.Left := R.Right;

        R.Right := R.Left + getWidth (5);

        DirectoryListBox.Canvas.FillRect(R);

        DirectoryListBox.Canvas.TextOut(R.Left, Rect.Top, OwnerName);



        R.Left := R.Right;

        R.Right := R.Left + getWidth (6);

        DirectoryListBox.Canvas.FillRect(R);

        DirectoryListBox.Canvas.TextOut(R.Left, Rect.Top, OwnerPermissions + GroupPermissions + UserPermissions);

      end;

    end;
*)
end;

procedure TMainForm.DirectoryListViewDblClick(Sender: TObject);
Var

  bName{, Line}: String;

begin

  if not IdFTP1.Connected then exit;

  //Line := DirectoryListBox.Items[DirectoryListBox.ItemIndex];

  //bName := IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].FileName;

  if DirectoryListView.ItemIndex > -1 then
  bName := DirectoryListView.Items[DirectoryListView.ItemIndex].Caption
  else exit;

//  if IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].ItemType = ditDirectory then begin

    // Change directory

    SetFunctionButtons(false);

    ChageDir(bName);

    SetFunctionButtons(true);

//  end
(*
  else begin

    try

      SaveDialog1.FileName := bName;

      if SaveDialog1.Execute then begin

        SetFunctionButtons(false);



        IdFTP1.TransferType := ftBinary;

        BytesToTransfer := IdFTP1.Size(bName);



        if FileExists(bName) then begin

          case MessageDlg('File aready exists. Do you want to resume the download operation?',

            mtConfirmation, mbYesNoCancel, 0) of

            mrYes: begin

              BytesToTransfer := BytesToTransfer - FileSize(bName);

              IdFTP1.Get(bName, SaveDialog1.FileName, false, true);

            end;

            mrNo: begin

              IdFTP1.Get(Name, SaveDialog1.FileName, true);

            end;

            mrCancel: begin

              exit;

            end;

          end;

        end

        else begin

          IdFTP1.Get(bName, SaveDialog1.FileName, false);

        end;

      end;

    finally

      SetFunctionButtons(true);

    end;

  end;
  *)

end;

procedure TMainForm.DownloadButtonClick(Sender: TObject);
begin

end;

procedure TMainForm.DownloadfileClick(Sender: TObject);
Var

  bName{, Line}: String;

begin

  if not IdFTP1.Connected then exit;

  //Line := DirectoryListBox.Items[DirectoryListBox.ItemIndex];

  //bName := IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].FileName;
  if DirectoryListView.ItemIndex > -1 then
  bName := DirectoryListView.Items[DirectoryListView.ItemIndex].Caption
  else exit;

//  if IdFTP1.DirectoryListing.Items[DirectoryListBox.ItemIndex].ItemType = ditDirectory then begin

    // Change directory

    SetFunctionButtons(false);

    ChageDir(bName);

    SetFunctionButtons(true);

//  end
(*
  else begin

    try

      SaveDialog1.FileName := bName;

      if SaveDialog1.Execute then begin

        SetFunctionButtons(false);



        IdFTP1.TransferType := ftBinary;

        BytesToTransfer := IdFTP1.Size(bName);



        if FileExists(bName) then begin

          case MessageDlg('File aready exists. Do you want to resume the download operation?',

            mtConfirmation, mbYesNoCancel, 0) of

            mrYes: begin

              BytesToTransfer := BytesToTransfer - FileSize(bName);

              IdFTP1.Get(bName, SaveDialog1.FileName, false, true);

            end;

            mrNo: begin

              IdFTP1.Get(Name, SaveDialog1.FileName, true);

            end;

            mrCancel: begin

              exit;

            end;

          end;

        end

        else begin

          IdFTP1.Get(bName, SaveDialog1.FileName, false);

        end;

      end;

    finally

      SetFunctionButtons(true);

    end;

  end;
  *)
end;


procedure TMainForm.FileListBoxDblClick(Sender: TObject);
var bName:string;
begin
   if not IdFTP1.Connected then exit;

//  bName := IdFTP1.DirectoryListing.Items[FileListBox.ItemIndex].FileName;

   if FileListBox.ItemIndex > -1 then
   bName:= FileListBox.items[FileListBox.ItemIndex]
   else exit;

    try

      SaveDialog1.FileName := bName;

      if SaveDialog1.Execute then begin

        SetFunctionButtons(false);



        IdFTP1.TransferType := ftBinary;

        BytesToTransfer := IdFTP1.Size(bName);



        if FileExists(bName) then begin

          case MessageDlg('Il file esiste già. Lo vuoi scaricare di nuovo?',

            mtConfirmation, mbYesNoCancel, 0) of

            mrYes: begin

              BytesToTransfer := BytesToTransfer - FileSize(bName);

              IdFTP1.Get(bName, SaveDialog1.FileName, false, true);

            end;

            mrNo: begin

              IdFTP1.Get(bName, SaveDialog1.FileName, true);

            end;

            mrCancel: begin

              exit;

            end;

          end;

        end

        else begin

          IdFTP1.Get(bName, SaveDialog1.FileName, false);

        end;

      end;

    finally

      SetFunctionButtons(true);

    end;



end;

procedure TMainForm.FileListViewDblClick(Sender: TObject);
var bName:string;
begin

  if not CanDownl then exit;

   if not IdFTP1.Connected then exit;

//  bName := IdFTP1.DirectoryListing.Items[FileListBox.ItemIndex].FileName;

   if FileListView.ItemIndex > -1 then
   bName:= FileListView.items[FileListView.ItemIndex].Caption
   else exit;

    try

      SaveDialog1.FileName := bName;

      if SaveDialog1.Execute then begin

        SetFunctionButtons(false);



        IdFTP1.TransferType := ftBinary;

        BytesToTransfer := IdFTP1.Size(bName);



        if FileExists(bName) then begin

          case MessageDlg('Il file esiste già. Lo vuoi scaricare di nuovo?',

            mtConfirmation, mbYesNoCancel, 0) of

            mrYes: begin

              BytesToTransfer := BytesToTransfer - FileSize(bName);

              IdFTP1.Get(bName, SaveDialog1.FileName, false, true);

            end;

            mrNo: begin

              IdFTP1.Get(bName, SaveDialog1.FileName, true);

            end;

            mrCancel: begin

              exit;

            end;

          end;

        end

        else begin

          IdFTP1.Get(bName, SaveDialog1.FileName, false);

        end;

      end;

    finally

      SetFunctionButtons(true);

    end;



end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CurrentDirEdit.Items.SaveToFile('./recentdir.txt');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin

      CanDelDir:=false;
      CanDelFile:=false;
      CanCreaDir:=false;
      CanUpload:=false;
      CanDownl:=false;
      CanChgDir:=false;

  SetFunctionButtons(false);


  FtpServerEdit.Text := GetHostInfo('FTPHOST');

  ProgressBar1.Parent := StatusBar1;

 // ProgressBar1.Top := 4;

  ProgressBar1.Left := 2;

  //ProgressBar1.Align := alClient;
  AbortButton.Parent:=StatusBar1;
  AbortButton.Align:=alRight;

  if fileexists('./recentdir.txt') then CurrentDirEdit.Items.LoadFromFile('./recentdir.txt');



end;

procedure TMainForm.IdFTP1AfterClientLogin(Sender: TObject);
begin
  CmdUserRightsButtonClick(Sender);
end;

procedure TMainForm.IdFTP1Disconnected(Sender: TObject);
begin
  StatusBar1.Panels[1].Text := 'Disconnesso.';
end;

procedure TMainForm.IdFTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  DebugListBox.ItemIndex := DebugListBox.Items.Add(aStatusText);

  StatusBar1.Panels[1].Text := aStatusText;
end;

procedure TMainForm.IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
Var

  S: String;

  TotalTime: TDateTime;

//  RemainingTime: TDateTime;

  H, M, Sec, MS: Word;

  DLTime: Double;

begin

  TotalTime :=  Now - STime;

  DecodeTime(TotalTime, H, M, Sec, MS);

  Sec := Sec + M * 60 + H * 3600;

  DLTime := Sec + MS / 1000;

  if DLTime > 0 then

    AverageSpeed := {(AverageSpeed + }(AWorkCount / 1024) / DLTime{) / 2};



  if AverageSpeed > 0 then begin

    Sec := Trunc(((ProgressBar1.Max - AWorkCount) / 1024) / AverageSpeed);



    S := Format('%2d:%2d:%2d', [Sec div 3600, (Sec div 60) mod 60, Sec mod 60]);



    S := 'Tempo rimanente ' + S;

  end

  else S := '';



  S := FormatFloat('0.00 KB/s', AverageSpeed) + '; ' + S;

  case AWorkMode of

    wmRead: StatusBar1.Panels[1].Text := 'Velocità scaricamento ' + S;

    wmWrite: StatusBar1.Panels[1].Text := 'Velocità caricamento ' + S;

  end;



  if AbortTransfer then IdFTP1.Abort;



  ProgressBar1.Position := AWorkCount;

  AbortTransfer := false;

end;

procedure TMainForm.IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  TransferrignData := true;

    AbortButton.Visible := true;

    AbortTransfer := false;

    STime := Now;

    if AWorkCountMax > 0 then ProgressBar1.Max := AWorkCountMax

    else ProgressBar1.Max := BytesToTransfer;

    AverageSpeed := 0;
end;

procedure TMainForm.IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  AbortButton.Visible := false;

    StatusBar1.Panels[1].Text := 'Transferimento completo.';

    BytesToTransfer := 0;

    TransferrignData := false;

    ProgressBar1.Position := 0;

    AverageSpeed := 0;
end;

procedure TMainForm.IdLogEvent1Received(ASender: TComponent; const AText,
  AData: string);
begin
   PutToDebugLog('<<- ', AData);
end;

procedure TMainForm.IdLogEvent1Sent(ASender: TComponent; const AText, AData: string
  );
begin
    PutToDebugLog('->> ', AData);
end;

procedure TMainForm.Label3Click(Sender: TObject);
begin
    OpenURL('http://www.rinorusso.it');
end;

procedure TMainForm.Label6Click(Sender: TObject);
begin
    OpenURL('http://www.fasttools.it');
end;



procedure TMainForm.Panel1Click(Sender: TObject);
begin

end;

procedure TMainForm.TraceCheckBoxClick(Sender: TObject);
begin
  if TraceCheckBox.Checked then

    IdFtp1.Intercept := IdLogEvent1

  else

    IdFtp1.Intercept := nil;



  LogGroupBox.Visible := TraceCheckBox.Checked;

//  if LogGroupBox.Visible then Splitter1.Top := DebugListBox.Top + 5;
end;

procedure TMainForm.UploadButtonClick(Sender: TObject);
begin
    if IdFTP1.Connected then begin

        if UploadOpenDialog1.Execute then try

          SetFunctionButtons(false);

         IdFTP1.TransferType := ftBinary;



          IdFTP1.Put(UploadOpenDialog1.FileName, ExtractFileName(UploadOpenDialog1.FileName));

          ChageDir(idftp1.RetrieveCurrentDir);

        finally

          SetFunctionButtons(true);

        end;

      end;
end;

procedure TMainForm.ChageDir(DirName: String);

Var

  LS: TStringList;
  t:word;
  nitem, nitem1 :tlistitem;

begin

 // LS := TStringList.Create;

//  if (DirName='..') and (not CanChgDir) then exit;

  try

    SetFunctionButtons(false);

    if DirName='..' then IdFTP1.ChangeDirUp else IdFTP1.ChangeDir(DirName);


    IdFTP1.TransferType := ftASCII;



    //CurrentDirEdit.Text := IdFTP1.RetrieveCurrentDir;
    AddDirToMRUList(IdFTP1.RetrieveCurrentDir);


    DirectoryListBox.Items.Clear;
    FileListBox.Items.Clear;
    FileListView.Items.clear;
    DirectoryListView.Items.clear;

    //IdFTP1.List(LS);
    IdFTP1.List;

    for t:=0 to IdFTP1.DirectoryListing.count -1 do begin
       if IdFTP1.DirectoryListing.Items[t].ItemType = ditDirectory then begin
           // DirectoryListBox.Items.Add(IdFTP1.DirectoryListing.Items[t].FileName);

            if (IdFTP1.DirectoryListing.Items[t].FileName <> '.')  then begin
            nitem:=TListItem.Create(DirectoryListView.Items);
            nitem.Caption:=IdFTP1.DirectoryListing.Items[t].FileName;
            DirectoryListView.Items.AddItem(nitem);
           // nitem.Free;
            end;

       end
       else begin
           // FileListBox.Items.Add(IdFTP1.DirectoryListing.Items[t].FileName);
            nitem1:=TListItem.Create(FileListView.Items);
            nitem1.Caption:=IdFTP1.DirectoryListing.Items[t].FileName;
            nitem1.SubItems.Add(inttostr(IdFTP1.DirectoryListing.Items[t].Size div 1024)+ ' Kb');
            nitem1.SubItems.Add(datetimetostr(IdFTP1.DirectoryListing.Items[t].ModifiedDate));
            FileListView.Items.AddItem(nitem1);
           // nitem1.Free;

       end;
    end;

    //DirectoryListBox.Items.Assign(LS);
    //end;

 //   if DirectoryListBox.Items.Count > 0 then

 //     if AnsiPos('total', DirectoryListBox.Items[0]) > 0 then DirectoryListBox.Items.Delete(0);

  finally

    SetFunctionButtons(true);

 //   LS.Free;

  end;

end;

procedure TMainForm.UsePassiveClick(Sender: TObject);
begin
  IdFTP1.Passive := UsePassive.Checked;
end;


procedure TMainForm.SaveFTPHostInfo(Datatext, iheader: String);

var

  ServerIni: TIniFile;

begin

  ServerIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'FtpHost.ini');

  ServerIni.WriteString('Server', iheader, Datatext);

  ServerIni.UpdateFile;

  ServerIni.Free;

end;



function TMainForm.GetHostInfo(iheader: String): String;

var

  ServerName: String;

  ServerIni: TIniFile;

begin

  ServerIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'FtpHost.ini');

  ServerName := ServerIni.ReadString('Server', iheader, iheader);



  ServerIni.Free;

  result := ServerName;

end;



procedure TMainForm.PutToDebugLog(Operation, S1: String);

Var

  S: String;

begin

  while Length(S1) > 0 do begin

    if Pos(#13, S1) > 0 then begin

      S := Copy(S1, 1, Pos(#13, S1) - 1);

      Delete(S1, 1, Pos(#13, S1));

      if S1[1] = #10 then Delete(S1, 1, 1);

    end

    else

      S := S1;



    DebugListBox.ItemIndex := DebugListBox.Items.Add(Operation + S);

  end;

end;


end.

