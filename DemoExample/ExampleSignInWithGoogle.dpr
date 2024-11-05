program ExampleSignInWithGoogle;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  TestSignInWithGoogle in 'TestSignInWithGoogle.pas' {FTestGoogleSignIn};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TFTestGoogleSignIn, FTestGoogleSignIn);
  Application.Run;
end.
