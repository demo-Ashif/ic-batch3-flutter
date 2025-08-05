import 'package:flutter/material.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // List to store our todo items
  List<TodoItem> todos = [];

  // Controller for the text field
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Method to add a new todo
  void _addTodo() {
    // Get the text from the controller
    String todoText = _textController.text.trim();

    // Only add if text is not empty
    if (todoText.isNotEmpty) {
      setState(() {
        // Add new todo to the list
        todos.add(TodoItem(text: todoText, isCompleted: false));
      });

      // Clear the text field
      _textController.clear();
    }
  }

  // Method to toggle todo completion status
  void _toggleTodo(int index) {
    setState(() {
      // Toggle the completion status
      todos[index].isCompleted = !todos[index].isCompleted;
    });
  }

  // Method to delete a todo
  void _deleteTodo(int index) {
    setState(() {
      // Remove the todo from the list
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 To-Do App'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new task...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Info section for beginners
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 How setState() works here:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• When you add a task: setState() updates the todos list\n'
                    '• When you check/uncheck: setState() toggles isCompleted\n'
                    '• When you delete: setState() removes item from list\n'
                    '• setState() tells Flutter to rebuild the UI with new data',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Todo list
            Expanded(
              child:
                  todos.isEmpty
                      ? const Center(
                        child: Text(
                          'No tasks yet!\nAdd a task to get started.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Checkbox(
                                value: todo.isCompleted,
                                onChanged: (_) => _toggleTodo(index),
                              ),
                              title: Text(
                                todo.text,
                                style: TextStyle(
                                  decoration:
                                      todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                  color:
                                      todo.isCompleted
                                          ? Colors.grey
                                          : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteTodo(index),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple class to represent a todo item
class TodoItem {
  String text;
  bool isCompleted;

  TodoItem({required this.text, required this.isCompleted});
}
