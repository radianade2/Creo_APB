import 'package:creo/login.dart';
import 'package:flutter/material.dart';

class ChangeSuccessScreen extends StatelessWidget {
  const ChangeSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Your Profile\nHas Been Changed',
                  style: TextStyle(fontSize: 22.0, fontFamily: 'Roboto', fontWeight: FontWeight.w700,),
                  textAlign: TextAlign.center,
                ),
                const Padding(padding: EdgeInsets.only(top: 50)),
                Container(
                  width: 207, height: 268,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/forget4.png'),
                      fit: BoxFit.contain,
                    )
                  ),
                ),
                const SizedBox(height: 50.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}