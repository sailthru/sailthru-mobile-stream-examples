package com.marigold.nativestream

import android.app.Application
import com.marigold.sdk.Marigold
import com.marigold.sdk.NotificationConfig

class NativeStreamApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        val config = NotificationConfig()
        config.setSmallIcon(R.drawable.ic_stat_default)
        val marigold = Marigold()
        marigold.startEngine(this, "SDK KEY")
        marigold.setNotificationConfig(config)
    }
}
