/** 
  * ===========================================================================
  * Google Sign-In & Android Credentials Manager Java Library
  * Copyright (c) 2024 - MEStackCodes
  * ---------------------------------------------------------------------------
  * Distributed under the MIT software license.
  * ===========================================================================
**/
package com.google.googlesignin;

import android.content.Context;
import android.os.CancellationSignal;

import androidx.annotation.NonNull;
import androidx.credentials.ClearCredentialStateRequest;
import androidx.credentials.Credential;
import androidx.credentials.CredentialManager;
import androidx.credentials.CredentialManagerCallback;
import androidx.credentials.CustomCredential;
import androidx.credentials.GetCredentialRequest;
import androidx.credentials.GetCredentialResponse;
import androidx.credentials.exceptions.ClearCredentialException;
import androidx.credentials.exceptions.GetCredentialException;

import com.google.android.libraries.identity.googleid.GetGoogleIdOption;
import com.google.android.libraries.identity.googleid.GetSignInWithGoogleOption;
import com.google.android.libraries.identity.googleid.GoogleIdTokenCredential;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;


public class SignInWithGoogleLib {

    private static final String TAG = "SignInWithGoogleTracer: ";
    private CredentialManager credentialManager = null;
    private GetCredentialRequest credentialRequest = null;
    private final GoogleSignInHandles responseHandles;
    private final DebugHelper debugHelper;
    private String clientID;
    private String userNonceStr;
    private String nonceStr;

    // Constructor
    public SignInWithGoogleLib(@NonNull GoogleSignInHandles handlesInterface) {
        debugHelper = new DebugHelper(TAG);
        responseHandles = handlesInterface;
    }

    // Developer Log Tracer
    @SuppressWarnings("unused")
    public void enabledDebugging(Boolean flag) {
        debugHelper.EnabledDebug(flag);
    }

    // Set Client ID
    @SuppressWarnings("unused")
    public void setGoogleClientID(@NonNull String googleClientID) {
        clientID = googleClientID;
    }

    // Set Nonce String
    @SuppressWarnings("unused")
    public void setNonce(String nonce) {
        userNonceStr = nonce;
    }

    // Get Nonce String
    @SuppressWarnings("unused")
    public String getNonce() {
        return nonceStr;
    }

    // Build Options for SignInWithGoogle Button
    @SuppressWarnings("unused")
    public void buildSignInWithGoogleButton() {

        if (userNonceStr == null || userNonceStr.isEmpty()) {
            nonceStr = generateNonce();
        } else {
            nonceStr = userNonceStr;
            userNonceStr = null;
        }

        if (clientID == null || clientID.isEmpty()) {
            debugHelper.errorDebugTracer("Not Google Client ID Defined");
            responseHandles.signInException("Not Google Client ID Defined", -1);
            return;
        }

        GetSignInWithGoogleOption googleIdOption = new GetSignInWithGoogleOption.Builder(clientID)
                .setNonce(nonceStr)
                .build();

        credentialRequest = new GetCredentialRequest.Builder()
                .addCredentialOption(googleIdOption)
                .build();

        debugHelper.debugDebugTracer(nonceStr);
        debugHelper.debugDebugTracer(credentialRequest);
    }

    // Build Options for SignInWithGoogle Form
    @SuppressWarnings("unused")
    public void buildSignInGoogleOptions(@NonNull Boolean filterByAuthorizedAccounts, @NonNull Boolean autoSelectEnabled) {

        if (userNonceStr == null || userNonceStr.isEmpty()) {
            nonceStr = generateNonce();
        } else {
            nonceStr = userNonceStr;
            userNonceStr = null;
        }

        if (clientID == null || clientID.isEmpty()) {
            debugHelper.errorDebugTracer("Not Google Client ID Defined");
            responseHandles.signInException("Not Google Client ID Defined", -1);
            return;
        }

        GetGoogleIdOption googleIdOption = new GetGoogleIdOption.Builder()
                .setServerClientId(clientID)
                .setFilterByAuthorizedAccounts(filterByAuthorizedAccounts)
                .setNonce(nonceStr)
                .setAutoSelectEnabled(autoSelectEnabled)
                .build();

        credentialRequest = new GetCredentialRequest.Builder()
                .addCredentialOption(googleIdOption)
                .build();

        debugHelper.debugDebugTracer(nonceStr);
        debugHelper.debugDebugTracer(credentialRequest);
    }


    // Get Credential Launch UI Modal
    @SuppressWarnings("unused")
    public void getCredential(@NonNull Context activity) {

        if (credentialRequest == null) {
            debugHelper.errorDebugTracer("Not Google Options Build");
            responseHandles.signInException("Not Google Options Build", -2);
            return;
        }

        credentialManager = CredentialManager.create(activity);
        credentialManager.getCredentialAsync(activity, credentialRequest, new CancellationSignal(),
                activity.getMainExecutor(),
                new CredentialManagerCallback<GetCredentialResponse, GetCredentialException>() {
                    @Override
                    public void onResult(GetCredentialResponse result) {

                        Credential credential = result.getCredential();
                        if (credential instanceof CustomCredential) {
                            if (GoogleIdTokenCredential.TYPE_GOOGLE_ID_TOKEN_CREDENTIAL.equals(credential.getType())) {
                                try {

                                    GoogleIdTokenCredential googleIdTokenCredential = GoogleIdTokenCredential.createFrom(credential.getData());
                                    GoogleSignInResult googleSignInResult = new GoogleSignInResult();
                                    googleSignInResult.setGoogleId(googleIdTokenCredential.getId());
                                    googleSignInResult.setGoogleIdToken(googleIdTokenCredential.getIdToken());
                                    googleSignInResult.setGoogleDisplayName(googleIdTokenCredential.getDisplayName());
                                    googleSignInResult.setGoogleFamilyName(googleIdTokenCredential.getFamilyName());
                                    googleSignInResult.setGoogleGivenName(googleIdTokenCredential.getGivenName());
                                    googleSignInResult.setGooglePhoneNumber(googleIdTokenCredential.getPhoneNumber());

                                    if (googleIdTokenCredential.getProfilePictureUri() == null) {
                                        googleSignInResult.setGoogleProfilePictureUri(null);
                                    } else {
                                        googleSignInResult.setGoogleProfilePictureUri(String.valueOf(googleIdTokenCredential.getProfilePictureUri()));
                                    }

                                    debugHelper.debugDebugTracer(googleSignInResult);
                                    responseHandles.signInSuccessfully(googleSignInResult);

                                } catch (Exception e) {
                                    debugHelper.errorDebugTracer(e);
                                    responseHandles.signInException(e.getMessage(), -3);
                                }

                            } else {
                                debugHelper.errorDebugTracer("Error Unknown Credential");
                                responseHandles.signInException("Error Unknown Credential", -4);
                            }
                        }
                    }

                    @Override
                    public void onError(@NonNull GetCredentialException e) {
                        debugHelper.errorDebugTracer(e);
                        responseHandles.signInException(e.getMessage(), -5);
                    }
                });
    }

    // ClearCredential Logout
    @SuppressWarnings("unused")
    public void clearCredential(@NonNull Context activity) {
        credentialManager = CredentialManager.create(activity);
        ClearCredentialStateRequest credentialStateRequest = new ClearCredentialStateRequest();
        credentialManager.clearCredentialStateAsync(credentialStateRequest, new CancellationSignal(), activity.getMainExecutor(), new CredentialManagerCallback<Void, ClearCredentialException>() {
            @Override
            public void onResult(Void unused) {
                debugHelper.debugDebugTracer("clearStateCredentialSuccessfully");
                responseHandles.clearStateCredentialSuccessfully();
            }

            @Override
            public void onError(@NonNull ClearCredentialException e) {
                debugHelper.errorDebugTracer(e);
                responseHandles.clearStateCredentialException(e.getMessage());
            }
        });
    }

    private String generateNonce() {
        try {
            String rawNonce = UUID.randomUUID().toString();
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(rawNonce.getBytes());
            StringBuilder hashNonce = new StringBuilder();
            for (byte b : digest) {
                hashNonce.append(String.format("%02x", b));
            }
            return hashNonce.toString();
        } catch (NoSuchAlgorithmException e) {
            debugHelper.errorDebugTracer(e);
            responseHandles.signInException(e.getMessage(), -6);
            return null;
        }
    }

}