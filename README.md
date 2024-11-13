![Platform](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)
![Delphi](https://img.shields.io/badge/Delphi%2012.x-CC342D?style=flat-square&logo=delphi&logoColor=white)
[![GitHub Tag](https://img.shields.io/github/v/tag/MEStackCodes/SignInWithGoogleDelphi?style=flat-square&labelColor=black&color=2900c0)](https://github.com/MEStackCodes/SignInWithGoogleDelphi/tags)
# Google Sign-In with Credential Manager for Delphi/FMX/Android

**TSignInWithGoogle** is a straightforward library/component that enables Google Sign-in using Android's Credential Manager in a Object Pascal/Delphi environment. It can be used freely in any project.

 
## Requirements

- `Delphi Athens +12x`
- `Binary (JAR/AAR) Dependencies`
- `Android SDK 33/34`
- `Set up your Google Identity APIs console project` - [API Console](https://console.cloud.google.com/apis) 

## Installing

- Add the **TSignInWithGoogle** folder path to your project in the menu: `Project-> Options-> Delphi Compiler-> Search Path`.
- Add all *.jar files located inside the **JAR-dependencies** folder to your project. From the right side panel: `Target Platforms -> Android -> Libraries`. Right click and select Add..


## Usage - Code Examples

1. Add the `SignInWithGoogle` unit to your project's uses clause:

    ```pascal
    uses
      SignInWithGoogle;
    ```

2. Create an instance of `TSignInWithGoogle` and assign the events:

    ```pascal
    var
    SignInWithGoogle: TSignInWithGoogle;

    SignInWithGoogle := TSignInWithGoogle.Create(Self);
      with SignInWithGoogle do
       begin
        SetGoogleClientID('YourClientID');  // <--- your client id here  
        OnClearStateCredentialSuccessfully:= Self.OnClearStateCredentialSuccessfully;
        OnClearStateCredentialException := Self.OnClearStateCredentialException;      
        OnSignInException := Self.OnSignInException;
        OnSignInSuccessfully := Self.OnSignInSuccessfully;    
       end;
    ```

3. Get Credential (Classic Modal UI) for SignInWithGoogle Button

    ```pascal
    with SignInWithGoogle do
    begin        
      BuildSignInWithGoogleButton;
      GetCredential;
    end;
    ```

 4. Or Get Credential (Credential Manager's bottom sheet UI)

    ```pascal
    with SignInWithGoogle do
    begin        
      BuildSignInGoogleOptions(False, False)
      GetCredential;
    end;
    ```  

 5. Clear Credential State

    ```pascal
    with SignInWithGoogle do
    begin              
     ClearCredentialState; 
    end;
    ```  


## Methods
- `SetGoogleClientID(ClientID: String)`: (Required): Sets the Google Client ID obtained from the credentials manager in the Google Console. You can download it as a JSON file in the configuration. Make sure it's the identifier type 3 (Web) and not type 1 (Android).  More details can be found <a href="https://developer.android.com/identity/sign-in/credential-manager-siwg#sign-in" target="_blank">here</a> 

- `SetNonce(hashNonce: String)`:  Assigns the provided string as a Nonce identifier. If not called, an automatic Nonce hash will be created.

- `GetNonce: String`: Retrieves the automatically generated Nonce hash. If the nonce was provided by the user, it returns the same string.

- `BuildSignInWithGoogleButton`:  Generates options for calling the SignInWithGoogle button (modal UI).

- `BuildSignInGoogleOptions(setFilterByAuthorizedAccounts: Boolean; setAutoSelectEnabled: Boolean)`: Generates options for the bottom DataSheet. Parameters:
    - `setFilterByAuthorizedAccounts`:  Displays authorized Google accounts if set to `True`.
    - `setAutoSelectEnabled`: Enables automatic login.
    More details can be found <a href="https://developer.android.com/identity/sign-in/credential-manager-siwg#sign-in" target="_blank">here</a>

- `GetCredential`:  Calls the credentials window (asynchronous).

- `ClearCredentialState`: Clears the stored credential state (asynchronous).

- `EnabledDebugging(Flag: Boolean)`: (for debugging purposes): Activates debug messages visible in LogCat or other log viewers.


## Events

- `OnSignInSuccessfully`: Triggered when the user successfully signs in.
- `OnSignInException`: Handles exceptions during the sign-in process.
- `OnClearStateCredentialSuccessfully`: Fired when the credential state is cleared successfully.
- `OnClearStateCredentialException`: Handles exceptions when clearing the credential state.
 ##
- `OnSignInSuccessfully = procedure (Sender: TObject; Result: TSignInResult)`: Receives a record with user login information.
- `OnSignInException = procedure (Sender: TObject; Error: Exception; Status: TSignInErrorStatus)`: Receives an `Exception` object and a status.
- `OnClearStateCredentialSuccesfully = procedure (Sender: TObject;)`: it does not receive parameters.
- `OnClearStateCredentialException = procedure (Sender: TObject; Error: Exception)`: Receives an `Exception` object.


## AndroidManifest.template.xml

Make sure this line identifying the Google Play service is present in your manifest. Delphi only adds this line if you have notifications, maps, or any other component that uses Google services turned on.
```xml
<meta-data android:name="com.google.android.gms.version" android:value="12451000" />
 ```

Just below the `<%uses-libraries%>` tag add this block to activate the Credential Provider Meta Service:
```xml
<%uses-libraries%>
 <service android:name="androidx.credentials.playservices.CredentialProviderMetadataHolder">
 <meta-data
  android:name="androidx.credentials.CREDENTIAL_PROVIDER_KEY"
  android:value="androidx.credentials.playservices.CredentialProviderPlayServicesImpl" />
</service>
```

Also below the above block another block should be added to start the Google UI activity.
```xml
 <activity
  android:name="androidx.credentials.playservices.HiddenActivity"
  android:configChanges="orientation|keyboard|keyboardHidden|screenSize|screenLayout"
  android:enabled="true"
  android:exported="false"
  android:resizeableActivity="true"            
  android:theme="@style/SignInUITheme"
  android:fitsSystemWindows="true">            
  </activity>
```

The following blocks can be bypassed by placing `android:theme="@style/SignInUITheme"` --> `android:theme="@null"` but you may experience visual issues and window scrolling when launching the Google UI in your app on FMX. 

From `Project-> Deployment` you can manage the location of these files for Debug and Release.

Add the following to your project's `styles-v31.xml` file:
```xml
<resources xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Default Delphi Resource -->
    <style name="AppTheme" parent="@android:style/Theme.Material.Light.NoActionBar">
        <item name="android:windowBackground">@color/splash_background</item>
        <item name="android:windowClipToOutline">false</item>       
        <!-- API 31+ specific attributes -->
        <item name="android:windowSplashScreenBackground">@color/splash_background</item>
        <item name="android:windowSplashScreenAnimatedIcon">@drawable/splash_vector</item>
        <item name="android:windowSplashScreenIconBackgroundColor">@color/splash_background</item>
    </style>

<!-- You just have to copy this part -->
<style name="SignInUITheme" parent="@android:style/Theme.Material.Light.NoActionBar">
    <item name="android:windowIsTranslucent">true</item>
    <item name="android:windowBackground">@android:color/transparent</item>
    <item name="android:windowContentOverlay">@null</item>
    <item name="android:windowNoTitle">true</item>
    <item name="android:windowIsFloating">false</item>
    <item name="android:backgroundDimEnabled">true</item>
    <item name="android:windowTranslucentStatus">true</item>
    <item name="android:windowTranslucentNavigation">true</item>
</style>
<!-- You just have to copy this part -->

</resources>
```

Now add the following to your project's `styles-v21.xml` file:
```xml
<resources xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Default Delphi Resource -->
    <style name="AppTheme" parent="@android:style/Theme.Material.Light.NoActionBar">
        <item name="android:windowBackground">@drawable/splash_image_def</item>
        <item name="android:windowClipToOutline">false</item>
    </style>
   
   <!-- You just have to copy this part -->
   <style name="SignInUITheme" parent="@android:style/Theme.Material.Light.NoActionBar">
    <item name="android:windowIsTranslucent">true</item>
    <item name="android:windowBackground">@android:color/transparent</item>
    <item name="android:windowContentOverlay">@null</item>
    <item name="android:windowNoTitle">true</item>
    <item name="android:windowIsFloating">false</item>
    <item name="android:backgroundDimEnabled">true</item>
    <item name="android:windowTranslucentStatus">true</item>
    <item name="android:windowTranslucentNavigation">true</item>
 </style>
 <!-- You just have to copy this part -->
</resources>
```

## Known Issues
 - The `OnSignInException` event always fires, with the message: *"the activity was canceled by the user"*, this is an issue related to setting up credentials in the Google console. Verify that the client ID is type 3 and that your application's SHA-1 signing is configured correctly in your account. Additionally, OAuth consent screen page must be configured correctly for use.

- The `OnSignInException` event fires with the message: *"failed to launch the selector UI, Hint: ensure the 'context' parameter is an activity-based context"*. This error appears if a valid activity is not defined to start the credentials window. Make sure you add the hidden activity block for Google UI in your manifest file as described above. 

- The `OnSignInException` event fires with the message: *"GetCredentialAsync no provider dependencies found - please ensure the desired provider dependencies are added.*" Make sure you add the service provider credentials in your manifest file and also the dependencies of the jar/aar files in your project.

## Share
If you liked and found this repository useful for your projects, star it. Thank you for your support! ⭐
