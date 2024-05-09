package com.marigold.nativestream;

import android.app.Application;

import com.marigold.sdk.Marigold;
import com.marigold.sdk.NotificationConfig;

public class NativeStreamApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        NotificationConfig config = new NotificationConfig();
        config.setSmallIcon(R.drawable.ic_stat_default);
        Marigold marigold = new Marigold();
        marigold.startEngine(this, "SDK KEY");
        marigold.setNotificationConfig(config);
    }
}
