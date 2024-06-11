import 'dart:math';
import 'package:flutter/material.dart';
import 'category_creator.dart';
import 'livestreaming_join.dart';
import 'videoconference_join.dart';
import 'content_info.dart';
import 'bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firestorage = FirebaseStorage.instance;

  late Future<List<Map<String, dynamic>>> creatorListFuture;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamRole() {
    String uid = auth.currentUser!.uid;
    return firestore.collection("user").doc(uid).snapshots();
  }

  Future<List<Map<String, dynamic>>> fetchContent() async {
    List<Map<String, dynamic>> contentList = [];
    try {
      CollectionReference contentCollection = firestore.collection('content');
      QuerySnapshot querySnapshot = await contentCollection.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      if (docs.length > 5) {
        final random = Random();
        Set<int> indices = {};

        while (indices.length < 5) {
          indices.add(random.nextInt(docs.length));
        }

        for (var index in indices) {
          contentList.add(docs[index].data() as Map<String, dynamic>);
        }
      } else {
        for (var doc in docs) {
          contentList.add(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return contentList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: streamRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            Map<String, dynamic> user = snapshot.data!.data()!;
            String defaultProfile = "https://ui-avatars.com/api/?name=${user['name']}";

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchContent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> contents = snapshot.data!;

                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 170,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(17.5),
                                bottomRight: Radius.circular(17.5),
                              ),
                              color: Colors.deepPurple,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Hallo, ${user['name']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: Image.network(
                                            user["profile"] != null
                                                ? user["profile"] != ""
                                                    ? user["profile"]
                                                    : defaultProfile
                                                : defaultProfile,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Search your favourite creator',
                                        hintStyle: const TextStyle(color: Color(0xFFA5A5A5)),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Top Content',
                                  style: TextStyle(
                                    color: Color(0xFF383C45),
                                    fontSize: 22,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                            child: Image(image: AssetImage('assets/promo_banner.png')),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Category',
                                  style: TextStyle(
                                    color: Color(0xFF383C45),
                                    fontSize: 22,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryCreatorScreen(user: user,)),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: const Color(0xFFE6E6E6),
                                        child: ClipRRect(
                                          child: Image.asset(
                                            'assets/category1.png',
                                            width: 20,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Creator',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LiveStreamingJoin(user: user)),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: const Color(0xFFE6E6E6),
                                        child: ClipRRect(
                                          child: Image.asset(
                                            'assets/category2.png',
                                            width: 35,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Live Streaming',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => VideoConferenceJoin(user: user)),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: const Color(0xFFE6E6E6),
                                        child: ClipRRect(
                                          child: Image.asset(
                                            'assets/category3.png',
                                            width: 35,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Group Call',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Discovery Preview',
                                    style: TextStyle(
                                      color: Color(0xFF383C45),
                                      fontSize: 22,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.25),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(1, 3),
                                      ),
                                    ],
                                  ),
                                  height: 610,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: contents.length,
                                    itemBuilder: (context, index) {
                                      final contentt = contents[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 16),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ContentInfoPage(contentt: contentt)),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: Image.network(
                                                  contentt["cover_url"] != null
                                                      ? contentt["cover_url"] != ""
                                                          ? contentt["cover_url"]
                                                          : "https://ui-avatars.com/api/?name=${contentt['uploader_name']}"
                                                      : "https://ui-avatars.com/api/?name=${contentt['uploader_name']}",
                                                  width: 90.0,
                                                  height: 90.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(contentt['uploader_name']),
                                                  Text(
                                                    contentt['title'],
                                                    style: const TextStyle(
                                                      color: Color(0xFF191919),
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    'PRICE',
                                                    style: const TextStyle(
                                                      color: Color(0xFFF26D20),
                                                      fontSize: 12,
                                                      fontFamily: 'Roboto',
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.star, color: Colors.yellow),
                                                      Text(
                                                        'RATING',
                                                        style: const TextStyle(
                                                          color: Color(0xFF8C8C8C),
                                                          fontSize: 12,
                                                          fontFamily: 'Roboto',
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text("Data Tidak Ditemukan"));
                }
              },
            );
          } else {
            return const Center(child: Text("Data Tidak Ditemukan"));
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
