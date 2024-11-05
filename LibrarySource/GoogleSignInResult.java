/** 
  * ===========================================================================
  * Google Sign-In & Android Credentials Manager Java Library
  * Copyright (c) 2024 - MEStackCodes
  * ---------------------------------------------------------------------------
  * Distributed under the MIT software license.
  * ===========================================================================
**/

package com.google.googlesignin;

public class GoogleSignInResult {
    private String id; // User Email Address
    private String idToken; // Google ID Token
    private String displayName; // Public Name
    private String familyName; // Last Name
    private String givenName;  // First Name
    private String profilePictureUri; // Profile Photo
    private String phoneNumber; // Phone Number

    @SuppressWarnings("unused")
    public String getGoogleId() {
        return id;
    }

    @SuppressWarnings("unused")
    public String getGoogleIdToken() {
        return idToken;
    }

    @SuppressWarnings("unused")
    public String getGoogleDisplayName() {
        return displayName;
    }

    @SuppressWarnings("unused")
    public String getGoogleFamilyName() {
        return familyName;
    }

    @SuppressWarnings("unused")
    public String getGoogleGivenName() {
        return givenName;
    }

    @SuppressWarnings("unused")
    public String getGoogleProfilePictureUri() {
        return profilePictureUri;
    }

    @SuppressWarnings("unused")
    public String getGooglePhoneNumber() {
        return phoneNumber;
    }

    @SuppressWarnings("unused")
    protected void setGoogleId(String value) {
        id = value;
    }

    protected void setGoogleIdToken(String value) {
        idToken = value;
    }

    protected void setGoogleDisplayName(String value) {
        displayName = value;
    }

    protected void setGoogleFamilyName(String value) {
        familyName = value;
    }

    protected void setGoogleGivenName(String value) {
        givenName = value;
    }

    protected void setGoogleProfilePictureUri(String value) {
        profilePictureUri = value;
    }

    protected void setGooglePhoneNumber(String value) {
        phoneNumber = value;
    }

}
