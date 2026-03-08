// lib/kitchen/kitchen_main_screen.dart

import 'package:flutter/material.dart';
import 'kitchen_screen.dart'; // ဖိုင်လမ်းကြောင်း မှန်အောင် စစ်ဆေးပါ
import 'kitchen_stock_screen.dart';

class KitchenMainScreen extends StatefulWidget {
  const KitchenMainScreen({super.key});

  @override
  State<KitchenMainScreen> createState() => _KitchenMainScreenState();
}

class _KitchenMainScreenState extends State<KitchenMainScreen> {
  // လက်ရှိ ရောက်နေတဲ့ Tab Index ကို မှတ်ရန်
  int _selectedIndex = 0;

  // ပြသရမည့် Screen များ (const သုံးထားခြင်းက Performance ကို ပိုကောင်းစေပါတယ်)
  final List<Widget> _screens = [
    const KitchenKdsScreen(),    // Tab 0: Order များပြရန်
    const KitchenStockScreen(),  // Tab 1: ကုန်ပစ္စည်းလက်ကျန် စစ်ရန်
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Status bar အရောင်ကို အမည်းရောင်ထားပြီး UI ကို ပိုသေသပ်အောင် လုပ်ထားပါတယ်
      backgroundColor: const Color(0xFF121212), 
      
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // Bottom Navigation Bar အပိုင်း
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.black,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed, // Icon နှစ်ခုလုံးကို အသေပြထားရန်
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_rounded),
              activeIcon: Icon(Icons.restaurant_menu_rounded, color: Colors.orange),
              label: "ORDERS",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2_rounded, color: Colors.orange),
              label: "STOCK",
            ),
          ],
        ),
      ),
    );
  }
}