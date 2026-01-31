import 'package:flutter/material.dart';
import '../../data/constants.dart'; // 🌟 Shared Data ကို Import လုပ်ပါ

class MenuManager extends StatefulWidget {
  const MenuManager({super.key});

  @override
  State<MenuManager> createState() => _MenuManagerState();
}

class _MenuManagerState extends State<MenuManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("MENU MANAGER", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.orange, size: 30),
            onPressed: () {
              // TODO: ဟင်းပွဲအသစ်ထည့်ရန် Dialog ခေါ်မည်
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // ၁။ Search Bar
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search menu items...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),

          // ၂။ Menu List
          Expanded(
            child: ListView.builder(
              itemCount: sharedMenuList.length,
              itemBuilder: (context, index) {
                final item = sharedMenuList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset('assets/images/table img.jpg', width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("5,500 MMK", style: TextStyle(color: Colors.orange)),
                    
                    // 🌟 Availability Switch (အဓိက အပိုင်း)
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("In Stock", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Switch(
                          value: item['isAvailable'],
                          activeColor: Colors.orange,
                          onChanged: (bool value) {
                            setState(() {
                              item['isAvailable'] = value; // 🌟 Shared Data ကို တိုက်ရိုက် ပြောင်းလိုက်တာပါ
                            });
                            // ဝိတ်တာတွေဆီ ချက်ချင်း Feedback ပေးဖို့ သတိပေးချက်
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${item['name']} is now ${value ? 'Available' : 'Sold Out'}"),
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}