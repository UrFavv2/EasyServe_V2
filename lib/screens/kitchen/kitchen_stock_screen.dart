import 'package:flutter/material.dart';

class KitchenStockScreen extends StatefulWidget {
  const KitchenStockScreen({super.key});

  @override
  State<KitchenStockScreen> createState() => _KitchenStockScreenState();
}

class _KitchenStockScreenState extends State<KitchenStockScreen> {
  // 🌟 Menu List (တကယ့် App မှာ Database ကနေ လာမှာပါ)
  final List<Map<String, dynamic>> _menuItems = [
    {"name": "Fried Rice", "category": "Main Dish", "isAvailable": true},
    {"name": "Grilled Chicken", "category": "Main Dish", "isAvailable": true},
    {"name": "Spaghetti Carbonara", "category": "Pasta", "isAvailable": false},
    {"name": "Coca Cola", "category": "Drinks", "isAvailable": true},
    {"name": "Fresh Lime Juice", "category": "Drinks", "isAvailable": true},
    {"name": "Chocolate Lava Cake", "category": "Dessert", "isAvailable": false},
  ];

  void _toggleAvailability(int index) {
    setState(() {
      _menuItems[index]['isAvailable'] = !_menuItems[index]['isAvailable'];
    });

    // 🌟 ဤနေရာတွင် Server (Firebase) သို့ Update ပို့ပေးရပါမည်
    final itemName = _menuItems[index]['name'];
    final status = _menuItems[index]['isAvailable'] ? "Available" : "Out of Stock";
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$itemName is now $status"),
        duration: const Duration(seconds: 1),
        backgroundColor: _menuItems[index]['isAvailable'] ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Kitchen - Stock Control", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black87,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {}, // Sync data
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Status Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem("Total", _menuItems.length.toString(), Colors.grey),
                    _buildSummaryItem("Available", _menuItems.where((i) => i['isAvailable']).length.toString(), Colors.green),
                    _buildSummaryItem("Sold Out", _menuItems.where((i) => !i['isAvailable']).length.toString(), Colors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Menu Items List
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  bool isAvailable = item['isAvailable'];

                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      leading: CircleAvatar(
                        backgroundColor: isAvailable ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        child: Icon(
                          isAvailable ? Icons.check_circle : Icons.do_not_disturb_on,
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isAvailable ? Colors.black87 : Colors.grey,
                          decoration: isAvailable ? null : TextDecoration.lineThrough,
                        ),
                      ),
                      subtitle: Text(item['category']),
                      trailing: Transform.scale(
                        scale: 1.2,
                        child: Switch(
                          value: isAvailable,
                          activeColor: Colors.green,
                          onChanged: (value) => _toggleAvailability(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String count, Color color) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}