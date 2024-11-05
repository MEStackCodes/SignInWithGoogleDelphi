/** 
  * ===========================================================================
  * Google Sign-In & Android Credentials Manager Java Library
  * Copyright (c) 2024 - MEStackCodes
  * ---------------------------------------------------------------------------
  * Distributed under the MIT software license.
  * ===========================================================================
**/

package com.google.googlesignin;


public interface GoogleSignInHandles{
    void signInSuccessfully(GoogleSignInResult googleSignInResult);
    void signInException(String errorMessage, int errorCode);
    void clearStateCredentialException(String errorMessage);
    void clearStateCredentialSuccessfully();
}

