import 'package:flutter/material.dart';
import './waiter/table_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pin = ""; // ရိုက်ထည့်လိုက်တဲ့ PIN ကို သိမ်းထားဖို့

  // နံပါတ်ခလုတ်နှိပ်တဲ့အခါ အလုပ်လုပ်မယ့် Function
  void _onKeyPress(String value) {
    setState(() {
      if (pin.length < 4) { // PIN ကို ၄ လုံးပဲ ကန့်သတ်ထားမယ်
        pin += value;
      }
    });

    // ၄ လုံးပြည့်သွားရင် Logic တစ်ခုခုလုပ်မယ် (ဥပမာ- Table Screen ကိုသွားမယ်)
   if (pin.length == 4) {
  // Table Selection Screen ကို ကူးပြောင်းခြင်း
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const TableSelectionScreen()),
  );
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
            // App Logo သို့မဟုတ် နာမည်
            Text(
              "EasyServe",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 10),
            Text("Enter Staff PIN to Login"),
            SizedBox(height: 40),

            // PIN Display (အစက်ကလေးများ)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < pin.length ? Colors.orange : Colors.grey[300],
                  ),
                );
              }),
            ),
            SizedBox(height: 50),

            // Number Pad
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 40),
                children: [
                  for (var i = 1; i <= 9; i++) _buildNumberButton(i.toString()),
                  _buildEmptySpace(), // နေရာလွတ်
                  _buildNumberButton("0"),
                  _buildDeleteButton(), // ဖျက်တဲ့ခလုတ်
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // နံပါတ်ခလုတ်ပုံစံ
  Widget _buildNumberButton(String value) {
    return TextButton(
      onPressed: () => _onKeyPress(value),
      child: Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: _onClear,
      icon: Icon(Icons.backspace_outlined, size: 28, color: Colors.red),
    );
  }

  Widget _buildEmptySpace() {
    return SizedBox.shrink();
  }
}