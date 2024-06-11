import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'forget_success.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_back_ios),
                    Text('Back', style: TextStyle(color: Color(0xFF350A49),fontSize: 16, fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              const Text(
                'Don\'t be sad',
                style: TextStyle(fontSize: 22.0, fontFamily: 'Roboto', fontWeight: FontWeight.w700,),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Change your password here',
                style: TextStyle(fontSize: 14.0, fontFamily: 'Roboto', fontWeight: FontWeight.w600, letterSpacing: 0.50,),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                width: 130, height: 306,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/forget1.png'),
                    fit: BoxFit.contain,
                  )
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15, bottom: 5), child: Text('Your Email', style: TextStyle(fontWeight: FontWeight.w600),),),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  sendEmail();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetSuccessScreen(email: _emailController.text,)),
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: const Text('Telah terkirim'))
                  // );
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
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendEmail() async {
    if(_emailController.text.isNotEmpty){
      try{
        await auth.sendPasswordResetEmail(email: _emailController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Tidak Dapat Mengirim Email Reset Password'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Silahkan Isi Email'))
      );
    }
  }
}