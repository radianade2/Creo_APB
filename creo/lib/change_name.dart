import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

class ChangeNameScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  const ChangeNameScreen({super.key, required this.user});

  @override
  ChangeNameScreenState createState() => ChangeNameScreenState();
}

class ChangeNameScreenState extends State<ChangeNameScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();

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
              MaterialPageRoute(builder: (context) => ProfileScreen())
            );
          },
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Edit Name',
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
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                  updateName(widget.user!["uid"]);
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
              SizedBox(height: 80,),
              Center(
                child: Text(
                  'Edit Username',
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
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
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
                  updateUsername(widget.user!["uid"]);
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

  Future<void> updateName(String uid) async {
    if(_namaController.text.isNotEmpty && _namaController.text.length >= 4){
      try{
        await firestore.collection("user").doc(uid).update({
          "name": _namaController.text
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Nama Telah Diperbaharui'))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Terjadi Kesalahan, Tidak Dapat Update Profile'))
        );
        print(e.hashCode);
      }    
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Nama Harus Lebih Dari 3 Huruf'))
      );
    }
  }

  Future<void> updateUsername(String uid) async {
    if(_usernameController.text.isNotEmpty && _usernameController.text.length >= 6){

      final usernameQuery = await firestore.collection("user").where("username", isEqualTo: _usernameController.text).get();

      if (usernameQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Username Telah Digunakan, Coba Username Lain'))
        );
      } else {
        try{
          await firestore.collection("user").doc(uid).update({
            "username": _usernameController.text
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Username Telah Diperbaharui'))
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Terjadi Kesalahan, Tidak Dapat Update Profile'))
          );
          print(e.hashCode);
        }  
      }  
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Username Harus Lebih Dari 5 Huruf'))
      );
    }
  }
}