import 'package:flutter/material.dart';
import 'dart:async';
import './login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Burnt Orange background color
      backgroundColor:  Colors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // အပေါ်မှာ ပေးထားတဲ့ Logo ပုံကို အသုံးပြုခြင်း
            Image.asset(
              'assets/images/logo.png', // Logo ဖိုင်လမ်းကြောင်း
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // Title: EasyServe
            const Text(
              "EasyServe",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins', // Font သွင်းထားရင် သုံးလို့ရပါတယ်
              ),
            ),
            // Subtitle: POS System
            const Text(
              "POS System",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                letterSpacing: 4, // စာသားအကွာအဝေးကို နည်းနည်းချဲ့ထားပါတယ်
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 40),
            // အောက်နားမှာ Loading အဝိုင်းလေး
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}