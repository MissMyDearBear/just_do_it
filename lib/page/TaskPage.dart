import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts/Const.dart';
import '../mode/Task.dart';
import '../task/AlarmManagerService.dart';
import 'LoginPage.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
  }

  // 模拟一些任务数据
  final List<String> _tasks = ["买牛奶", "写代码", "去健身", "看书"];

  // 异步获取登录状态
  Future<bool> _getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // 如果没有值，默认为 false
    return prefs.getBool(SP_KEY_IS_LOGIN) ?? false;
  }

  // 定义加载本地 JSON 的异步方法
  Future<List<Task>> _loadTasksFromAsset() async {
    // 1. 读取字符串
    final String jsonString = await rootBundle.loadString('assets/mock/TaskList.json');
    // 2. 解析为 List
    final List<dynamic> data = json.decode(jsonString);
    // 3. 映射为 Task 对象列表
    final tasks = data.map((item) => Task.fromJson(item)).toList();

    _autoSetupAlarms(tasks);
    return tasks;
  }

  void _autoSetupAlarms(List<Task> tasks) async {
    // 先弹窗申请权限
    bool hasPermission = await AlarmManagerService.requestAlarmPermissions();

    if (hasPermission) {
      for (var task in tasks) {
        // 如果是未完成状态，则尝试设置闹钟
        if (task.state == 0) {
          await AlarmManagerService.setDailyAlarm(task);

          await Future.delayed(const Duration(milliseconds: 1000));
        }
      }
      // 提示用户
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("已为您自动同步每日任务提醒至系统闹钟")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _getLoginStatus(),
      builder: (context, loginSnapshot) {
        // 加载状态检查
        if (loginSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        bool isLoggedIn = loginSnapshot.data ?? false;

        if (isLoggedIn) {
          // --- 情况 A: 已登录，使用另一个 FutureBuilder 加载任务列表 ---
          return FutureBuilder<List<Task>>(
            future: _loadTasksFromAsset(),
            builder: (context, taskSnapshot) {
              if (taskSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (taskSnapshot.hasError) {
                return Center(child: Text("加载任务失败: ${taskSnapshot.error}"));
              }

              final tasks = taskSnapshot.data ?? [];
              return _buildTaskList(tasks);
            },
          );
        } else {
          // --- 情况 B: 未登录，显示登录按钮 ---
          return _buildLoginButton();
        }
      },
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              // 左侧图标：根据状态显示
              leading: CircleAvatar(
                backgroundColor: task.state == 1 ? Colors.green[100] : Colors.red[50],
                child: Icon(
                  task.state == 1 ? Icons.check : Icons.medication,
                  color: task.state == 1 ? Colors.green : Colors.redAccent,
                ),
              ),

              // 标题：显示任务大类
              title: Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 副标题：将 detail 放在这里，并换行显示其他信息
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  // 重点显示的 detail
                  Text(
                    "说明：${task.detail}",
                    style: const TextStyle(
                      color: Colors.brown,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text("监督人：${task.ownName}"),
                  Text("提醒时间：${task.time}"),
                ],
              ),

              // 右侧闹钟按钮
              trailing: IconButton(
                icon: const Icon(Icons.alarm_add, color: Colors.blueGrey),
                onPressed: () {
                  // 调用之前定义的设置闹钟逻辑
                  // AlarmService.setAlarm(task);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("已为“${task.detail}”开启系统提醒")),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
  // 构建登录按钮界面 (保持不变)
  Widget _buildLoginButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("您尚未登录，请先登录以查看任务", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ).then((value) {
                setState(() {}); // 登录成功回来刷新页面
              });
            },
            child: const Text("去登录"),
          ),
        ],
      ),
    );
  }
}