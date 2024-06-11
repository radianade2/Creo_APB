import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

class ChangePhoneScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  const ChangePhoneScreen({super.key, required this.user});

  @override
  ChangePhoneScreenState createState() => ChangePhoneScreenState();
}

class ChangePhoneScreenState extends State<ChangePhoneScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _phoneController = TextEditingController();

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
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                )
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 6,),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Your Number Phone',
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
                  updatePhone(widget.user!["uid"]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Nomor Telepon Telah Diperbaharui'))
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

  Future<void> updatePhone(String uid) async {
    if(_phoneController.text.isNotEmpty){
      try{
        await firestore.collection("user").doc(uid).update({
          "phone": _phoneController.text
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Nomor Telepon Telah Diperbaharui'))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Terjadi Kesalahan, Tidak Dapat Update Profile'))
        );
        print(e.hashCode);
      }    
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Nomor Telepon Masih Kosong'))
      );
    }
  }
}