import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import './screens/kitchen/kitchen_main_screen.dart';
import './screens/admin/dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uhrmrrquagfedjixqxzf.supabase.co',
    anonKey: 'sb_publishable_c2uIcemiPQlz4cz_oIlTIg_RSDxlf4e',
  );

  runApp(const EasyServeApp());
}


class EasyServeApp extends StatelessWidget {
  const EasyServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyServe POS',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}