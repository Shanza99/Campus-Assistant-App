import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudyGroups extends StatefulWidget {
  @override
  _StudyGroupsState createState() => _StudyGroupsState();
}

class _StudyGroupsState extends State<StudyGroups> {
  final TextEditingController _groupNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUserId = "user123"; // Replace with actual user ID from authentication

  void _createGroup(String groupName) async {
    if (groupName.isNotEmpty) {
      await _firestore.collection('study_groups').add({
        'name': groupName,
        'members': [_currentUserId],
        'createdBy': _currentUserId,
      });
      _groupNameController.clear();
      setState(() {});
    }
  }

  void _joinGroup(String groupId) async {
    final groupRef = _firestore.collection('study_groups').doc(groupId);
    final groupData = await groupRef.get();

    if (groupData.exists) {
      List members = groupData['members'];
      if (!members.contains(_currentUserId)) {
        members.add(_currentUserId);
        await groupRef.update({'members': members});
        setState(() {});
      }
    }
  }

  void _leaveGroup(String groupId) async {
    final groupRef = _firestore.collection('study_groups').doc(groupId);
    final groupData = await groupRef.get();

    if (groupData.exists) {
      List members = groupData['members'];
      if (members.contains(_currentUserId)) {
        members.remove(_currentUserId);
        await groupRef.update({'members': members});
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Groups"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: "Group Name"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _createGroup(_groupNameController.text),
              child: Text("Create Group"),
            ),
            SizedBox(height: 20),
            Text(
              "Available Groups:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('study_groups').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final groups = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      final groupId = group.id;
                      final groupName = group['name'];
                      final members = group['members'] as List;
                      final isMember = members.contains(_currentUserId);

                      return Card(
                        child: ListTile(
                          title: Text(groupName),
                          subtitle: Text("Members: ${members.length}"),
                          trailing: isMember
                              ? ElevatedButton(
                                  onPressed: () => _leaveGroup(groupId),
                                  child: Text("Leave"),
                                )
                              : ElevatedButton(
                                  onPressed: () => _joinGroup(groupId),
                                  child: Text("Join"),
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