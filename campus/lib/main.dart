import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'dashboard.dart';
import 'auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser == null ? AuthScreen() : Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  final List<String> sliderImages = [
    'images/a (1).png',
    'images/a (2).png',
    'images/a (3).png',
    'images/a (4).png',
    'images/a (5).png',
    'images/a.png',
    'images/b.png',
  ];

  final List<Map<String, dynamic>> dashboardItems = [
    {'icon': Icons.event, 'label': 'Events', 'route': '/events'},
    {'icon': Icons.assignment, 'label': 'Assignments', 'route': '/assignments'},
    {'icon': Icons.schedule, 'label': 'Class Schedule', 'route': '/schedule'},
    {'icon': Icons.feedback, 'label': 'Feedback', 'route': '/feedback'},
    {'icon': Icons.group, 'label': 'Study Groups', 'route': '/study-groups'},
    {'icon': Icons.settings, 'label': 'Settings', 'route': '/settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: sliderImages.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    sliderImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: dashboardItems.length,
                itemBuilder: (context, index) {
                  final item = dashboardItems[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, item['route']),
                    child: Card(
                      elevation: 4,
                      color: Colors.blueAccent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 40, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            item['label'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
