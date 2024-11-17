// package com.project_255.app

// import io.flutter.embedding.android.FlutterActivity

// class MainActivity: FlutterActivity()


package com.project_255.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Create a default notification channel for Android 8.0 (API level 26) and above
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "default_channel", // Channel ID
                "Default", // Channel name
                NotificationManager.IMPORTANCE_DEFAULT // Channel importance
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel) // Register the channel
        }
    }
}
