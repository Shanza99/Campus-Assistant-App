import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class EventNotifications extends StatefulWidget {
  @override
  _EventNotificationsState createState() => _EventNotificationsState();
}

class _EventNotificationsState extends State<EventNotifications> {
  late FirebaseMessaging _firebaseMessaging;
  String _notificationMessage = "";

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;
    _initializeFCM();
    _listenToFCM();
  }

  void _initializeFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications.');
    } else {
      print('User declined or has not accepted permission.');
    }

    // Get the device token for testing or sending messages
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
  }

  void _listenToFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          _notificationMessage = "${message.notification!.title}: ${message.notification!.body}";
        });
        print("Notification: ${message.notification!.title}, ${message.notification!.body}");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.data}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Push Notifications for Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _notificationMessage.isNotEmpty
                  ? "Latest Notification: $_notificationMessage"
                  : "No notifications yet.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate sending a notification
                print("Simulate manual notification trigger.");
              },
              child: Text("Simulate Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
