import 'package:flutter/material.dart';
// အောက်က import မှာ 'pos' နေရာမှာ မင်းရဲ့ project နာမည်ကို အစားထိုးပါ
import './screens/splash_screen.dart';
import './screens/kitchen/kitchen_screen.dart';


void main() {
  runApp(const EasyServeApp());
}

class EasyServeApp extends StatelessWidget {
  const EasyServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ညာဘက်အပေါ်က Debug စာတန်းကို ဖျောက်ဖို့
      title: 'EasyServe POS',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true, // Modern ဖြစ်တဲ့ UI style သုံးဖို့
      ),
      // App စဖွင့်တာနဲ့ Login Screen ကို အရင်ပြမယ်
      home: const SplashScreen(),
    );
  }
}