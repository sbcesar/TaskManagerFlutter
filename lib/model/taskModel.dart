import 'package:floor/floor.dart';

@entity
class Task {
  @primaryKey
  final int id;
  final String task;
  final bool selected;

  // El PK es el id y se calcula con el tiempo en milisegundos
  Task({int? id, required this.task, this.selected = false})
      : id = id ?? DateTime.now().millisecondsSinceEpoch;
}