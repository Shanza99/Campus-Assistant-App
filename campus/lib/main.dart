import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this path is correct
import 'class_schdule.dart'; // Import the Class Schedule screen
import 'event.dart'; // Import the Event Notifications screen
import 'assignment.dart'; // Import the Assignment screen
import 'study.dart';
import 'feedback.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return AuthScreen();
          } else {
            return DashboardScreen();
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Sign Up Error: $e');
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String _message = '';

  void _signUp() async {
    User? user = await _authService.signUp(_emailController.text, _passwordController.text);
    if (user != null) {
      setState(() {
        _message = "Sign Up Successful: ${user.email}";
      });
    } else {
      setState(() {
        _message = "Sign Up Failed. Please check your email and password.";
      });
    }
  }

  void _signIn() async {
    User? user = await _authService.signIn(_emailController.text, _passwordController.text);
    if (user != null) {
      setState(() {
        _message = "Login Successful: ${user.email}";
      });
    } else {
      setState(() {
        _message = "Login Failed. Please check your credentials.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signUp, child: Text('Sign Up')),
            ElevatedButton(onPressed: _signIn, child: Text('Login')),
            SizedBox(height: 20),
            Text(_message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildCard('Events', Icons.event, Colors.red, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventNotifications()),
            );
          }),
          _buildCard('Assignments', Icons.assignment, Colors.blue, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssignmentTracker()),
            );
          }),
          _buildCard('Class Schedule', Icons.schedule, Colors.green, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClassScheduleScreen()),
            );
          }),
          _buildCard('Feedback', Icons.feedback, Colors.orange, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedbackSystem()),
            );
          }),
          _buildCard('Study Group', Icons.group, Colors.purple, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudyScreen()),
            );
          }),
          _buildCard('Settings', Icons.settings, Colors.teal, () {}),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      color: color.withOpacity(0.8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
