import 'package:creditech_capstone_project/controller/index_nav_provider.dart';
import 'package:creditech_capstone_project/ui/pages/home_page/home_page.dart';
import 'package:creditech_capstone_project/ui/pages/analytics_page/analytics_page.dart';
import 'package:creditech_capstone_project/ui/pages/history_page/history_page.dart';
import 'package:creditech_capstone_project/ui/pages/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pages = const [
    HomePage(),
    AnalyticsPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final index = context.watch<IndexNavProvider>().indexBottomNavBar;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: IndexedStack(index: index, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F0F10),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        currentIndex: index,
        onTap: (i) => context.read<IndexNavProvider>().setIndexBottomNavBar = i,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
            tooltip: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            activeIcon: Icon(Icons.history_edu),
            label: 'History',
            tooltip: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }
}