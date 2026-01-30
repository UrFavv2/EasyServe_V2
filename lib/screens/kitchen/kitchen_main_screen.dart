// lib/kitchen/kitchen_main_screen.dart

import 'package:flutter/material.dart';
import './kitchen_screen.dart'; // သင့်ဖိုင်လမ်းကြောင်းအလိုက် စစ်ဆေးပါ
import 'kitchen_stock_screen.dart';

class KitchenMainScreen extends StatefulWidget {
  const KitchenMainScreen({super.key});

  @override
  State<KitchenMainScreen> createState() => _KitchenMainScreenState();
}

class _KitchenMainScreenState extends State<KitchenMainScreen> {
  // လက်ရှိ ရောက်နေတဲ့ Tab Index ကို မှတ်ရန်
  int _selectedIndex = 0;

  // ပြသရမည့် Screen များ
  final List<Widget> _screens = [
    const KitchenKdsScreen(),    // Tab 0
    const KitchenStockScreen(),  // Tab 1
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title မပါတော့တဲ့အတွက် AppBar ကို ဖြုတ်လိုက်ပါသည်
      // အကယ်၍ Status bar အရောင်အတွက်ပဲ လိုချင်ရင် empty AppBar သုံးနိုင်သည်
      
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // Icon နှစ်ခုကို အောက်ခြေ (Bottom) တွင် ထားခြင်း
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "ORDERS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: "STOCK",
          ),
        ],
      ),
    );
  }
}