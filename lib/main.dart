import 'package:creditech_capstone_project/firebase_options.dart';
import 'package:creditech_capstone_project/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:creditech_capstone_project/controller/index_nav_provider.dart';
import 'package:creditech_capstone_project/controller/auth_controller.dart';
import 'package:creditech_capstone_project/controller/auth_initialization_provider.dart';
import 'package:creditech_capstone_project/controller/profile_provider.dart';
import 'package:creditech_capstone_project/controller/notification_provider.dart';
import 'package:creditech_capstone_project/controller/upload_provider.dart';
import 'package:creditech_capstone_project/controller/chart_provider.dart';
import 'package:creditech_capstone_project/controller/auth_form_provider.dart';
import 'package:creditech_capstone_project/controller/history_provider.dart';
import 'package:creditech_capstone_project/ui/pages/auth/login_page.dart';
import 'package:creditech_capstone_project/ui/widgets/auth_wrapper.dart';
import 'package:creditech_capstone_project/static/navigation_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        // Core services
        Provider(create: (_) => FirestoreService()),

        // State providers
        ChangeNotifierProvider(create: (_) => IndexNavProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => AuthInitializationProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => UploadProvider()),
        ChangeNotifierProvider(create: (_) => ChartProvider()),
        ChangeNotifierProvider(create: (_) => AuthFormProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Initialize dependencies after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDependencies();
    });
  }

  void _initializeDependencies() {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    // Set up dependencies
    profileProvider.setFirestoreService(firestoreService);
    authController.setProfileProvider(profileProvider);
    
    // Initialize notification provider
    notificationProvider.refreshNotificationState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creditech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),

      initialRoute: NavigationRoute.mainRoute.path,
      routes: {
        NavigationRoute.login.path: (_) => const LoginLandingPage(),
        NavigationRoute.mainRoute.path: (_) => const AuthWrapper(),
      },
    );
  }
}
