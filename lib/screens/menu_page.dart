import 'package:flutter/material.dart';
import './cart_page.dart';

class MenuPage extends StatefulWidget {
  final String tableNumber;
  const MenuPage({super.key, required this.tableNumber});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = "All"; // လက်ရှိရွေးထားတဲ့ Category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Table - ${widget.tableNumber}", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // ၁။ Category Selector
          _buildCategoryBar(),

          // ၂။ Menu Items Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // တစ်တန်းမှာ ၂ ခု
                childAspectRatio: 0.75, // Card ရဲ့ အချိုးအစား
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 6, // နမူနာ ၆ ခုပြထားမယ်
              itemBuilder: (context, index) {
                return _buildMenuCard(index);
              },
            ),
          ),
        ],
      ),
      
      // ၃။ အောက်ခြေက Cart Summary Bar
      bottomNavigationBar: _buildBottomCartBar(),
    );
  }

  // Category ရွေးတဲ့ Bar
  Widget _buildCategoryBar() {
    List<String> categories = ["All", "Food", "Drinks", "Snacks", "Dessert"];
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
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ဟင်းပွဲ Card တစ်ခုချင်းစီ
  Widget _buildMenuCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ဟင်းပွဲပုံ (လောလောဆယ် Placeholder)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: const Center(child: Icon(Icons.fastfood, size: 50, color: Colors.orange)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Sample Dish", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                const Text("5,500 Ks", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // အောက်ခြေက Order Summary
  Widget _buildBottomCartBar() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total: 2 Items", style: TextStyle(color: Colors.grey)),
              Text("11,000 Ks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
          ElevatedButton.icon(
           onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CartPage()),
  );
},
            icon: const Icon(Icons.shopping_basket, color: Colors.white),
            label: const Text("VIEW ORDER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}