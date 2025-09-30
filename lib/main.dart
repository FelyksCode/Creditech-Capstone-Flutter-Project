import 'package:creditech_capstone_project/controller/index_nav_provider.dart';
import 'package:creditech_capstone_project/static/navigation_route.dart';
import 'package:creditech_capstone_project/ui/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
        // Add more Providers here
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Creditech",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),

      home: MainPage(), // Remove this when developing Login page
      // Uncomment this when developing Login before Getting into Home Page
      // initialRoute: NavigationRoute.mainRoute.name,
      // routes: {
      //   NavigationRoute.mainRoute.name: (context) => const MainPage(),
      //   // Add more routes here
      // },
    );
  }
}
