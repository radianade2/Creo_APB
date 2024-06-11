import 'dart:math';
import 'package:flutter/material.dart';
import 'home.dart';
import 'bottom_navbar.dart';
import 'package:creo/livestreaming_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LiveStreamingJoin extends StatefulWidget {
  final Map<String, dynamic> user;
  LiveStreamingJoin({Key? key, required this.user}) : super(key: key);

  @override
  LiveStreamingJoinState createState() => LiveStreamingJoinState();
}

class LiveStreamingJoinState extends State<LiveStreamingJoin> {
  late Future<void> liveStreamerCreatorListFuture;
  late final bool isCreator;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;

  List<Widget> carouselWidgetList = [];

  @override
  void initState() {
    super.initState();
    isCreator = widget.user['creator'] ?? false;
    liveStreamerCreatorListFuture = fetchCreators();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> fetchCreators() async {
    try {
      CollectionReference usersCollection = firestore.collection('user');

      QuerySnapshot querySnapshot = await usersCollection
          .where('creator', isEqualTo: true)
          .where('isLive', isEqualTo: true)
          .get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> creator = doc.data() as Map<String, dynamic>;

        Widget creatorWidget = GestureDetector(
          onTap: () {jumpToLivePage(context, liveID: creator["uid"], isHost: false);},
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 350,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: Image.network(
                    creator["profile"] != null
                        ? creator["profile"] != ""
                            ? creator["profile"]
                            : "https://ui-avatars.com/api/?name=${creator['name']}"
                        : "https://ui-avatars.com/api/?name=${creator['name']}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                  color: Color(0xFFEBEBEB)
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        creator["name"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IntrinsicWidth(
                        child: Container(
                          height: 30,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepPurple
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              creator["role"] != null
                                  ? creator["role"] != ""
                                      ? creator["role"]
                                      : "Creator"
                                  : "Creator",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        );

        carouselWidgetList.add(creatorWidget);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => Screen())
              MaterialPageRoute(builder: (context) => HomeScreen())
            );
          },
        ),
        title: Center(child: Text("Group Call")),
        actions: [SizedBox(width: MediaQuery.of(context).size.width * 0.15,)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          "${widget.user['name']}",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          widget.user["profile"] != null
                              ? widget.user["profile"] != ""
                                  ? widget.user["profile"]
                                  : "https://ui-avatars.com/api/?name=${widget.user['name']}"
                              : "https://ui-avatars.com/api/?name=${widget.user['name']}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12,),
                if(isCreator)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Your Live Stream",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 5,),
                      GestureDetector(
                        onTap: () async {
                          try{
                            await firestore.collection("user").doc(widget.user['uid']).update({
                              "isLive": true,
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: const Text('Terjadi Kesalahan, Tidak Dapat Memulai Live'))
                            );
                          }
                        sendNotification();
                        jumpToLivePage(context, liveID: widget.user['uid'], isHost: true,);
                        },
                        child: IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,5,10,5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFF6524CD)
                              )
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.person_outline, size: 20, color: Color(0xFF6524CD) ,),
                                SizedBox(width: 5,),
                                Text("Start Live Streaming", style: TextStyle(color: Color(0xFF6524CD), fontSize: 14, fontWeight: FontWeight.w600),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                    ],
                  ),
                

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red,
                            ),
                            child: Text(
                              "On Streaming",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.9)
                              ),
                            ),
                          ),
                          SizedBox(width: 3,),
                          Icon(Icons.circle, color: Colors.red, size: 20,),
                        ],
                      )
                    ),
                  ],
                ),
                
                SizedBox(height: 15,),
                FutureBuilder<void>(
                  future: liveStreamerCreatorListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      if(carouselWidgetList.isNotEmpty){
                        return CarouselSlider(
                          options: CarouselOptions(
                            height: 450,
                            autoPlay: carouselWidgetList.length > 1 ? true : false,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration: Duration(seconds: 1),
                            aspectRatio: 0.5,
                            viewportFraction: 0.82,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: carouselWidgetList.length > 1 ? true : false,
                            enlargeFactor: 0.2,
                          ),
                          items: carouselWidgetList,
                        );
                      } else {
                        return Center(child: Text("TIDAK ADA LIVE YANG BERLANGSUNG", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.5)),),);
                      }
                    }
                  },
                ),     
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
    
  }

  void jumpToLivePage(BuildContext context,
      {required String liveID, required bool isHost,}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(liveID: liveID, isHost: isHost, user: widget.user,),
      ),
    );
  }

  void sendNotification() async {
    String randomStr;
    const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random _rnd = Random();

    randomStr = String.fromCharCodes(Iterable.generate( 20,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ));

    try {
      await firestore.collection("notification").doc(randomStr).set({
        "name": widget.user['name'],
        "message": "Live Streaming Has Started!",
        "profile": widget.user['profile'] != null
                    ? widget.user['profile'] != "" 
                      ? widget.user['profile']
                      : "https://ui-avatars.com/api/?name=${widget.user['name']}"
                    : "https://ui-avatars.com/api/?name=${widget.user['name']}",
        "createdAt": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Tidak Dapat Mengirimkan Notifikasi'))
      );
    }
  }
}
