import 'package:flutter/material.dart';

void main() {
  runApp(const TaskReminderApp());
}
//test change
class TaskReminderApp extends StatelessWidget {
  const TaskReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task & Goal Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Goals'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text(
          'Dashboard Ready for the Importance Slider!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}