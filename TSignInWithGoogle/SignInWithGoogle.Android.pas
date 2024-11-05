unit SignInWithGoogle.Android;

{
  * ===========================================================================
  * Google Sign-In & Android Credentials Manager Component : TSignInWithGoogle
  * Copyright (c) 2024 - MEStackCodes
  * ---------------------------------------------------------------------------
  * Distributed under the MIT software license.
  * ===========================================================================
}

interface

uses

  androidapi.Jni.SignInWithGoogle,
  androidapi.Jni.App,
  androidapi.Jni.JavaTypes,
  androidapi.Jni.GraphicsContentViewText,
  androidapi.JNIBridge,
  androidapi.Helpers,
  System.Classes,
  SignInWithGoogle,
  System.SysUtils;

type

  TPlatformAndroidSignInWithGoogle = class;

  TGoogleSignInHandles = class(TJavaLocal, JGoogleSignInHandles)
  private
    FPlatformInstance: TPlatformAndroidSignInWithGoogle;
  public
    procedure clearStateCredentialException(string_: JString); cdecl;
    procedure clearStateCredentialSuccessfully; cdecl;
    procedure signInException(string_: JString; i: Integer); cdecl;
    procedure signInSuccessfully(googleSignInResult: JGoogleSignInResult); cdecl;
  end;

  TPlatformAndroidSignInWithGoogle = class(TBaseSignInWithGoogle)
  private
    FGoogleSignInHandles: TGoogleSignInHandles; // JGoogleSignInHandles as TGoogleSignInHandles
    FGoogleSignInLibrary: JSignInWithGoogleLib; // Java Library Instance
    FOwnerInstance: TCustomSignInWithGoogle; // TCustomClase Instance
    procedure InititializePlatform;
  protected
    procedure DoClearStateCredentialException(Sender: TObject; Error: Exception); override;
    procedure DoClearStateCredentialSuccessfully(Sender: TObject); override;
    procedure DoSignInWithGoogleSuccessfully(Sender: TObject; Result: TSignInWithGoogleResult); override;
    procedure DoSignInException(Sender: TObject; Error: Exception; Status: TSignInErrorStatus); override;
  public
    procedure BuildSignInWithGoogleButton; override;
    procedure BuildSignInGoogleOptions(setFilterByAuthorizedAccounts: Boolean; setAutoSelectEnabled: Boolean); override;
    procedure ClearCredentialState; override;
    procedure EnabledDebugging(Flag: Boolean); override;
    function GetNonce: String; override;
    procedure GetCredential; override;
    procedure SetGoogleClientID(ClientID: String); override;
    procedure SetNonce(hashNonce: String); override;
    constructor Create(ComponentInstance: TCustomSignInWithGoogle);
    destructor Destroy; override;
  end;

implementation

// ===========================================================================================
// Platform Constructor
// ===========================================================================================

procedure TPlatformAndroidSignInWithGoogle.BuildSignInWithGoogleButton;
begin
  FGoogleSignInLibrary.BuildSignInWithGoogleButton;
end;

procedure TPlatformAndroidSignInWithGoogle.BuildSignInGoogleOptions(setFilterByAuthorizedAccounts: Boolean;
  setAutoSelectEnabled: Boolean);
begin
  FGoogleSignInLibrary.BuildSignInGoogleOptions(TJBoolean.JavaClass.init(setFilterByAuthorizedAccounts),
    TJBoolean.JavaClass.init(setAutoSelectEnabled));
end;

procedure TPlatformAndroidSignInWithGoogle.DoSignInException(Sender: TObject; Error: Exception;
  Status: TSignInErrorStatus);
begin
  FOwnerInstance.DoSignInException(Self, Error, Status);
end;

procedure TPlatformAndroidSignInWithGoogle.DoSignInWithGoogleSuccessfully(Sender: TObject;
  Result: TSignInWithGoogleResult);
begin
  FOwnerInstance.DoSignInWithGoogleSuccessfully(Self, Result);
end;

procedure TPlatformAndroidSignInWithGoogle.DoClearStateCredentialException(Sender: TObject; Error: Exception);
begin
  FOwnerInstance.DoClearStateCredentialException(Self, Error);
end;

procedure TPlatformAndroidSignInWithGoogle.DoClearStateCredentialSuccessfully(Sender: TObject);
begin
  FOwnerInstance.DoClearStateCredentialSuccessfully(Self);
end;

procedure TPlatformAndroidSignInWithGoogle.ClearCredentialState;
begin
  FGoogleSignInLibrary.clearCredential(TAndroidHelper.Activity);
end;

procedure TPlatformAndroidSignInWithGoogle.EnabledDebugging(Flag: Boolean);
begin
  FGoogleSignInLibrary.EnabledDebugging(TJBoolean.JavaClass.init(Flag));
end;

procedure TPlatformAndroidSignInWithGoogle.GetCredential;
begin
  FGoogleSignInLibrary.GetCredential(TAndroidHelper.Activity);
end;

function TPlatformAndroidSignInWithGoogle.GetNonce: string;
begin
  Result := JStringToString(FGoogleSignInLibrary.GetNonce);
end;

procedure TPlatformAndroidSignInWithGoogle.InititializePlatform;
begin
  FGoogleSignInLibrary := TJSignInWithGoogleLib.JavaClass.init(FGoogleSignInHandles);
end;

procedure TPlatformAndroidSignInWithGoogle.SetGoogleClientID(ClientID: string);
begin
  FGoogleSignInLibrary.SetGoogleClientID(StringToJString(ClientID));
end;

procedure TPlatformAndroidSignInWithGoogle.SetNonce(hashNonce: string);
begin
  FGoogleSignInLibrary.SetNonce(StringToJString(hashNonce));
end;

constructor TPlatformAndroidSignInWithGoogle.Create(ComponentInstance: TCustomSignInWithGoogle);
begin
  inherited Create;
  FOwnerInstance := ComponentInstance;
  FGoogleSignInHandles := TGoogleSignInHandles.Create;
  FGoogleSignInHandles.FPlatformInstance := Self;
  InititializePlatform;
end;

destructor TPlatformAndroidSignInWithGoogle.Destroy;
begin
  FGoogleSignInHandles.Free;
  inherited;
end;

// ===========================================================================================
// Handles Event Constructor
// ===========================================================================================

procedure TGoogleSignInHandles.clearStateCredentialException(string_: JString);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(300);
      TThread.Synchronize(nil,
        procedure
        begin
          FPlatformInstance.DoClearStateCredentialException(Self, Exception.Create(JStringToString(string_)));
        end);
    end).Start;
end;

procedure TGoogleSignInHandles.clearStateCredentialSuccessfully;
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(300);
      TThread.Synchronize(nil,
        procedure
        begin
          FPlatformInstance.DoClearStateCredentialSuccessfully(Self);
        end);

    end).Start;
end;

procedure TGoogleSignInHandles.signInException(string_: JString; i: Integer);
begin

  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(300);
      TThread.Synchronize(nil,
        procedure
        begin
          FPlatformInstance.DoSignInException(Self, Exception.Create(JStringToString(string_)), TSignInErrorStatus(i));
        end);

    end).Start;

end;

procedure TGoogleSignInHandles.signInSuccessfully(googleSignInResult: JGoogleSignInResult);
begin

  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(300);
      TThread.Synchronize(nil,
        procedure
        begin
          FPlatformInstance.FSignInWithGoogleResult.Id := JStringToString(googleSignInResult.getGoogleId);
          FPlatformInstance.FSignInWithGoogleResult.IdToken := JStringToString(googleSignInResult.getGoogleIdToken);
          FPlatformInstance.FSignInWithGoogleResult.DisplayName :=
            JStringToString(googleSignInResult.getGoogleDisplayName);
          FPlatformInstance.FSignInWithGoogleResult.FamilyName :=
            JStringToString(googleSignInResult.getGoogleFamilyName);
          FPlatformInstance.FSignInWithGoogleResult.GivenName := JStringToString(googleSignInResult.getGoogleGivenName);
          FPlatformInstance.FSignInWithGoogleResult.PhoneNumber :=
            JStringToString(googleSignInResult.getGooglePhoneNumber);
          FPlatformInstance.FSignInWithGoogleResult.GoogleProfilePictureUri :=
            JStringToString(googleSignInResult.getGoogleProfilePictureUri);
          FPlatformInstance.DoSignInWithGoogleSuccessfully(Self, FPlatformInstance.FSignInWithGoogleResult);
        end);
    end).Start;

end;

end.
