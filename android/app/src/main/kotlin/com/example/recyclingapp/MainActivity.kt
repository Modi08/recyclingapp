package com.app.ecofy

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.graphics.Color
import androidx.core.app.NotificationCompat
import com.app.ecofy.R
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = "ecofy/notification"

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            println("platform service called ${call.method}")
            when (call.method) {
                "sendNotification" -> {
                    println("platform service successful")
                    val title: String? = call.argument<String>("title");
                    val body: String? = call.argument<String>("body");

                    if (title != null && body != null) {
                        makeNotification(title, body)
                    } else {
                        result.error("INVALID_ARGUMENT", "Invalid arguments", null)
                    }
                }
            }
        }
    }

    private fun makeNotification(title: String, body: String) {
        val channelId: String = "ecofy_Notifications";
        val builder: NotificationCompat.Builder =
            NotificationCompat.Builder(applicationContext, channelId);
        builder.setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        val intent = Intent(
            applicationContext,
            MainActivity::class.java);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

        intent.putExtra("pageId", "ownProfile")
        val pendingIntent = PendingIntent.getActivity(applicationContext, 0, intent, PendingIntent.FLAG_IMMUTABLE)

        builder.setContentIntent(pendingIntent);
        val notificationManager: NotificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            var notificationChannel = notificationManager.getNotificationChannel(channelId)
            if (notificationChannel == null) {
                val importance: Int = NotificationManager.IMPORTANCE_HIGH;
                notificationChannel = NotificationChannel(channelId, "Ecofy", importance);
                notificationChannel.lightColor = Color.GREEN;
                notificationChannel.enableVibration(true);

                notificationManager.createNotificationChannel(notificationChannel);
            }

        }

        notificationManager.notify(0, builder.build())
    }
}