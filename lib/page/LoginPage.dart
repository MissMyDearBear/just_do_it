import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_do_it/account/IAccountRepository.dart';
import 'package:just_do_it/consts/Const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _psdController = TextEditingController();
  String? _phoneError; // 用于存储错误信息

  void _validatePhone(String value) {
    setState(() {
      if (value.length != 11) {
        _phoneError = "手机号必须为11位"; // 错误提示
      } else {
        _phoneError = null; // 清除错误提示
      }
    });
  }

  void _handleLogin() async {
    try {
      bool isSuccess = true;

      // 登录逻辑处理
      if (_phoneError == null && _phoneController.text.isNotEmpty) {
        final user = await account.queryUserByPhone(_phoneController.text);

        if (user == null) {
          // 用户不存在，注册新用户
          await account.addUser(_phoneController.text, _psdController.text);
          isSuccess = true;
        } else {
          // 用户存在，验证密码
          if (!_psdController.text.endsWith(user.password)) {
            isSuccess = false;
            setState(() {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("账号或密码错误")));
            });
            return;
          }
        }

        if (isSuccess) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool(SP_KEY_IS_LOGIN, true);
          setState(() {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("登录成功，欢迎回家！")));
            Navigator.pop(context);
          });
        }
      } else {
        // 提示用户输入正确的手机号
        setState(() {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("请输入有效的手机号")));
        });
      }
    } catch (e) {
      print(e);
      // 捕获异常并提示用户
      setState(() {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("登录失败，请稍后重试")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Center(
                child: Text(
                  "您好，欢迎登录",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TextField(
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
                LengthLimitingTextInputFormatter(11), // 限制最大长度为11位
              ],
              onChanged: _validatePhone,
              decoration: InputDecoration(
                hintText: "请输入手机号",
                labelText: "手机号",
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                errorText: _phoneError,
                // 显示错误信息
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // 红色边框
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _psdController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "请输入密码",
                labelText: "密码",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black),
                minimumSize: WidgetStateProperty.all(const Size(200, 50)),
              ),
              onPressed: _handleLogin, // 按钮点击事件
              child: const Text(
                "登录",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
