import 'package:flutter/material.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/ui/home_page.dart';
import 'package:story_app/ui/profile_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _bottomNavIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.add_box_outlined),
      label: 'Upload',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.video_collection_outlined),
      label: 'Reels',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  final List<Widget> _listWidget = [
    const HomePage(),
    const Placeholder(),
    const Placeholder(),
    const Placeholder(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: (selected) {
          if (selected == 2) {
            context.goNamed(Routes.upload);
          } else if (selected == 0 || selected == 4) {
            setState(() {
              _bottomNavIndex = selected;
            });
          }
        },
        iconSize: 28,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
