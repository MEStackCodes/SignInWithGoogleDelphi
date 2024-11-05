unit androidapi.JNI.SignInWithGoogle;

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
  androidapi.JNIBridge,
  androidapi.JNI.GraphicsContentViewText,
  androidapi.JNI.JavaTypes;

type

  JDebugHelper = interface;
  JGoogleSignInHandles = interface;
  JGoogleSignInResult = interface;
  JSignInWithGoogleLib = interface;

  JDebugHelperClass = interface(JObjectClass)
    ['{C5AD6E5F-341C-4BE2-A57F-F9256ECDE7F8}']
    function init(string_: JString): JDebugHelper; cdecl;
  end;

  [JavaSignature('com/google/googlesignin/DebugHelper')]
  JDebugHelper = interface(JObject)
    ['{9741AFE0-7E92-403A-A45D-1E3258C682B5}']
    procedure debugDebugTracer(object_: JObject); cdecl;
    function getDebugMsg: JString; cdecl;
    procedure EnabledDebug(boolean: JBoolean); cdecl;
    procedure errorDebugTracer(object_: JObject); cdecl;
    procedure warningDebugTracer(object_: JObject); cdecl;
  end;

  TJDebugHelper = class(TJavaGenericImport<JDebugHelperClass, JDebugHelper>)
  end;

  JGoogleSignInHandlesClass = interface(IJavaClass)
    ['{F91AFE30-622B-430C-ACEB-77A458B4505C}']
  end;

  [JavaSignature('com/google/googlesignin/GoogleSignInHandles')]
  JGoogleSignInHandles = interface(IJavaInstance)
    ['{F855DF1A-6663-4A30-90D0-878428F34EC3}']
    procedure signInException(string_: JString; i: Integer); cdecl;
    procedure signInSuccessfully(googleSignInResult: JGoogleSignInResult); cdecl;
    procedure clearStateCredentialException(string_: JString); cdecl;
    procedure clearStateCredentialSuccessfully; cdecl;
  end;

  TJGoogleSignInHandles = class(TJavaGenericImport<JGoogleSignInHandlesClass, JGoogleSignInHandles>)
  end;

  JGoogleSignInResultClass = interface(JObjectClass)
    ['{698A9E58-CA5A-4A40-9088-FD8E55A26F36}']
    function init: JGoogleSignInResult; cdecl;
  end;

  [JavaSignature('com/google/googlesignin/GoogleSignInResult')]
  JGoogleSignInResult = interface(JObject)
    ['{D020F903-25D0-4893-8332-32978EA33F5F}']
    function getGoogleGivenName: JString; cdecl;
    function getGoogleId: JString; cdecl;
    function getGoogleDisplayName: JString; cdecl;
    function getGoogleFamilyName: JString; cdecl;
    function getGoogleIdToken: JString; cdecl;
    function getGooglePhoneNumber: JString; cdecl;
    function getGoogleProfilePictureUri: JString; cdecl;
  end;

  TJGoogleSignInResult = class(TJavaGenericImport<JGoogleSignInResultClass, JGoogleSignInResult>)
  end;

  JSignInWithGoogleLibClass = interface(JObjectClass)
    ['{0EA4147D-1A13-4877-A68F-1AFFB3EBF404}']
    function init(googleSignInHandles: JGoogleSignInHandles): JSignInWithGoogleLib; cdecl;
  end;

  [JavaSignature('com/google/googlesignin/SignInWithGoogleLib')]
  JSignInWithGoogleLib = interface(JObject)
    ['{B738F3E9-CBDC-4693-B3DE-7368EB062088}']
    procedure buildSignInWithGoogleButton; cdecl;
    procedure enabledDebugging(boolean: JBoolean); cdecl;
    procedure buildSignInGoogleOptions(boolean: JBoolean; boolean1: JBoolean); cdecl;
    procedure clearCredential(context: JContext); cdecl;
    procedure getCredential(context: JContext); cdecl;
    function getNonce: JString; cdecl;
    procedure setGoogleClientID(string_: JString); cdecl;
    procedure setNonce(string_: JString); cdecl;
  end;

  TJSignInWithGoogleLib = class(TJavaGenericImport<JSignInWithGoogleLibClass, JSignInWithGoogleLib>)
  end;

implementation


end.
