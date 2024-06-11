import 'package:flutter/material.dart';
import 'home.dart';
import 'discovery.dart';
import 'notification.dart';
import 'profile.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  void _onTabTapped(int index) {
    widget.onTap(index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DiscoveryScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotificationScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: _onTabTapped,
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(widget.currentIndex == 0 ? Icons.home : Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Discovery',
          icon: Icon(widget.currentIndex == 1 ? Icons.view_sidebar : Icons.view_sidebar_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Notification',
          icon: Icon(widget.currentIndex == 2 ? Icons.notifications : Icons.notifications_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(widget.currentIndex == 3 ? Icons.person : Icons.person_outline),
        ),
      ],
      unselectedLabelStyle: const TextStyle(
        fontSize: 10,
      ),
      selectedLabelStyle: const TextStyle(
        fontSize: 10,
      ),
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.deepPurple,
      showUnselectedLabels: true,
      selectedFontSize: 0,
      unselectedFontSize: 0,
    );
  }
}
