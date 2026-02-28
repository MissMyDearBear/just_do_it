import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_do_it/page/TaskPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _lastPressTime; //记录上次按返回键的时间
  int _currentIndex = 0; // 当前选中的 Tab 下标

  // 定义三个 Tab 对应的页面列表
  final List<Widget> _pages = [
    const TaskPage(),
    const Center(child: Text("已完成", style: TextStyle(fontSize: 24))),
    const Center(child: Text("个人中心", style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) return; // 如果已经退出了，直接返回

          final now = DateTime.now();

          // 逻辑：如果两次点击间隔大于 2 秒，提示用户
          if (_lastPressTime == null ||
              now.difference(_lastPressTime!) > const Duration(seconds: 2)) {
            _lastPressTime = now;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("再按一次退出应用"),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            // 间隔小于 2 秒，真正退出应用
            SystemNavigator.pop(); // 推荐使用此方法安全退出 Android 应用
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(_getAppBarTitle()),
            backgroundColor: Colors.brown[100],
            centerTitle: true,
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Colors.brown,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: '任务',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: '已完成',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: '个人',
              ),
            ],
          ),
        ));
  }

  // 动态获取 AppBar 标题
  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return "我的任务";
      case 1:
        return "已完成事项";
      case 2:
        return "个人中心";
      default:
        return "Just Do It";
    }
  }
}
