import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _lastPressTimer; //记录上次按返回键的时间

  bool _canPop() {
    DateTime curr = DateTime.now();
    if (_lastPressTimer != null ||
        (_lastPressTimer != null &&
            curr.difference(_lastPressTimer!) > Duration(seconds: 1))) {
      _lastPressTimer = curr;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("再按一次退出应用"), duration: Duration(seconds: 1)),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: _canPop(), child: Center(child: Text("首页")));
  }
}
