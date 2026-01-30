import 'package:flutter/material.dart';

class KitchenKdsScreen extends StatefulWidget {
  const KitchenKdsScreen({super.key});

  @override
  State<KitchenKdsScreen> createState() => _KitchenKdsScreenState();
}

class _KitchenKdsScreenState extends State<KitchenKdsScreen> {
  List<Map<String, dynamic>> allOrders = [
    {
      "table": "10",
      "time": "15:02",
      "isUrgent": true,
      "items": [
        {"name": "Special Fried Rice", "qty": 2, "notes": ["အစပ်လျှော့", "အသားများများ"]},
        {"name": "Spicy Ramen", "qty": 1, "notes": ["အချိုမထည့်နဲ့"]},
        {"name": "Coca Cola", "qty": 3, "notes": []},
      ]
    },
    {
      "table": "12",
      "time": "08:15",
      "isUrgent": false,
      "items": [
        {"name": "Chicken Curry", "qty": 1, "notes": ["ပါဆယ်ထုပ်ပေးပါ"]},
      ]
    },
    {
      "table": "14",
      "time": "09:00",
      "isUrgent": false,
      "items": [
        {"name": "Fried Noodle", "qty": 2, "notes": ["အသားမပါ"]},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text("KITCHEN CONTROL CENTER",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFFCC5500),
        centerTitle: true,
        elevation: 0,
        // 🌟 Total Orders နှင့် Noti Icon ကို Title အောက်တွင် ထားခြင်း
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: const Color(0xFFCC5500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ဘယ်ဘက်ခြမ်း - Total Orders
                Text(
                  "TOTAL ORDERS: ${allOrders.length}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // ညာဘက်ခြမ်း - Notification Icon with Badge
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.white, size: 26),
                    if (allOrders.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFCC5500), width: 1),
                          ),
                          constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                          child: Text(
                            '${allOrders.length}',
                            style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: allOrders.isEmpty
          ? const Center(child: Text("No Orders Left!", style: TextStyle(color: Colors.white70, fontSize: 20)))
          : ListView.builder(
              scrollDirection: Axis.horizontal, 
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: allOrders.length,
              itemBuilder: (context, index) {
                return _buildOrderColumnCard(index);
              },
            ),
    );
  }

  Widget _buildOrderColumnCard(int index) {
    final order = allOrders[index];
    bool isUrgent = order['isUrgent'];
    List<dynamic> items = order['items'];

    return Container(
      width: 350,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isUrgent ? Colors.red.shade700 : const Color(0xFF333333),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TABLE", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text("${order['table']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.timer, color: Colors.white70, size: 20),
                    Text("${order['time']}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: items.length,
              itemBuilder: (context, itemIndex) {
                final item = items[itemIndex];
                return _foodItemRow(
                  qty: item['qty'],
                  name: item['name'],
                  notes: item['notes'],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  allOrders.removeAt(index);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
              ),
              child: const Text("MARK AS DONE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _foodItemRow({required int qty, required String name, required List<dynamic> notes}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$qty x", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFFCC5500))),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                if (notes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: notes.map((n) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          border: Border.all(color: Colors.orange.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("• $n", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange.shade900)),
                      )).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}