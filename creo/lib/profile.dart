import 'dart:io';
import 'package:flutter/material.dart';
import 'change_name.dart';
import 'change_phone.dart';
import 'change_email.dart';
import 'change_information.dart';
import 'login.dart';
import 'daftar_creator.dart';
import 'upload_content.dart';
import 'content_info.dart';
import 'bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firestorage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();

  Stream<DocumentSnapshot<Map<String, dynamic>>?> streamRole() async* {
    User? currentUser = auth.currentUser;
    if (currentUser == null) {
      yield null;
    } else {
      String uid = currentUser.uid;
      yield* firestore.collection("user").doc(uid).snapshots();
    }
  }

  int _currentIndex = 3;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        leading: SizedBox(),
        title: Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
        stream: streamRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data != null) {
            String uid = auth.currentUser!.uid;
            Map<String, dynamic> user = snapshot.data!.data()!;
            String defaultProfile = "https://ui-avatars.com/api/?name=${user['name']}";
            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 170,
                              width: 250,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  onPressed: () async {
                                    if (user["profile"] != null && user["profile"] != "") {
                                      await firestore.collection("user").doc(uid).update({"profile": ""});
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Foto Profil Telah Dihapus")));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Foto Profil Kosong")));
                                    }
                                  },
                                  icon: Icon(Icons.delete, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Transform.rotate(
                              angle: -0.05,
                              child: Container(
                                height: 160,
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(45, 136, 120, 255),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Color(0xFFAA96E5),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  pickImage();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
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
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 25),
                          Text(
                            user["name"],
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_outlined, size: 20),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => ChangeNameScreen(user: user),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        "@${user['username']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildInfoContainer(
                        icon: Icons.phone_rounded,
                        label: 'Phone Number',
                        value: user["phone"] != null
                            ? user["phone"] != ""
                                ? user["phone"]
                                : " "
                            : " ",
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => ChangePhoneScreen(user: user),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      buildInfoContainer(
                        icon: Icons.email_rounded,
                        label: 'Email Address',
                        value: user["email"],
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => ChangeEmailScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20,),
                      if (!user['creator'])
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DaftarCreatorScreen(user: user),
                              ),
                            );
                          },
                          child: Container(
                            width: 170,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF270E50),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Daftar menjadi creator',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (user['creator'])
                        buildInfoContainer(
                          icon: Icons.info,
                          label: 'Information',
                          value: user["information"],
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => ChangeInformationScreen(user: user),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      if (user['creator'])
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadContentScreen(user: user),
                              ),
                            );
                          },
                          child: Container(
                            width: 170,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF270E50),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Upload Content',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      if(user['creator'])
                        Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'My Videos',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            StreamBuilder<QuerySnapshot>(
                              stream: firestore
                                  .collection('content')
                                  .where('uploader_uid', isEqualTo: uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                }
                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Center(child: Text('No videos found.'));
                                }

                                final videos = snapshot.data!.docs;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: videos.length,
                                  itemBuilder: (context, index) {
                                    final video = videos[index].data() as Map<String, dynamic>;
                                    return buildVideoItem(video);
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: Text("Data Tidak Ditemukan"));
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget buildInfoContainer({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, size: 20),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoItem(Map<String, dynamic> video) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContentInfoPage(contentt: video,)),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  video['cover_url'] ?? 'https://via.placeholder.com/150',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      video['details'] ?? 'No Description',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String uid = auth.currentUser!.uid;
        String extension = image.name.split('.').last;
        Reference storageReference = firestorage.ref().child("user/uid/$uid/profile/profile.$extension");
        UploadTask uploadTask = storageReference.putFile(File(image.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        await firestore.collection("user").doc(uid).update({"profile": imageUrl});

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Foto Profil Berhasil Di-Update")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Tidak Ada Gambar yang Dipilih")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
