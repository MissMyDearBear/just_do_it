import 'package:just_do_it/account/AccountMemRepository.dart';

import '../db/AppDatabase.dart';

abstract class IAccountRepository {

  Future<void> addUser(String phone,String psd);

  Future<User?>queryUserByPhone(String phone);
}

final account = AccountMemRepository();
