/** 
  * ===========================================================================
  * Google Sign-In & Android Credentials Manager Java Library
  * Copyright (c) 2024 - MEStackCodes
  * ---------------------------------------------------------------------------
  * Distributed under the MIT software license.
  * ===========================================================================
**/

package com.google.googlesignin;

import android.util.Log;


public class DebugHelper {

    private String DebugMsg;
    private final String tagLog;
    private Boolean EnabledDebug = false;

    public DebugHelper(String Tag){
     tagLog = Tag;
    }

    @SuppressWarnings("unused")
    public String getDebugMsg(){
      return DebugMsg;
    }

    @SuppressWarnings("unused")
    public void EnabledDebug(Boolean value){
     EnabledDebug = value;
    }

    @SuppressWarnings("unused")
    public void warningDebugTracer(Object warningMsg){
        if(EnabledDebug){
            DebugMsg = String.valueOf(warningMsg);
            Log.w(tagLog, DebugMsg);
        }
    }

    @SuppressWarnings("unused")
    public void errorDebugTracer(Object errorMsg){
        if(EnabledDebug){
            DebugMsg = String.valueOf(errorMsg);
            Log.e(tagLog, DebugMsg);
        }
    }

    @SuppressWarnings("unused")
    public void debugDebugTracer(Object debugMsg){
        if(EnabledDebug){
            DebugMsg = String.valueOf(debugMsg);
            Log.d(tagLog, DebugMsg);
        }
    }

}
