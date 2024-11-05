unit TestSignInWithGoogle;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, SignInWithGoogle, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Memo.Types, FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Layouts;

type
  TFTestGoogleSignIn = class(TForm)
    bSignIn: TButton;
    mLog: TMemo;
    Text1: TText;
    Layout1: TLayout;
    Layout2: TLayout;
    SGBottomSheet: TRadioButton;
    SGModal: TRadioButton;
    Text2: TText;
    Rectangle1: TRectangle;
    Layout3: TLayout;
    Rectangle2: TRectangle;
    Text3: TText;
    SGSetFilterAuthorizedAccounts: TCheckBox;
    SGSetAutoSelectEnabled: TCheckBox;
    Layout4: TLayout;
    bClear: TButton;
    procedure FormShow(Sender: TObject);
    procedure bSignInClick(Sender: TObject);
    procedure bClearClick(Sender: TObject);
  private

  public
    procedure OnSignInException(Sender: TObject; Error: Exception; Status: TSignInErrorStatus);
    procedure OnSignInSuccessfully(Sender: TObject; Result: TSignInWithGoogleResult);
    procedure OnClearStateCredentialSuccessfully(Sender: TObject);
    procedure OnClearStateCredentialException(Sender: TObject; Error: Exception);
  end;

var
  FTestGoogleSignIn: TFTestGoogleSignIn;

implementation

var
  SignInWithGoogle: TSignInWithGoogle;
{$R *.fmx}


procedure TFTestGoogleSignIn.FormShow(Sender: TObject);
begin
  //
end;

procedure TFTestGoogleSignIn.bClearClick(Sender: TObject);
begin
  if (not Assigned(SignInWithGoogle)) then
  begin
    SignInWithGoogle := TSignInWithGoogle.Create(Self);
    SignInWithGoogle.SetGoogleClientID('YourClientID');
  end;

  with SignInWithGoogle do
  begin
    OnClearStateCredentialSuccessfully := Self.OnClearStateCredentialSuccessfully;
    OnClearStateCredentialException := Self.OnClearStateCredentialException;
    ClearCredentialState;
  end;

end;

procedure TFTestGoogleSignIn.bSignInClick(Sender: TObject);
begin
  if (not Assigned(SignInWithGoogle)) then
  begin
    SignInWithGoogle := TSignInWithGoogle.Create(Self);
    SignInWithGoogle.SetGoogleClientID('YourClientID');
  end;

  with SignInWithGoogle do
  begin

    SignInWithGoogle.OnSignInException := Self.OnSignInException;
    SignInWithGoogle.OnSignInSuccessfully := Self.OnSignInSuccessfully;

    if (SGModal.IsChecked) then
    begin
      BuildSignInWithGoogleButton;
    end
    else
    begin
      BuildSignInGoogleOptions(SGSetFilterAuthorizedAccounts.IsChecked, SGSetAutoSelectEnabled.IsChecked);
    end;

    GetCredential;
  end;
end;

procedure TFTestGoogleSignIn.OnSignInException(Sender: TObject; Error: Exception; Status: TSignInErrorStatus);
begin
  mLog.Lines.Add('Sign In Exception');
  mLog.Lines.Add('====================');
  mLog.Lines.Add('Message: ' + Error.Message);
  mLog.Lines.Add('Exception Status Number: ' + IntToStr(Ord(Status)));

  // Custom Exceptions Types
  case Status of
    gesNotClientID:
      mLog.Lines.Add('Exception Status: No Client Id Assigned');
    gesNotGoogleOptionsBuild:
      mLog.Lines.Add('Exception Status: No Build Google Options');
    gesGetResultException:
      mLog.Lines.Add('Exception Status: Unable Get SignIn Result');
    gesUnknowCredential:
      mLog.Lines.Add('Exception Status: Unknown credential type');
    gesCredentialException:
      mLog.Lines.Add('Exception Status: Exception on selected credential');
    gesNonceException:
      mLog.Lines.Add('Exception Status: Exception when generating the Nonce');
  end;

end;

procedure TFTestGoogleSignIn.OnSignInSuccessfully(Sender: TObject; Result: TSignInWithGoogleResult);
begin
  mLog.Lines.Add('Sign In Successfully');
  mLog.Lines.Add('====================');
  mLog.Lines.Add('Token:' + Result.IdToken);
  mLog.Lines.Add('Email:' + Result.Id);
  mLog.Lines.Add('Public Name:' + Result.DisplayName);
  mLog.Lines.Add('First Name:' + Result.GivenName);
  mLog.Lines.Add('Last Name:' + Result.FamilyName);
  mLog.Lines.Add('Phone:' + Result.PhoneNumber);
  mLog.Lines.Add('ProfileImg:' + Result.GoogleProfilePictureUri);
end;

procedure TFTestGoogleSignIn.OnClearStateCredentialSuccessfully(Sender: TObject);
begin
  mLog.Lines.Add('Clear State Successfully');
  mLog.Lines.Add('====================');
end;

procedure TFTestGoogleSignIn.OnClearStateCredentialException(Sender: TObject; Error: Exception);
begin
  mLog.Lines.Add('Clear State Exception');
  mLog.Lines.Add('====================');
  mLog.Lines.Add('Failed: ' + Error.Message);
end;

end.
