import 'package:android_intent_plus/android_intent.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../mode/Task.dart';

class AlarmManagerService {
  // 1. 请求权限
  static Future<bool> requestAlarmPermissions() async {
    if (Platform.isAndroid) {
      // 请求通知权限（Android 13+）
      await Permission.notification.request();
      // 检查闹钟权限状态
      var status = await Permission.scheduleExactAlarm.status;
      if (status.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }
    return true; // 闹钟 Intent 通常不需要动态申请运行时权限，但建议引导用户
  }

  // 2. 设置每日重复闹钟
  static Future<void> setDailyAlarm(Task task) async {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(task.time);

    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.SET_ALARM',
      arguments: <String, dynamic>{
        'android.intent.extra.alarm.HOUR': dateTime.hour,
        'android.intent.extra.alarm.MINUTES': dateTime.minute,
        'android.intent.extra.alarm.MESSAGE': "${task.title}: ${task.detail}",
        'android.intent.extra.alarm.SKIP_UI': true, // 自动设置，不弹出闹钟修改界面
        'android.intent.extra.alarm.REPEATING': true, // 开启重复
        // 设置周一到周日重复 (1=周日, 2=周一... 7=周六)
        'android.intent.extra.alarm.DAYS': [1, 2, 3, 4, 5, 6, 7],
      },
    );

    await intent.launch();
  }
}