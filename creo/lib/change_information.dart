import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

class ChangeInformationScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  const ChangeInformationScreen({super.key, required this.user});

  @override
  ChangeInformationScreenState createState() => ChangeInformationScreenState();
}

class ChangeInformationScreenState extends State<ChangeInformationScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _informationController = TextEditingController();

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
              // MaterialPageRoute(builder: (context) => const Screen(currentIndex: 3,))
              MaterialPageRoute(builder: (context) => ProfileScreen())
            );
          },
        )
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Information',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                )
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _informationController,
                  decoration: InputDecoration(
                    hintText: 'New Information',
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  updateInformation(widget.user!["uid"]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Informasi Telah Diperbaharui'))
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.deepPurple,
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width, 40),
                  )
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateInformation(String uid) async {
    if(_informationController.text.isNotEmpty){
      try{
        await firestore.collection("user").doc(uid).update({
          "information": _informationController.text
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Informasi Telah Diperbaharui'))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Terjadi Kesalahan, Tidak Dapat Update Profile'))
        );
        print(e.hashCode);
      }    
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Informasi Masih Kosong'))
      );
    }
  }
}