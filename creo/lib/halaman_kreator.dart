import 'package:flutter/material.dart';

class HalamanKreatorScreen extends StatefulWidget {
  const HalamanKreatorScreen({super.key});

  @override
  HalamanKreatorScreenState createState() => HalamanKreatorScreenState();
}

class HalamanKreatorScreenState extends State<HalamanKreatorScreen> {
  bool showInformation = false;
  bool showReviews = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 50),
        child: Column(
          children: [
            Column(
              children:[
                  const Image(image: AssetImage('assets/kreator1.png'),),
                  const Padding(padding: EdgeInsets.all(5)),
                  const Text('User', style: TextStyle(color: Color(0xFF191919), fontSize: 22, fontFamily: 'Roboto', fontWeight: FontWeight.w700,),),
                  Padding(padding: const EdgeInsets.all(10), 
                    child: SizedBox(
                      width: 65,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlue,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Artist', textAlign: TextAlign.center,style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Quicksand', fontWeight: FontWeight.w700,),),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.lightBlue),
                            ),
                          ),
                        ),
                        child: const Text('Following', style: TextStyle(color: Colors.lightBlue, fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w700,),),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.lightBlue),
                            ),
                          ),
                        ),
                        child: const Text('Message', style: TextStyle(color: Colors.lightBlue, fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w700,),),
                      ),
                    ],
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}