import 'package:creditech_capstone_project/controller/index_nav_provider.dart';
import 'package:creditech_capstone_project/ui/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IndexNavProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: switch (value.indexBottomNavBar) {
            // Add more items in bottom navbar
            1 => Placeholder(), // change this into a working page
            _ => HomePage(),
          },
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
            onTap: (index) {
              context.read<IndexNavProvider>().setIndexBottomNavBar = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
                tooltip: "Home",
              ),

              // Add more items in bottom navbar
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Setting",
                tooltip: "Setting",
              ),
            ],
          ),
        );
      },
    );
  }
}
