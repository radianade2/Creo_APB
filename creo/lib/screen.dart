// import 'package:flutter/material.dart';
// import 'home.dart';
// import 'transaction.dart';
// import 'profile.dart';
// import 'discovery.dart';

// class Screen extends StatefulWidget {
//   final int currentIndex;
  
//   const Screen({Key? key, this.currentIndex = 0}) : super(key: key);

//   @override
//   ScreenState createState() => ScreenState();
// }

// class ScreenState extends State<Screen> {
//   late int _currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.currentIndex;
//   }

//   List<Widget> body = const [
//     HomeScreen(),
//     TransactionScreen(),
//     DiscoveryScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: body[_currentIndex],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _currentIndex,
//         onTap: (int newIndex) {
//           setState(() {
//             _currentIndex = newIndex;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             label: 'Home',
//             icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined),
//           ),
//           BottomNavigationBarItem(
//             label: 'My Transaction',
//             icon: Icon(_currentIndex == 1 ? Icons.monetization_on : Icons.monetization_on_outlined),
//           ),
//           BottomNavigationBarItem(
//             label: 'Notification',
//             icon: Icon(_currentIndex == 2 ? Icons.notifications : Icons.notifications_outlined),
//           ),
//           BottomNavigationBarItem(
//             label: 'Profile',
//             icon: Icon(_currentIndex == 3 ? Icons.person : Icons.person_outline),
//           ),
//         ],
//         unselectedLabelStyle: const TextStyle(
//           fontSize: 10,
//         ),
//         selectedLabelStyle: const TextStyle(
//           fontSize: 10,
//         ),
//         selectedItemColor: Colors.deepPurple,
//         unselectedItemColor: Colors.deepPurple,
//         showUnselectedLabels: true,
//         selectedFontSize: 0,
//         unselectedFontSize: 0,
//       ),
//     );
//   }

//   void setCurrentIndex(int i) {
//     setState(() {
//       _currentIndex = i;
//     });
//   }
// }