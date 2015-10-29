unit Connect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SmtpProt, ComCtrls, MSI_GUI,
  OleCtrls, SHDocVw, glLabel, glJump, jpeg,
  ExtCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Label1: TLabel;
    Memo2: TMemo;
    info: TMSystemInfo;
    WebBrowser1: TWebBrowser;
    
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure smtpConnect(Sender: TObject);
    procedure smtpConnectionFailed(Sender: TObject);
    procedure smtpSendStart(Sender: TObject);
    procedure smtpDisconnect(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FlatButton1Click(Sender: TObject);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure FlatButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses FtpServ1,unit2;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var a:integer;
begin
//flatsound1.Play;
statusbar1.panels[0].text:='Connessione in corso...';
//form2.show;
webbrowser1.Navigate('www.cgilsiracusa.it/teleassistenza/main.html');

end;

procedure TForm1.smtpConnect(Sender: TObject);
var ips,a:integer;
begin
statusbar1.panels[0].text:='Connesso';
statusbar1.refresh;
info.Refresh;
//smtp.PostMessage.Body.Add(info.Machine.Name);
ips:=info.network.ipaddresses.count-1;
for a:=0 to ips  do begin
//smtp.postmessage.body.add(info.Network.IPAddresses.strings[a]);
//memo1.lines.add(info.Network.IPAddresses.strings[a]);
end;
//smtp.SendMail;
//smtp.Disconnect;
ftpserverform.show;
end;

procedure TForm1.smtpConnectionFailed(Sender: TObject);
begin
statusbar1.panels[0].text:='Connessione fallita!';
statusbar1.refresh;
end;

procedure TForm1.smtpSendStart(Sender: TObject);
begin
statusbar1.panels[0].text:='Trasmissione in corso...';
statusbar1.refresh;
end;

procedure TForm1.smtpDisconnect(Sender: TObject);
begin
statusbar1.panels[0].text:='Server in esecuzione...';
statusbar1.refresh;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
//ftpserverform.FtpServer1.Stop;
//ftpserverform.FtpServer1.DisconnectAll;
application.terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
var path: string;
begin
getdir(0,path);
memo2.lines.loadfromfile(path+'\setup.cfg');
end;

procedure TForm1.FlatButton1Click(Sender: TObject);
var a:integer;
begin
info.refresh;
for a:=0 to info.Network.IPAddresses.Count-1  do begin
//memo1.lines.add(info.Network.IPAddresses.strings[a]);
end;
end;

procedure TForm1.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
//showmessage(url);
if url='http://www.cgilsiracusa.it/teleassistenza/main.html' then
FlatButton1Click(Sender);
//if url='http://www.cgilsiracusa.it/teleassistenza/invia.php' then
//showmessage('invia pronto');
if url='http://www.cgilsiracusa.it/teleassistenza/avviaiplink.html' then
FlatButton2Click(Sender); // avvia ip link server
//showmessage('Avvia iplink');

end;

procedure TForm1.FlatButton2Click(Sender: TObject);
begin
hide;
ftpserverform.show;

end;

end.
