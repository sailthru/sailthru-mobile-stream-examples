package com.carnivalmobile.nativestream;

import android.app.Application;

import com.carnival.sdk.Carnival;
import com.carnival.sdk.NotificationConfig;


public class NativeStreamApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        NotificationConfig config = new NotificationConfig();
        config.setSmallIcon(R.drawable.ic_stat_default);
        Carnival.setNotificationConfig(config);
        Carnival.startEngine(this, "f0f9e7185392a99a09403d9dc000ed35b1758794");
    }
}
