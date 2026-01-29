import 'package:flutter/material.dart';

class KitchenKdsScreen extends StatefulWidget {
  const KitchenKdsScreen({super.key});

  @override
  State<KitchenKdsScreen> createState() => _KitchenKdsScreenState();
}

class _KitchenKdsScreenState extends State<KitchenKdsScreen> {
  // အော်ဒါစာရင်းကို List အနေနဲ့ သတ်မှတ်လိုက်ပါတယ်။
  // တကယ်တမ်းမှာ ဒါက Database/Backend ကနေ လာမှာပါ။
  List<Map<String, dynamic>> allOrders = [
    {"table": "10", "time": "15:02", "isUrgent": true},
    {"table": "11", "time": "04:20", "isUrgent": false},
    {"table": "12", "time": "08:15", "isUrgent": false},
    {"table": "14", "time": "10:00", "isUrgent": false},
    {"table": "15", "time": "12:30", "isUrgent": false},
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
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text("ORDERS: ${allOrders.length}", // အော်ဒါအရေအတွက်ကို ပြောင်းလဲပေးမယ်
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          )
        ],
      ),
      body: allOrders.isEmpty
          ? const Center(child: Text("No Orders Left!", style: TextStyle(color: Colors.white70, fontSize: 20)))
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: allOrders.length,
              itemBuilder: (context, index) {
                return _buildRowOrderCard(index);
              },
            ),
    );
  }

  Widget _buildRowOrderCard(int index) {
    final order = allOrders[index];
    bool isUrgent = order['isUrgent'];

    final List<Map<String, dynamic>> orderItems = [
      {"name": "Special Fried Rice", "qty": 2, "img": "assets/images/food1.jpg"},
      {"name": "Spicy Ramen", "qty": 1, "img": "assets/images/food2.jpg"},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ၁။ Sidebar
            Container(
              width: 110,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUrgent ? Colors.red.shade700 : const Color(0xFF333333),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("TABLE", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text("${order['table']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
                  const SizedBox(height: 8),
                  const Icon(Icons.timer, color: Colors.white70, size: 18),
                  Text("${order['time']}", style: const TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),

            // ၂။ ဟင်းပွဲစာရင်း
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: orderItems.map((item) {
                    return _foodItemRow(img: item['img'], qty: item['qty'], name: item['name']);
                  }).toList(),
                ),
              ),
            ),

            // ၃။ DONE Button
            Container(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 🌟 DONE နှိပ်လိုက်ရင် List ထဲကနေ ဖယ်ထုတ်လိုက်ပါမယ်
                    setState(() {
                      allOrders.removeAt(index);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 70),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("DONE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodItemRow({required String img, required int qty, required String name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(img, width: 40, height: 40, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(width: 40, height: 40, color: Colors.grey[200], child: const Icon(Icons.fastfood, color: Colors.grey, size: 20))),
          ),
          const SizedBox(width: 15),
          Text("$qty x", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFCC5500))),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}