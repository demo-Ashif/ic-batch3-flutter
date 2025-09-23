import 'package:flutter/material.dart';
import 'data/local_db.dart';
import 'models/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite (sqflite) Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const TaskPage(),
    );
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<List<Task>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = LocalDb.instance.getAllTasks();
    setState(() {});
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Task title'),
          autofocus: true,
          onSubmitted: (_) => Navigator.pop(context, controller.text.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () =>
                  Navigator.pop(context, controller.text.trim()),
              child: const Text('Add')),
        ],
      ),
    );

    if (title != null && title.isNotEmpty) {
      await LocalDb.instance.insertTask(Task(title: title));
      _reload();
    }
  }

  Future<void> _toggle(Task t) async {
    await LocalDb.instance.toggleDone(t.id!, !t.isDone);
    _reload();
  }

  Future<void> _edit(Task t) async {
    final controller = TextEditingController(text: t.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Task title'),
          autofocus: true,
          onSubmitted: (_) => Navigator.pop(context, controller.text.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () =>
                  Navigator.pop(context, controller.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
    if (newTitle != null && newTitle.isNotEmpty) {
      await LocalDb.instance.updateTitle(t.id!, newTitle);
      _reload();
    }
  }

  Future<void> _delete(Task t) async {
    await LocalDb.instance.deleteTask(t.id!);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks (sqflite)'),
        actions: [
          IconButton(
            tooltip: 'Delete all',
            onPressed: () async {
              await LocalDb.instance.deleteAll();
              _reload();
            },
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Task>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final tasks = snap.data ?? [];
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks yet. Add one!'));
          }
          return ListView.separated(
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (_, i) {
              final t = tasks[i];
              return ListTile(
                title: Text(
                  t.title,
                  style: t.isDone
                      ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey)
                      : null,
                ),
                subtitle: Text('id=${t.id} • ${t.createdAt}'),
                leading: Checkbox(
                  value: t.isDone,
                  onChanged: (_) => _toggle(t),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () => _edit(t),
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () => _delete(t),
                        icon: const Icon(Icons.delete)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
