import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'database/taskDatabase.dart';
import 'model/taskDao.dart';
import 'model/taskModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorTaskdatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final Taskdatabase database;

  const MyApp(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: MyHomePage(title: 'Task Manager App', database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Taskdatabase database;

  const MyHomePage({super.key, required this.title, required this.database});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TaskDao taskDao;
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskDao = widget.database.taskDao;
  }

  Future<void> _showAddTaskDialog() async {
    _taskController.clear(); // Limpiar el campo antes de abrir el diálogo

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva tarea'),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(hintText: 'Ingrese el nombre de la tarea'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final taskName = _taskController.text.trim();
                if (taskName.isNotEmpty) {
                  final newTask = Task(task: taskName);
                  await taskDao.insertTask(newTask);
                  setState(() {});
                }
                Navigator.pop(context);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditTaskDialog(Task task) async {
    _taskController.text = task.task; // Cargar el nombre actual

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(hintText: 'Modifique el nombre de la tarea'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cerrar sin editar
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final updatedName = _taskController.text.trim();
                if (updatedName.isNotEmpty) {
                  final updatedTask = Task(id: task.id, task: updatedName, selected: task.selected);
                  await taskDao.updateTask(updatedTask);
                  setState(() {}); // Actualizar la UI
                }
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Task>>(
        future: taskDao.getAllTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay tareas aún'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.task),
                  leading: Checkbox(
                    value: task.selected,
                    onChanged: (bool? value) async {
                      final updatedTask = Task(id: task.id, task: task.task, selected: value ?? false);
                      await taskDao.updateTask(updatedTask);
                      setState(() {});
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await taskDao.deleteTask(task);
                      setState(() {});
                    },
                  ),
                  onLongPress: () => _showEditTaskDialog(task),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Agregar tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}
