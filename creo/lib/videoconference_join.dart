import 'dart:math';
import 'package:creo/videoconference_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottom_navbar.dart';
import 'home.dart';

class VideoConferenceJoin extends StatefulWidget {
  final Map<String, dynamic> user;
  VideoConferenceJoin({Key? key, required this.user}) : super(key: key);

  @override
  VideoConferenceJoinState createState() => VideoConferenceJoinState();
}

class VideoConferenceJoinState extends State<VideoConferenceJoin> {
  final _judulController = TextEditingController();
  final _durasiController = TextEditingController();
  final _tanggalMulaiController = TextEditingController();
  final _waktuMulaiController = TextEditingController();
  final _waktuBerakhirController = TextEditingController();

  late Future<List<Map<String, dynamic>>> groupCallListFuture;
  late final bool isCreator;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  int _currentIndex = 0;
  
  TimeOfDay? _waktuMulai;

  @override
  void initState() {
    super.initState();
    isCreator = widget.user['creator'] ?? false;
    groupCallListFuture = _fetchOnGoingGroupCall();
    _durasiController.addListener(_updateWaktuBerakhir);
    _waktuMulaiController.addListener(_updateWaktuBerakhir);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _updateWaktuBerakhir() {
    final durasi = int.tryParse(_durasiController.text);
    if (durasi != null && _waktuMulai != null) {
      final waktuBerakhir = _waktuMulai!.replacing(
        hour: (_waktuMulai!.hour + durasi ~/ 60) % 24,
        minute: (_waktuMulai!.minute + durasi % 60) % 60,
      );
      final berakhirFormatted = waktuBerakhir.format(context);
      _waktuBerakhirController.text = berakhirFormatted;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _waktuMulai ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _waktuMulai) {
      setState(() {
        _waktuMulai = picked;
        _waktuMulaiController.text = picked.format(context);
        _updateWaktuBerakhir();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _tanggalMulaiController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchOnGoingGroupCall() async {
    List<Map<String, dynamic>> groupCalls = [];
    try {
      CollectionReference groupCallCollection = firestore.collection('group_call');
      DateTime now = DateTime.now();
      QuerySnapshot querySnapshot = await groupCallCollection
          .where('tanggal', isEqualTo: now.toLocal().toString().split(' ')[0])
          .get();
      
      for (var doc in querySnapshot.docs) {
        groupCalls.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error: $e");
    }
    return groupCalls;
  }

  bool _isCurrentTimeWithinRange(String date, String startTime, String endTime) {
    final currentDateTime = DateTime.now();
    final startDateTime = DateTime.parse("$date $startTime:00");
    final endDateTime = DateTime.parse("$date $endTime:00");

    return currentDateTime.isAfter(startDateTime) && currentDateTime.isBefore(endDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(
              context,
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
                        "Create Group Call Session",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: 40,
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              controller: _judulController,
                              decoration: InputDecoration(
                                labelText: "Judul",
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                contentPadding: EdgeInsets.fromLTRB(10,0,0,10)
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: 40,
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              controller: _durasiController,
                              decoration: InputDecoration(
                                labelText: "Durasi (menit)",
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                contentPadding: EdgeInsets.fromLTRB(10,0,0,10)
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: 40,
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              controller: _waktuMulaiController,
                              decoration: InputDecoration(
                                labelText: "Waktu Mulai",
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                contentPadding: EdgeInsets.fromLTRB(10,0,0,10)
                              ),
                              readOnly: true,
                              onTap: () => _selectTime(context),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: 40,
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              controller: _waktuBerakhirController,
                              decoration: InputDecoration(
                                labelText: "Waktu Berakhir",
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                contentPadding: EdgeInsets.fromLTRB(10,0,0,10)
                              ),
                              readOnly: true,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: 40,
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              controller: _tanggalMulaiController,
                              decoration: InputDecoration(
                                labelText: "Tanggal Mulai",
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                contentPadding: EdgeInsets.fromLTRB(10,0,0,10)
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                await firestore.collection("group_call").doc(widget.user['uid']).set({
                                  'title': _judulController.text,
                                  'start': _waktuMulaiController.text,
                                  'end': _waktuBerakhirController.text,
                                  'tanggal': _tanggalMulaiController.text,
                                  'durasi': _durasiController.text,
                                  'creator': widget.user['name'],
                                  'profile': widget.user['profile'],
                                  'group_call_id': widget.user['uid']
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Terjadi Kesalahan, Tidak Dapat Membuat Group Call'))
                                );
                              }
                              sendNotification();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Group Call Telah Dijadwalkan'))
                              );
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoConferenceJoin(user: widget.user,)));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.43,
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color(0xFF6524CD)
                                )
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.person_outline, size: 20, color: Color(0xFF6524CD)),
                                  SizedBox(width: 5,),
                                  Text("Schedule a Call", style: TextStyle(color: Color(0xFF6524CD), fontSize: 14, fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                    ],
                  ),
                SizedBox(height: 15,),
                FutureBuilder(
                  future: groupCallListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      List<Map<String, dynamic>> groupCalls = snapshot.data!;
                      return Column(
                        children: groupCalls.map((groupCall) {
                          final isCurrentTimeValid = _isCurrentTimeWithinRange(
                            groupCall['tanggal'],
                            groupCall['start'],
                            groupCall['end']
                          );
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 175,
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Color.fromARGB(255, 193, 32, 221), Color.fromARGB(255, 87, 129, 255)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16,8,16,16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        groupCall['title'] ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        (isCurrentTimeValid ? "On Going" : "Ended"),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.hourglass_bottom, color: Colors.white, size: 18,),
                                      SizedBox(width: 5,),
                                      Text(
                                        "${groupCall['durasi']} menit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, color: Colors.white, size: 18,),
                                      SizedBox(width: 5,),
                                      Text(
                                        "${groupCall['tanggal']} at ${groupCall['start']} - ${groupCall['end']}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: isCurrentTimeValid ? () {
                                      jumpToGroupCall(context, conferenceID: groupCall['group_call_id']);
                                    } : null,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      decoration: ShapeDecoration(
                                        color: Color(0x7FD9D9D9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                groupCall['profile'] != null
                                                    ? groupCall['profile'] != ""
                                                        ? groupCall['profile']
                                                        : "https://ui-avatars.com/api/?name=${groupCall['creator']}"
                                                    : "https://ui-avatars.com/api/?name=${groupCall['creator']}",
                                              ),
                                            ),
                                            Text(
                                              groupCall['creator'] ?? '',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 100,),
                                            Container(
                                              width: 75,
                                              height: 27.5,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFF7E9FE).withOpacity(isCurrentTimeValid ? 1.0 : 0.5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                                child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Join Now",
                                                    style: TextStyle(
                                                      color: Color(0xFF270E50).withOpacity(isCurrentTimeValid ? 1.0 : 0.5),
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox()
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(child: Text("TIDAK ADA LIVE YANG BERLANGSUNG", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.5)),),);
                    }
                  }
                )
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

  void jumpToGroupCall(BuildContext context,
      {required String conferenceID}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoConferencePage(conferenceID: conferenceID, user: widget.user,),
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
        "message": "Has Scheduled a Group Call For ${_tanggalMulaiController.text} at ${_waktuMulaiController.text}",
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
