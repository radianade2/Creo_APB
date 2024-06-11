import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaftarCreatorScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  const DaftarCreatorScreen({super.key, required this.user});

  @override
  _DaftarCreatorScreenState createState() => _DaftarCreatorScreenState();
}

class _DaftarCreatorScreenState extends State<DaftarCreatorScreen> {
  final _alasanController = TextEditingController();
  final _informasiController = TextEditingController();
  final _roleController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
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
              // MaterialPageRoute(builder: (context) => Screen(currentIndex: 3,))
              MaterialPageRoute(builder: (context) => ProfileScreen())
            );
          },
        ),
        title: Text("Form Pengajuan Creator"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thank you for your interest in becoming a creator on Creo. Please complete the form to share your background, expertise, and goals.',
                  style: TextStyle(
                      color: Color(0xFF797979),
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 40,),
                Text(
                  'Alasan Menjadi Creator',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _alasanController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Jelaskan di sini kenapa anda ingin menjadi creator',
                    hintStyle: TextStyle(color: Color(0xFFADB5BD)),
                    fillColor: Colors.grey.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  'Informasi Pribadi Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _informasiController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Jelaskan di sini informasi yang akan ditampilkan pada user',
                    hintStyle: TextStyle(color: Color(0xFFADB5BD)),
                    fillColor: Colors.grey.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  'Role yang Anda Ingin',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _roleController,
                  decoration: InputDecoration(
                    hintText: 'ex. Motivator, Educator, Influencer, etc',
                    hintStyle: TextStyle(color: Color(0xFFADB5BD)),
                    fillColor: Colors.grey.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    daftarCreator(widget.user!["uid"]);
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
        )
      ),
    );
  }

  Future<void> daftarCreator(String uid) async {
    if(_alasanController.text.length > 100 && _informasiController.text.length > 100 && _roleController.text.length > 4){
      try{
        await firestore.collection("user").doc(uid).update({
          "information": _informasiController.text,
          "role": _roleController.text,
          "creator": true
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Request Telah Dikirim'))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Terjadi Kesalahan, Tidak Dapat Mengirim Request'))
        );
        print(e.hashCode);
      }  
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Alasan / Informasi Harus Lebih Dari 50 Huruf'))
      );
    }
  }
}