package com.example.task_synced

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "task_reminder_channel"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setReminder" -> {
                    val taskId = call.argument<Int>("taskId")!!
                    val title = call.argument<String>("title")!!
                    val description = call.argument<String>("description")!!
                    val dueDateMillis = call.argument<Long>("dueDate")!!

                    setReminder(taskId, title, description, dueDateMillis)
                    result.success(null)
                }
                "cancelReminder" -> {
                    val taskId = call.argument<Int>("taskId")!!
                    cancelReminder(taskId)
                    result.success(null)
                }
                
            
                else -> result.notImplemented()
            }

        }
    }

    private fun setReminder(taskId: Int, title: String, description: String, dueDateMillis: Long) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, ReminderReceiver::class.java).apply{
            putExtra("taskId", taskId)
            putExtra("title", title)
            putExtra("description", description)
        }

        val pendingIntent = PendingIntent.getBroadcast(
            this,
            taskId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, dueDateMillis, pendingIntent)
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, dueDateMillis, pendingIntent)
        }
            Log.d("Reminder", "Reminder set for task: $taskId at $dueDateMillis")
        }

    private fun cancelReminder(taskId: Int) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, ReminderReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            taskId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        alarmManager.cancel(pendingIntent)
        Log.d("Reminder", "Reminder canceled for task: $taskId")
    }
}
