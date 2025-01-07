import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ClassScheduleScreen extends StatefulWidget {
  @override
  _ClassScheduleScreenState createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen> {
  final _firestore = FirebaseFirestore.instance;
  late Database _database;
  List<Map<String, dynamic>> _offlineClasses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _fetchClasses();
  }

  Future<void> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'class_schedule.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE classes(id TEXT PRIMARY KEY, title TEXT, time TEXT)',
        );
      },
    );
  }

  Future<void> _fetchClasses() async {
    try {
      // Fetch from Firestore
      QuerySnapshot snapshot = await _firestore.collection('classes').get();
      List<Map<String, dynamic>> firestoreClasses = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      // Sync with SQLite
      for (var classData in firestoreClasses) {
        await _database.insert(
          'classes',
          classData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Fetch from SQLite
      List<Map<String, dynamic>> offlineClasses = await _database.query('classes');

      setState(() {
        _offlineClasses = offlineClasses;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  Future<void> _addClass(String title, String time) async {
    final newClass = {
      'id': DateTime.now().toIso8601String(),
      'title': title,
      'time': time,
    };

    // Add to Firestore
    await _firestore.collection('classes').doc(newClass['id']).set(newClass);

    // Add to SQLite
    await _database.insert('classes', newClass);

    setState(() {
      _offlineClasses.add(newClass);
    });
  }

  Future<void> _editClass(String id, String newTitle, String newTime) async {
    final updatedClass = {
      'id': id,
      'title': newTitle,
      'time': newTime,
    };

    // Update Firestore
    await _firestore.collection('classes').doc(id).update(updatedClass);

    // Update SQLite
    await _database.update(
      'classes',
      updatedClass,
      where: 'id = ?',
      whereArgs: [id],
    );

    setState(() {
      final index = _offlineClasses.indexWhere((cls) => cls['id'] == id);
      if (index != -1) {
        _offlineClasses[index] = updatedClass;
      }
    });
  }

  Future<void> _deleteClass(String id) async {
    // Delete from Firestore
    await _firestore.collection('classes').doc(id).delete();

    // Delete from SQLite
    await _database.delete(
      'classes',
      where: 'id = ?',
      whereArgs: [id],
    );

    setState(() {
      _offlineClasses.removeWhere((cls) => cls['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Schedule'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _offlineClasses.length,
              itemBuilder: (context, index) {
                final classData = _offlineClasses[index];
                return ListTile(
                  title: Text(classData['title']),
                  subtitle: Text(classData['time']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog(classData),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteClass(classData['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    String title = '';
    String time = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Time'),
                onChanged: (value) => time = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addClass(title, time);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(Map<String, dynamic> classData) {
    String title = classData['title'];
    String time = classData['time'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: TextEditingController(text: title),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Time'),
                controller: TextEditingController(text: time),
                onChanged: (value) => time = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editClass(classData['id'], title, time);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}
