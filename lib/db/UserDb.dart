import 'package:drift/drift.dart';

@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().nullable()();

  TextColumn get iphone => text().unique() ();

  TextColumn get password => text()();

  IntColumn get age => integer().nullable()();
}
