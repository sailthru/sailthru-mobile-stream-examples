package com.carnivalmobile.nativestream;

import android.app.Application;

import com.carnival.sdk.Carnival;


public class NativeStreamApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        Carnival.setNotificationIcon(R.drawable.ic_stat_default);
        Carnival.startEngine(this, "", "4c60e83bc3223dfe5ed47f42581d318fc5dc2898");
    }
}
