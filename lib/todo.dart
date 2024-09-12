import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Task {
  final String id;
  final String task;
  final String date;
  bool isCompleted;

  Task({required this.id, required this.task, required this.date, this.isCompleted = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      task: json['task'],
      date: json['date'],
      isCompleted: json['isCompleted'],
    );
  }
}

class TodoPage extends StatefulWidget {
  final String userId; // Accept userId

  TodoPage({required this.userId}); // Constructor to initialize userId

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse('http://localhost:5000/api/tasks/${widget.userId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        tasks = data.map((task) => Task.fromJson(task)).toList();
      });
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(String task) async {
    final formattedDate = DateFormat('E, d MMM').format(selectedDate);
    final formattedTime = selectedTime.format(context);

    final response = await http.post(
      Uri.parse('http://localhost:5000/api/tasks'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "userId": widget.userId, // Use passed userId to create task
        "task": task,
        "date": "$formattedDate at $formattedTime"
      }),
    );

    if (response.statusCode == 201) {
      Task newTask = Task.fromJson(json.decode(response.body));
      setState(() {
        tasks.add(newTask);
      });
    } else {
      throw Exception('Failed to add task');
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    final response = await http.put(
      Uri.parse('http://localhost:5000/api/tasks/$taskId'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"isCompleted": !isCompleted}),
    );

    if (response.statusCode == 200) {
      setState(() {
        tasks.firstWhere((task) => task.id == taskId).isCompleted = !isCompleted;
      });
    } else {
      throw Exception('Failed to update task');
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Task',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Text('Select Date'),
                  ),
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (time != null) {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Text('Select Time'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  addTask(taskController.text);
                  taskController.clear();
                  Navigator.of(context).pop();
                }
              },
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
        title: Text('Planned'),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Todo App Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(tasks[index].task),
              subtitle: Text(tasks[index].date),
              trailing: Checkbox(
                value: tasks[index].isCompleted,
                onChanged: (bool? value) {
                  toggleTaskCompletion(tasks[index].id, tasks[index].isCompleted);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
