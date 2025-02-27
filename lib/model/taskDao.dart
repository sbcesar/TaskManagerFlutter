import 'package:floor/floor.dart';
import 'package:task_list_room/model/taskModel.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM Task')
  Future<List<Task>> getAllTasks();

  @insert
  Future<void> insertTask(Task task);

  @update
  Future<void> updateTask(Task task);

  @delete
  Future<void> deleteTask(Task task);
}