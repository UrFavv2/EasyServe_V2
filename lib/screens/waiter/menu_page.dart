import 'package:flutter/material.dart';
import './cart_page.dart';
import '../../data/constants.dart'; // 🌟 Shared Data ကို Import လုပ်ပါ

class MenuPage extends StatefulWidget {
  final String tableNumber;
  const MenuPage({super.key, required this.tableNumber});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> categories = ["Popular", "Main Course", "Appetizers", "Drinks", "Desserts"];
  String selectedCategory = "Popular";

  Map<String, int> cart = {}; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("TABLE ${widget.tableNumber} - MENU", 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFCC5500),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCategoryList(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              // 🌟 sharedMenuList ရဲ့ length အတိုင်း ပြောင်းလိုက်ပါပြီ
              itemCount: sharedMenuList.length, 
              itemBuilder: (context, index) {
                return _buildMenuCard(index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: cart.isNotEmpty ? _buildCheckoutBar() : null,
    );
  }

  Widget _buildCategoryList() {
    return Container(
      height: 60,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategory == categories[index];
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = categories[index]),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFCC5500) : Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(int index) {
    // 🌟 sharedMenuList ထဲကနေ Data ယူပါမယ်
    final item = sharedMenuList[index];
    String foodName = item['name'];
    bool isAvailable = item['isAvailable'] ?? true; // Stock ရှိ/မရှိ စစ်ခြင်း
    int count = cart[foodName] ?? 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Stack( // 🌟 Sold Out Overlay အတွက် Stack သုံးထားပါတယ်
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Opacity( // Stock မရှိရင် ပုံကို မှိန်လိုက်မယ်
                    opacity: isAvailable ? 1.0 : 0.5,
                    child: Image.asset('assets/images/table img.jpg', fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(foodName, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                        color: isAvailable ? Colors.black : Colors.grey,
                        decoration: isAvailable ? null : TextDecoration.lineThrough,
                      )),
                    Text("5,500 MMK", 
                      style: TextStyle(
                        color: isAvailable ? const Color(0xFFCC5500) : Colors.grey, 
                        fontWeight: FontWeight.bold
                      )),
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (count > 0)
                          _qtyButton(Icons.remove, () {
                            setState(() {
                              if (cart[foodName]! > 1) cart[foodName] = cart[foodName]! - 1;
                              else cart.remove(foodName);
                            });
                          }, isAvailable),
                        if (count > 0) Text("$count", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        // 🌟 Stock မရှိရင် Add Button ကိုပါ ပိတ်ထားမယ်
                        _qtyButton(Icons.add, () {
                          if (isAvailable) {
                            setState(() => cart[foodName] = count + 1);
                          }
                        }, isAvailable),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // 🌟 Sold Out Overlay Label
          if (!isAvailable)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "SOLD OUT",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 🌟 isEnabled parameter ထပ်တိုးပြီး Button အရောင်ကို ထိန်းလိုက်ပါတယ်
  Widget _qtyButton(IconData icon, VoidCallback onTap, bool isEnabled) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFFCC5500) : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCheckoutBar() {
    int totalItems = cart.values.fold(0, (sum, item) => sum + item);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(cart: cart, tableNumber: widget.tableNumber),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCC5500),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white),
            const SizedBox(width: 10),
            Text("VIEW ORDER ($totalItems ITEMS)", 
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}