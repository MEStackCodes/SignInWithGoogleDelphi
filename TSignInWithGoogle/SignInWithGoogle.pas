unit SignInWithGoogle;

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
  System.Classes, System.Types, System.SysUtils;

type

  TSignInWithGoogleResult = record
    Id: String;
    IdToken: String;
    DisplayName: String;
    FamilyName: String;
    GivenName: String;
    PhoneNumber: String;
    GoogleProfilePictureUri: String;
  end;

  TSignInErrorStatus = (gesNotClientID = -1, gesNotGoogleOptionsBuild = -2, gesGetResultException = -3,
    gesUnknowCredential = -4, gesCredentialException = -5, gesNonceException = -6);

  TCustomSignInWithGoogle = class;

  TOnClearStateCredentialException = procedure(Sender: TObject; Error: Exception) of Object;
  TOnClearStateCredentialSuccessfully = procedure(Sender: TObject) of Object;
  TOnSignInSuccessfully = procedure(Sender: TObject; Result: TSignInWithGoogleResult) of Object;
  TOnSignInException = procedure(Sender: TObject; Error: Exception; Status: TSignInErrorStatus) of Object;

  TBaseSignInWithGoogle = class(TObject)
  protected
    FSignInWithGoogleResult: TSignInWithGoogleResult;
    procedure DoClearStateCredentialException(Sender: TObject; Error: Exception); virtual; abstract;
    procedure DoClearStateCredentialSuccessfully(Sender: TObject); virtual; abstract;
    procedure DoSignInWithGoogleSuccessfully(Sender: TObject; Result: TSignInWithGoogleResult); virtual; abstract;
    procedure DoSignInException(Sender: TObject; Error: Exception; Status: TSignInErrorStatus); virtual; abstract;
  public
    procedure BuildSignInWithGoogleButton; virtual;
    procedure BuildSignInGoogleOptions(setFilterByAuthorizedAccounts: Boolean; setAutoSelectEnabled: Boolean); virtual;
    procedure ClearCredentialState; virtual;
    procedure EnabledDebugging(Flag: Boolean); virtual;
    procedure GetCredential; virtual;
    function GetNonce: String; virtual;
    procedure SetGoogleClientID(ClientID: String); virtual;
    procedure SetNonce(hashNonce: String); virtual;
  end;

  TCustomSignInWithGoogle = class(TComponent)
  private
    FOnSignInException: TOnSignInException;
    FOnSignInSuccessfully: TOnSignInSuccessfully;
    FOnClearStateCredentialException: TOnClearStateCredentialException;
    FOnClearStateCredentialSuccessfully: TOnClearStateCredentialSuccessfully;
    FPlatformInstance: TBaseSignInWithGoogle;
  protected

  public
    procedure BuildSignInGoogleOptions(setFilterByAuthorizedAccounts: Boolean; setAutoSelectEnabled: Boolean); virtual;
    procedure BuildSignInWithGoogleButton; virtual;
    procedure ClearCredentialState; virtual;
    procedure EnabledDebugging(Flag: Boolean); virtual;
    procedure DoClearStateCredentialException(Sender: TObject; Error: Exception); virtual;
    procedure DoClearStateCredentialSuccessfully(Sender: TObject); virtual;
    procedure DoSignInWithGoogleSuccessfully(Sender: TObject; Result: TSignInWithGoogleResult); virtual;
    procedure DoSignInException(Sender: TObject; Error: Exception; Status: TSignInErrorStatus); virtual;
    procedure GetCredential; virtual;
    function GetNonce: String; virtual;
    procedure SetGoogleClientID(ClientID: String); virtual;
    procedure SetNonce(hashNonce: String); virtual;
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    property OnClearStateCredentialException: TOnClearStateCredentialException read FOnClearStateCredentialException
      write FOnClearStateCredentialException;
    property OnClearStateCredentialSuccessfully: TOnClearStateCredentialSuccessfully
      read FOnClearStateCredentialSuccessfully write FOnClearStateCredentialSuccessfully;
    property OnSignInException: TOnSignInException read FOnSignInException write FOnSignInException;
    property OnSignInSuccessfully: TOnSignInSuccessfully read FOnSignInSuccessfully write FOnSignInSuccessfully;

  end;

  TSignInWithGoogle = class(TCustomSignInWithGoogle)
  published
    property OnClearStateCredentialException;
    property OnClearStateCredentialSuccessfully;
    property OnSignInException;
    property OnSignInSuccessfully;
  end;

implementation

uses
{$IFDEF ANDROID}
  SignInWithGoogle.Android,
{$ENDIF}
  System.StrUtils;

// ===========================================================================================
// ===========================================================================================

procedure TCustomSignInWithGoogle.BuildSignInWithGoogleButton;
begin
  FPlatformInstance.BuildSignInWithGoogleButton;
end;

procedure TCustomSignInWithGoogle.BuildSignInGoogleOptions(setFilterByAuthorizedAccounts: Boolean;
  setAutoSelectEnabled: Boolean);
begin
  FPlatformInstance.BuildSignInGoogleOptions(setFilterByAuthorizedAccounts, setAutoSelectEnabled);
end;

procedure TCustomSignInWithGoogle.ClearCredentialState;
begin
  FPlatformInstance.ClearCredentialState;
end;

procedure TCustomSignInWithGoogle.EnabledDebugging(Flag: Boolean);
begin
  FPlatformInstance.EnabledDebugging(Flag);
end;

procedure TCustomSignInWithGoogle.GetCredential;
begin
  FPlatformInstance.GetCredential;
end;

function TCustomSignInWithGoogle.GetNonce: string;
begin
  Result := FPlatformInstance.GetNonce;
end;

procedure TCustomSignInWithGoogle.SetGoogleClientID(ClientID: string);
begin
  FPlatformInstance.SetGoogleClientID(ClientID);
end;

procedure TCustomSignInWithGoogle.SetNonce(hashNonce: string);
begin
  FPlatformInstance.SetNonce(hashNonce);
end;

constructor TCustomSignInWithGoogle.Create(Owner: TComponent);
begin
  inherited;
{$IFDEF ANDROID}
  FPlatformInstance := TPlatformAndroidSignInWithGoogle.Create(Self);
{$ELSE}
  FPlatformInstance := TBaseSignInWithGoogle.Create;
{$ENDIF}
end;

destructor TCustomSignInWithGoogle.Destroy;
begin
{$IFDEF ANDROID}
  TPlatformAndroidSignInWithGoogle(FPlatformInstance).Free;
{$ELSE}
  FPlatformInstance.Free;
{$ENDIF}
  inherited;
end;

// ===========================================================================================
// ===========================================================================================

procedure TCustomSignInWithGoogle.DoSignInException(Sender: TObject; Error: Exception; Status: TSignInErrorStatus);
begin
  if Assigned(FOnSignInException) then
  begin
    FOnSignInException(Self, Error, Status);
  end;
end;

procedure TCustomSignInWithGoogle.DoSignInWithGoogleSuccessfully(Sender: TObject; Result: TSignInWithGoogleResult);
begin
  if Assigned(FOnSignInSuccessfully) then
  begin
    FOnSignInSuccessfully(Self, Result);
  end;
end;

procedure TCustomSignInWithGoogle.DoClearStateCredentialException(Sender: TObject; Error: Exception);
begin
  if Assigned(FOnClearStateCredentialException) then
  begin
    FOnClearStateCredentialException(Self, Error);
  end;
end;

procedure TCustomSignInWithGoogle.DoClearStateCredentialSuccessfully(Sender: TObject);
begin
  if Assigned(FOnClearStateCredentialSuccessfully) then
  begin
    FOnClearStateCredentialSuccessfully(Self);
  end;
end;

// ===========================================================================================
// ===========================================================================================

procedure TBaseSignInWithGoogle.BuildSignInWithGoogleButton;
begin
  // Overriden by Platform
end;

procedure TBaseSignInWithGoogle.BuildSignInGoogleOptions(setFilterByAuthorizedAccounts: Boolean;
  setAutoSelectEnabled: Boolean);
begin
  // Overriden by Platform
end;

procedure TBaseSignInWithGoogle.ClearCredentialState;
begin
  // Overriden by Platform
end;

procedure TBaseSignInWithGoogle.EnabledDebugging(Flag: Boolean);
begin
  // Overriden by Platform
end;

procedure TBaseSignInWithGoogle.GetCredential;
begin
  // Overriden by Platform
end;

function TBaseSignInWithGoogle.GetNonce: string;
begin
  // Overriden by Platform
end;

procedure TBaseSignInWithGoogle.SetGoogleClientID(ClientID: string);
begin
  // Overriden by Platform
end;

procedure TBaseSignInWithGoogle.SetNonce(hashNonce: string);
begin
  // Overriden by Platform
end;

end.
