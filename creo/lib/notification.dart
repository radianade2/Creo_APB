import 'package:flutter/material.dart';
import 'bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {

  int _currentIndex = 2;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 75,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(17.5),
                  bottomRight: Radius.circular(17.5),
                ),
                color: Colors.deepPurple,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 22, left: 16, right: 16),
                child: Text(
                  'Notification',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notification')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Tidak ada notifikasi dalam 24 jam terakhir'));
                  }

                  final notifications = snapshot.data!.docs;
                  final now = DateTime.now();

                  final filteredNotifications = notifications.where((notification) {
                    var createdAtString = notification['createdAt'];
                    DateTime createdAt = DateTime.parse(createdAtString);
                    return now.difference(createdAt).inHours < 24;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      var notification = filteredNotifications[index];
                      DateTime createdAt = DateTime.parse(notification['createdAt']);
                      var minutesAgo = DateTime.now().difference(createdAt).inMinutes;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(notification['profile']),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${notification['name']} ${notification['message']}",
                                        style: TextStyle(
                                          color: Color(0xFF191919),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        softWrap: true,
                                      ),
                                      Text(
                                        "$minutesAgo minutes ago",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.15),
                              thickness: 1,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
