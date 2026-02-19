import 'dart:collection';

import 'package:just_do_it/account/IAccountRepository.dart';
import 'package:just_do_it/db/AppDatabase.dart';

class AccountMemRepository implements IAccountRepository {
  final HashMap<String, User> _has = HashMap();

  @override
  Future<void> addUser(String phone, String psd) async {
    _has[phone] = User(iphone: phone, password: psd, id: phone.hashCode);
  }

  @override
  Future<User?> queryUserByPhone(String phone) async {
    return _has[phone];
  }
}
