import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  Function updateIndex;
  NavBar({required this.updateIndex});

  @override
  State<NavBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavBar> {
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.15, right: width * 0.15, bottom: height * 0.035),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BottomNavigationBar(
          currentIndex: currentTabIndex,
          selectedIconTheme: const IconThemeData(color: Color(0xFFFF667E)),
          unselectedIconTheme: const IconThemeData(color: Colors.white),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.black.withOpacity(0.6),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "", tooltip: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search),label: "", tooltip: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.messenger_rounded),label: "", tooltip: 'Message'),
            
          ],
          onTap: (index) {
            widget.updateIndex(index:index);
            setState(() {
              currentTabIndex = index;
            });
          },
        ),
      ),
    );
  }
}
