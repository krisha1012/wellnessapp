import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Map<String, dynamic>> tasks = [
    {"task": "Resume by tomorrow", "date": "Sun, 1 Sep", "isCompleted": false},
    {"task": "Module 5 ML Reg by tomorrow", "date": "Wed, 4 Sep", "isCompleted": false},
    {"task": "Search entrance exams for Dhruv by Thursday", "date": "Thu, 5 Sep", "isCompleted": false},
  ];

  final TextEditingController taskController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void _addTask(String task) {
    final formattedDate = DateFormat('E, d MMM').format(selectedDate);
    final formattedTime = selectedTime.format(context);
    setState(() {
      tasks.add({"task": task, "date": "$formattedDate at $formattedTime", "isCompleted": false});
    });
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
                      if (date != null && date != selectedDate) {
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
                      if (time != null && time != selectedTime) {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Text('Select Time'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Selected Date: ${DateFormat('E, d MMM').format(selectedDate)} at ${selectedTime.format(context)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  _addTask(taskController.text);
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

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['isCompleted'] = !tasks[index]['isCompleted'];
    });
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
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Krisha Bhanushali'),
              accountEmail: Text('kahemani10@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('K', style: TextStyle(fontSize: 40.0)),
              ),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text('My Day'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Important'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Planned'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Tasks'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Completed Tasks'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/beach.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return taskCard(
                          tasks[index]["task"], 
                          tasks[index]["date"], 
                          tasks[index]["isCompleted"], 
                          index
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                    onPressed: _showAddTaskDialog,
                    icon: Icon(Icons.add, color: Colors.black),
                    label: Text('Add a task', style: TextStyle(color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget taskCard(String task, String date, bool isCompleted, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          onChanged: (value) {
            _toggleTaskCompletion(index);
          },
        ),
        title: Text(
          task,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('Tasks · $date', style: TextStyle(color: Colors.red)),
        trailing: Icon(Icons.star_border),
      ),
    );
  }
}
