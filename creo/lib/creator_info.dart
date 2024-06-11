import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_creator.dart';
import 'content_info.dart';
import 'bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatorInfo extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> creator;

  const CreatorInfo({super.key, required this.user, required this.creator});

  @override
  _CreatorInfoState createState() => _CreatorInfoState();
}

class _CreatorInfoState extends State<CreatorInfo> {
  bool showInformation = true;
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F9FA),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryCreatorScreen(user: widget.user,)),
              );
            }
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        widget.creator["profile"] != null
                          ? widget.creator["profile"] != ""
                              ? widget.creator["profile"]
                              : "https://ui-avatars.com/api/?name=${widget.creator['name']}"
                          : "https://ui-avatars.com/api/?name=${widget.creator['name']}",
                        width: 90.0,
                        height: 90.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(widget.creator["name"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    IntrinsicWidth(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 27.5,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(start: 13, end: 13),
                            child: Text(
                              widget.creator["role"] != null
                              ? widget.creator["role"] != ""
                                  ? widget.creator["role"]
                                  : "Creator"
                              : "Creator",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    tabButton('Information', true),
                    tabButton('Video', false),
                  ],
                ),
              ),
              Container(
                child: showInformation
                  ? InformationTile(creator: widget.creator)
                  : VideoList(creatorUid: widget.creator['uid']),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }

  Widget tabButton(String text, bool isInfoTab) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showInformation = isInfoTab;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: showInformation == isInfoTab ? Colors.lightBlue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text, 
              style: TextStyle(
                fontSize: 16, 
                color: showInformation == isInfoTab ? Colors.lightBlue : Colors.black
              )
            ),
          ],
        ),
      ),
    );
  }
}


class InformationTile extends StatelessWidget {
  final Map<String, dynamic> creator;

  const InformationTile({super.key, required this.creator});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(creator["name"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    creator["information"] != null
                    ? creator["information"] != ""
                        ? creator["information"]
                        : "Hello! I'm ${creator['name']}, nice to meet you :)"
                    : "Hello! I'm ${creator['name']}, nice to meet you :)",
                    style: GoogleFonts.roboto(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class VideoList extends StatelessWidget {
  final String creatorUid;

  const VideoList({super.key, required this.creatorUid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('content')
          .where('uploader_uid', isEqualTo: creatorUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text('No videos found.')),
          );
        }
        final videos = snapshot.data!.docs;

        return ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  video['cover_url'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitWidth,
                ),
              ),
              title: Text(video['title'] ?? 'No Title'),
              subtitle: Text(video['details'] ?? 'No Description'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContentInfoPage(contentt: video,)),
                );
              },
            );
          },
          shrinkWrap: true,
        );
      },
    );
  }
}