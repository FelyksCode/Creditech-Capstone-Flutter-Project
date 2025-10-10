import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:creditech_capstone_project/controller/index_nav_provider.dart';
import 'package:creditech_capstone_project/ui/pages/auth/login_page.dart';
import 'package:creditech_capstone_project/ui/pages/main_page/main_page.dart';
import 'package:creditech_capstone_project/static/navigation_route.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IndexNavProvider()),
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
      title: 'Creditech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),

      initialRoute: NavigationRoute.login.path,
      routes: {
        NavigationRoute.login.path: (_) => const LoginLandingPage(),
        NavigationRoute.mainRoute.path: (_) => const MainPage(),
      },
    );
  }
}