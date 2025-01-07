import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AssignmentTracker extends StatefulWidget {
  @override
  _AssignmentTrackerState createState() => _AssignmentTrackerState();
}

class _AssignmentTrackerState extends State<AssignmentTracker> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late Database _localDatabase;

  @override
  void initState() {
    super.initState();
    _initializeLocalDatabase();
    _initializeNotifications();
  }

  Future<void> _initializeLocalDatabase() async {
    _localDatabase = await openDatabase(
      join(await getDatabasesPath(), 'assignments.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE assignments(id TEXT PRIMARY KEY, title TEXT, deadline TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _addAssignment(String title, String deadline) async {
    final id = DateTime.now().toIso8601String();

    // Add to Firestore
    await FirebaseFirestore.instance.collection('assignments').doc(id).set({
      'title': title,
      'deadline': deadline,
    });

    // Add to SQLite
    await _localDatabase.insert(
      'assignments',
      {
        'id': id,
        'title': title,
        'deadline': deadline,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Schedule notification
    await _scheduleNotification(id, title, deadline);

    setState(() {});
  }

  Future<void> _scheduleNotification(String id, String title, String deadline) async {
    final parsedDeadline = DateTime.parse(deadline);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id.hashCode,
      'Assignment Reminder',
      'Your assignment "$title" is due.',
      parsedDeadline,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'assignment_channel',
          'Assignment Reminders',
          'Notifications for assignment deadlines',
          importance: Importance.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAssignments() async {
    // Fetch from SQLite
    final localAssignments = await _localDatabase.query('assignments');

    return localAssignments;
  }

  Future<void> _deleteAssignment(String id) async {
    // Delete from Firestore
    await FirebaseFirestore.instance.collection('assignments').doc(id).delete();

    // Delete from SQLite
    await _localDatabase.delete('assignments', where: 'id = ?', whereArgs: [id]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Assignment Title'),
                ),
                TextField(
                  controller: _deadlineController,
                  decoration: InputDecoration(labelText: 'Deadline (YYYY-MM-DD HH:MM:SS)'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isNotEmpty &&
                        _deadlineController.text.isNotEmpty) {
                      await _addAssignment(_titleController.text, _deadlineController.text);
                      _titleController.clear();
                      _deadlineController.clear();
                    }
                  },
                  child: Text('Add Assignment'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchAssignments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final assignments = snapshot.data!;

                return ListView.builder(
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];
                    return ListTile(
                      title: Text(assignment['title']),
                      subtitle: Text('Deadline: ${assignment['deadline']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteAssignment(assignment['id']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
