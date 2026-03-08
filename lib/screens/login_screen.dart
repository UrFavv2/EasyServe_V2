import 'package:flutter/material.dart';
import '../services/database_service.dart'; 
import './waiter/table_selection_screen.dart'; 
import './kitchen/kitchen_main_screen.dart'; 
import './admin/dashboard_screen.dart'; // 🌟 Admin UI လမ်းကြောင်းအသစ်

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pin = "";
  bool isLoading = false;

  void _onKeyPress(String value) async {
    if (isLoading) return; 

    setState(() {
      if (pin.length < 4) {
        pin += value;
      }
    });

    if (pin.length == 4) {
      setState(() => isLoading = true);
      
      try {
        final staff = await DatabaseService().loginWithPin(pin);

        if (staff != null) {
          String role = staff['role'].toString().toLowerCase();
          String name = staff['name'];

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Welcome, $name!"), backgroundColor: Colors.green),
            );

            // 🔥 Role အလိုက် Screen ခွဲပို့ခြင်း
            if (role == 'kitchen') {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const KitchenMainScreen())
              );
            } else if (role == 'admin') {
              // 🌟 Admin အတွက် Dashboard ဆီသို့ ပို့ဆောင်ခြင်း
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const AdminDashboard())
              );
            } else {
              // Default ကို Waiter အဖြစ် သတ်မှတ်ထားပါတယ်
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TableSelectionScreen()),
              );
            }
          }
        } else {
          setState(() {
            pin = ""; 
            isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid PIN! Please try again."), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false;
          pin = "";
        });
        debugPrint("Login Error: $e");
      }
    }
  }

  void _onClear() {
    setState(() {
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "EasyServe",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 10),
            const Text("Enter Staff PIN to Login", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < pin.length ? Colors.orange : Colors.grey[300],
                    border: Border.all(color: index < pin.length ? Colors.orange : Colors.transparent),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 20),
            if (isLoading) 
              const SizedBox(height: 40, child: CircularProgressIndicator(color: Colors.orange))
            else 
              const SizedBox(height: 40),

            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  for (var i = 1; i <= 9; i++) _buildNumberButton(i.toString()),
                  const SizedBox.shrink(),
                  _buildNumberButton("0"),
                  _buildDeleteButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String value) {
    return InkWell(
      onTap: () => _onKeyPress(value),
      borderRadius: BorderRadius.circular(50),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: _onClear,
      icon: const Icon(Icons.backspace_outlined, size: 28, color: Colors.red),
    );
  }
}