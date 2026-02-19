import 'package:just_do_it/account/IAccountRepository.dart';
import 'package:just_do_it/db/AppDatabase.dart';

import '../main.dart';

class AccountDbRepository implements IAccountRepository{
  @override
  Future<void> addUser(String phone, String psd) async{
    await database
        .into(database.users)
        .insert(UsersCompanion.insert(iphone: phone, password: psd));
  }

  @override
  Future<User?> queryUserByPhone(String phone) async{
    final user =
    await (database.select(database.users)
      ..where((u) => u.iphone.equals(phone))).getSingleOrNull();
    return user;
  }

}