import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './cart_page.dart';

class MenuPage extends StatefulWidget {
  final String tableNumber;
  final int tableId;

  const MenuPage({super.key, required this.tableNumber, required this.tableId});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final supabase = Supabase.instance.client;
  String selectedCategory = "Tea & Coffee";
  Map<String, Map<String, dynamic>> cart = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("TABLE ${widget.tableNumber} - MENU",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFCC5500),
      ),
      body: Column(
        children: [
          _buildCategoryStream(), 
          Expanded(child: _buildMenuStream()),
        ],
      ),
      bottomNavigationBar: cart.isNotEmpty ? _buildCheckoutBar() : null,
    );
  }

  Widget _buildCategoryStream() {
    return Container(
      height: 65,
      color: Colors.white,
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase.from('categories').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: LinearProgressIndicator());
          final categories = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final catName = categories[index]['name'];
              bool isSelected = selectedCategory == catName;
              return GestureDetector(
                onTap: () => setState(() => selectedCategory = catName),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFCC5500) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(catName, style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuStream() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase.from('menu_with_categories')
          .stream(primaryKey: ['id'])
          .eq('category_name', selectedCategory),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final menuItems = snapshot.data!;

        if (menuItems.isEmpty) return const Center(child: Text("ဟင်းပွဲများ မရှိသေးပါ"));

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) => _buildMenuCard(menuItems[index]),
        );
      },
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> item) {
    String id = item['id'].toString();
    String name = item['item_name'];
    double price = double.parse(item['price'].toString());
    bool isAvailable = item['is_available'] ?? true;
    int count = cart[id]?['quantity'] ?? 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: item['image_url'] != null 
                    ? Image.network(item['image_url'], fit: BoxFit.cover, width: double.infinity)
                    : Image.asset('assets/images/menu.jpg', fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text("${price.toInt()} MMK", style: const TextStyle(color: Color(0xFFCC5500), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (count > 0) _qtyButton(Icons.remove, () {
                          setState(() {
                            if (cart[id]!['quantity'] > 1) {
                              cart[id]!['quantity']--;
                            } else {
                              cart.remove(id);
                            }
                          });
                        }),
                        if (count > 0) Text("$count", style: const TextStyle(fontWeight: FontWeight.bold)),
                        _qtyButton(Icons.add, () {
                          if (isAvailable) {
                            setState(() {
                              cart[id] = {'name': name, 'price': price, 'quantity': count + 1};
                            });
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isAvailable) _soldOutOverlay(),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: const Color(0xFFCC5500), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _soldOutOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black12,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.red,
            child: const Text("SOLD OUT", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  // 🌟 Error Fix လုပ်ထားတဲ့ Checkout Bar
  Widget _buildCheckoutBar() {
    int totalItems = cart.values.fold(0, (sum, item) => sum + (item['quantity'] as int));
    return Container(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC5500)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(
                cart: cart, 
                tableId: widget.tableId, 
                tableNumber: widget.tableNumber
              ),
            ),
          );
        },
        child: Text("VIEW ORDER ($totalItems ITEMS)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}