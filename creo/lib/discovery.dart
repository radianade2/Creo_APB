import 'package:flutter/material.dart';
import 'content_info.dart';
import 'bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  DiscoveryScreenState createState() => DiscoveryScreenState();
}

class DiscoveryScreenState extends State<DiscoveryScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> contentListFuture;
  List<Map<String, dynamic>> allContents = [];
  List<Map<String, dynamic>> filteredContents = [];
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    contentListFuture = fetchContent();
    _searchController.addListener(_filterContents);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContents);
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchContent() async {
    List<Map<String, dynamic>> contentList = [];
    try {
      CollectionReference contentCollection = firestore.collection('content');
      QuerySnapshot querySnapshot = await contentCollection.get();
      List<QueryDocumentSnapshot> docs = querySnapshot.docs;

      for (var doc in docs) {
        contentList.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error: $e");
    }

    allContents = contentList;
    filteredContents = contentList;
    return contentList;
  }

  void _filterContents() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredContents = allContents;
      } else {
        filteredContents = allContents
            .where((content) =>
                content['title'].toLowerCase().contains(query) ||
                content['uploader_name'].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: contentListFuture,
        builder: (context, contentsSnapshot) {
          if (contentsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (contentsSnapshot.hasError) {
            return Center(child: Text("Error: ${contentsSnapshot.error}"));
          } else if (contentsSnapshot.hasData) {
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(17.5),
                        bottomRight: Radius.circular(17.5),
                      ),
                      color: Colors.deepPurple,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
                      child: TextField(
                        controller: _searchController,
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
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Discovery',
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
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredContents.length,
                      itemBuilder: (context, index) {
                        final contentt = filteredContents[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ContentInfoPage(contentt: contentt),
                                ),
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
                                    const Text(
                                      'PRICE',
                                      style: TextStyle(
                                        color: Color(0xFFF26D20),
                                        fontSize: 12,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Row(
                                      children: const [
                                        Icon(Icons.star, color: Colors.yellow),
                                        Text(
                                          'Partisipan',
                                          style: TextStyle(
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
                ],
              ),
            );
          } else {
            return const Center(child: Text("No data"));
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
