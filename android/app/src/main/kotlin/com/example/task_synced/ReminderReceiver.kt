package com.example.task_synced

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.app.PendingIntent
import android.app.NotificationChannel
import android.app.NotificationManager
import androidx.core.app.NotificationCompat
import android.util.Log


class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {

        val taskId = intent.getIntExtra("taskId", 0)
        val title = intent.getStringExtra("title") ?: "Task Reminder"

        val description = intent.getStringExtra("description") ?: "You have a task due!"

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

     
        val channel = NotificationChannel(
                "task_channel_id",
                "Task Reminder",
                NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(channel)

        val notification = NotificationCompat.Builder(context, "task_channel_id")
            .setContentTitle(title)
            .setContentText(description)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .build()        

        notificationManager.notify(taskId, notification)
    }
}
