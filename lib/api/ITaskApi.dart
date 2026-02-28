import 'package:just_do_it/mode/Task.dart';

abstract class ITaskApi {
  Future<List<Task>> getTaskList();

  Future<List<Task>> getDoneList();

  Future<void> finshTask(Task task);
}
