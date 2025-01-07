import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackSystem extends StatefulWidget {
  @override
  _FeedbackSystemState createState() => _FeedbackSystemState();
}

class _FeedbackSystemState extends State<FeedbackSystem> {
  final TextEditingController _feedbackController = TextEditingController();
  final _categories = ['Courses', 'Professors', 'Campus Services'];
  String? _selectedCategory;
  double _rating = 3.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitFeedback() async {
    if (_selectedCategory != null && _feedbackController.text.isNotEmpty) {
      await _firestore.collection('feedback').add({
        'category': _selectedCategory,
        'rating': _rating,
        'comment': _feedbackController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _feedbackController.clear();
      setState(() {
        _selectedCategory = null;
        _rating = 3.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category and provide feedback.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              hint: Text('Choose a category'),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Rate:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _rating,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              label: _rating.toString(),
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Your Feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitFeedback,
                child: Text('Submit Feedback'),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('feedback').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final feedbackList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbackList[index];
                      return Card(
                        child: ListTile(
                          title: Text('${feedback['category']} - ${feedback['rating']} Stars'),
                          subtitle: Text(feedback['comment'] ?? ''),
                          trailing: Text(
                            feedback['timestamp'] != null
                                ? (feedback['timestamp'] as Timestamp).toDate().toString()
                                : '',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      );
                    },
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
