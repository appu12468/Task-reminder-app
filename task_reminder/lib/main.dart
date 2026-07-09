import 'package:flutter/material.dart';

void main() => runApp(TaskReminderApp());

class TaskReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Reminder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskDashboard(),
    );
  }
}

class TaskDashboard extends StatefulWidget {
  @override
  _TaskDashboardState createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  // --- STATE (Memory) ---
  final _nameController = TextEditingController();
  double _priority = 5.0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<Map<String, dynamic>> _myTasks = [];

  // --- LOGIC: Calculate Time Format (e.g. 3m2w) ---
  String _formatTimeLeft(DateTime target) {
    final diff = target.difference(DateTime.now());
    if (diff.isNegative) return "Expired";

    if (diff.inDays >= 365) {
      int y = diff.inDays ~/ 365;
      int m = (diff.inDays % 365) ~/ 30;
      return "${y}y${m}m";
    } else if (diff.inDays >= 30) {
      int m = diff.inDays ~/ 30;
      int w = (diff.inDays % 30) ~/ 7;
      return "${m}m${w}w";
    } else if (diff.inDays >= 1) {
      return "${diff.inDays}d${diff.inHours % 24}h";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours}h${diff.inMinutes % 60}min";
    }
    return "${diff.inMinutes}min${diff.inSeconds % 60}sec";
  }

  // --- ACTION: Add & Reset ---
  void _addTask() {
    if (_nameController.text.isNotEmpty && _selectedDate != null && _selectedTime != null) {
      final finalDate = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute);
      
      setState(() {
        _myTasks.add({
          'name': _nameController.text,
          'due': finalDate,
        });
        // RESET EVERYTHING
        _nameController.clear();
        _priority = 5.0;
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row( // This creates the "NotebookLM" side-by-side look
        children: [
          // LEFT SIDE: Task List (Persistent)
          Container(
            width: 300,
            color: Colors.grey,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(16), child: Text("Your Goals", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                Expanded(
                  child: ListView.builder(
                    itemCount: _myTasks.length,
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(_myTasks[i]['name'].toString()),
                      subtitle: Text(_formatTimeLeft(_myTasks[i]['due'] as DateTime)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // RIGHT SIDE: Input Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  TextField(controller: _nameController, decoration: InputDecoration(labelText: "Task Name")),
                  Row(
                    children: [
                      ElevatedButton(onPressed: () async {
                        _selectedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                        setState(() {});
                      }, child: Text(_selectedDate == null ? "Pick Date" : _selectedDate.toString().split(' '))),
                      SizedBox(width: 10),
                      ElevatedButton(onPressed: () async {
                        _selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        setState(() {});
                      }, child: Text(_selectedTime == null ? "Pick Time" : _selectedTime!.format(context))),
                    ],
                  ),
                  Slider(value: _priority, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _priority = v)),
                  ElevatedButton(onPressed: _addTask, child: Text("Add Goal")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
