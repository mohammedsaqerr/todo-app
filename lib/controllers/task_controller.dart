import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) {
    return DBHelper.insert(task);

  }

 Future<void>getTask() async {
    final List<Map<String, dynamic>> task = await DBHelper.query();
    taskList.assignAll(task.map((data) => Task.fromJson(data)).toList());

  }

void  deleteTasks(Task task) {
    DBHelper.delete(task);
    getTask();
  }

 void markTasksCompleted(int id) async {
    await DBHelper.upDate(id);
    getTask();
  }
  void deleteAllTask() async{
    DBHelper.deleteAll();
    getTask();
  }
}
