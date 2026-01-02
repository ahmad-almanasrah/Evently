import 'package:evently/presentation/QrJoinScanner.dart';
import 'package:evently/presentation/explore/feed.dart';
import 'package:evently/presentation/home/friend_search.dart';
import 'package:evently/presentation/home/home.dart';
import 'package:evently/presentation/profile/profile.dart';
// import 'package:evently/presentation/home/qr_join_scanner.dart'; // ✅ Import Scanner
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomeLayout({super.key, required this.toggleTheme});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color mainColor = theme.primaryColor;
    final Color bgColor = theme.scaffoldBackgroundColor;
    final Color unselectedColor = theme.iconTheme.color!.withOpacity(0.5);

    // ✅ 1. ADD SCANNER TO TABS LIST (Total 5 Tabs)
    final List<Widget> tabs = [
      const Home(),
      const FeedScreen(),
      const QrJoinScanner(), // <--- The Scanner Tab
      const FindFriendsScreen(),
      Profile(toggleTheme: widget.toggleTheme),
    ];

    return Scaffold(
      // ✅ Using IndexedStack is fine now if the app isn't freezing
      body: IndexedStack(index: _currentIndex, children: tabs),

      // ❌ REMOVED FloatingActionButton (Since it's a tab now)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: bgColor,
          elevation: 0,
          selectedItemColor: mainColor,
          unselectedItemColor: unselectedColor,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,

          // ✅ 2. ADD SCANNER ICON TO ITEMS LIST
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            // --- NEW SCANNER ITEM ---
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              activeIcon: Icon(Icons.qr_code_scanner),
              label: 'Scan',
            ),
            // ------------------------
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              activeIcon: Icon(Icons.group),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
