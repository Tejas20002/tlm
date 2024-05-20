import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlm/src/admin/provider/loader_provider.dart';
import 'package:tlm/src/screens/login/login_screen.dart';
import 'package:tlm/src/utils/sharedpreference/application.dart';
import 'package:tlm/src/utils/sharedpreference/shared_preferences.dart';
import 'package:tlm/src/utils/sharedpreference/shared_preferences_keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Application.sp = await SpUtil.getInstance();
  clearAllLogoutPreferences();
  clearAllPreferences();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoaderProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TLM',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Segoe',
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
