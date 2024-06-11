import 'package:flutter/material.dart';
import 'creator_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottom_navbar.dart';

class CategoryCreatorScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const CategoryCreatorScreen({super.key, required this.user});

  @override
  CategoryCreatorScreenState createState() => CategoryCreatorScreenState();
}

class CategoryCreatorScreenState extends State<CategoryCreatorScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> creatorListFuture;
  List<Map<String, dynamic>> allCreators = [];
  List<Map<String, dynamic>> filteredCreators = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    creatorListFuture = fetchCreators();
    _searchController.addListener(_filterCreators);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCreators);
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchCreators() async {
    List<Map<String, dynamic>> creators = [];

    try {
      CollectionReference usersCollection = firestore.collection('user');

      QuerySnapshot querySnapshot = await usersCollection
          .where('creator', isEqualTo: true)
          .get();

      for (var doc in querySnapshot.docs) {
        creators.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error: $e");
    }

    allCreators = creators;
    filteredCreators = creators;
    return creators;
  }

  void _filterCreators() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCreators = allCreators;
      } else {
        filteredCreators = allCreators
            .where((creator) =>
                creator['name'].toLowerCase().contains(query) ||
                creator['username'].toLowerCase().contains(query))
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
        future: creatorListFuture,
        builder: (context, creatorsSnapshot) {
          if (creatorsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (creatorsSnapshot.hasError) {
            return Center(child: Text("Error: ${creatorsSnapshot.error}"));
          } else if (creatorsSnapshot.hasData) {
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
                          hintStyle: const TextStyle(color: Color(0xFFA5A5A5),),
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
                          'Kreator',
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
                  const SizedBox(height: 20,),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 30.0,
                      ),
                      itemCount: filteredCreators.length,
                      itemBuilder: (context, index) {
                        final creator = filteredCreators[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreatorInfo(user: widget.user, creator: creator,)),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  creator["profile"] != null
                                    ? creator["profile"] != ""
                                        ? creator["profile"]
                                        : "https://ui-avatars.com/api/?name=${creator['name']}"
                                    : "https://ui-avatars.com/api/?name=${creator['name']}",
                                  width: 60.0,
                                  height: 60.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 4,),
                            Text(
                              creator["name"],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF911348),
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(height: 4,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                maxWidth: 80
                              ),
                              height: 25,
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                                  child: Text(
                                    creator["role"] != null
                                    ? creator["role"] != ""
                                        ? creator["role"]
                                        : "Creator"
                                    : "Creator",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
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
