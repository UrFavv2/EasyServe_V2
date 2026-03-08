import 'package:flutter/material.dart';
import '../../services/database_service.dart'; // ဘရိုရဲ့ DatabaseService Path ကို စစ်ပေးပါ

class KitchenKdsScreen extends StatefulWidget {
  const KitchenKdsScreen({super.key});

  @override
  State<KitchenKdsScreen> createState() => _KitchenKdsScreenState();
}

class _KitchenKdsScreenState extends State<KitchenKdsScreen> {
  final DatabaseService db = DatabaseService();

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
        // Header မှာ Total Orders ပြဖို့ StreamBuilder တစ်ခုထပ်သုံးထားပါတယ်
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: db.getKitchenOrdersStream(),
            builder: (context, snapshot) {
              int count = snapshot.data?.length ?? 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: const Color(0xFFCC5500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("TOTAL ORDERS: $count",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    _buildNotificationIcon(count),
                  ],
                ),
              );
            }
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: db.getKitchenOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFCC5500)));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
              child: Text("No Orders Left! 👨‍🍳", 
                style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold))
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _buildOrderColumnCard(orders[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderColumnCard(Map<String, dynamic> order) {
    int orderId = order['id'];
    String tableNum = order['tables']?['table_number']?.toString() ?? order['table_id'].toString();
    String time = order['created_at'] != null ? order['created_at'].toString().substring(11, 16) : "--:--";
    bool isUrgent = order['priority'] == 'High'; // Database မှာ priority column ရှိရင် သုံးနိုင်ပါတယ်

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
          // Card Header
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
                    Text(tableNum, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.timer, color: Colors.white70, size: 20),
                    Text(time, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),

          // Order Items List with Stock Check
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: db.fetchOrderItemsWithNames(orderId),
              builder: (context, itemSnapshot) {
                if (!itemSnapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final items = itemSnapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    // Database ထဲက menu_items table ရဲ့ is_available column ကို စစ်ပါတယ်
                    bool isAvailable = item['menu_items']?['is_available'] ?? true;

                    return _foodItemRow(
                      qty: item['quantity'],
                      name: item['menu_items']?['name'] ?? "Unknown",
                      notes: item['notes'] != null ? [item['notes']] : [],
                      isAvailable: isAvailable,
                    );
                  },
                );
              },
            ),
          ),

          // Mark as Done Button
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () async {
                await db.completeOrder(orderId);
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

  Widget _foodItemRow({required int qty, required String name, required List<dynamic> notes, required bool isAvailable}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$qty x", 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 22, 
              color: isAvailable ? const Color(0xFFCC5500) : Colors.grey,
            )),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name, 
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: isAvailable ? Colors.black87 : Colors.grey,
                    decoration: isAvailable ? null : TextDecoration.lineThrough,
                  )),
                
                if (!isAvailable)
                  const Text("SOLD OUT IN STOCK", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),

                if (notes.isNotEmpty && notes[0] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: notes.map((n) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.yellow.shade100 : Colors.grey.shade200,
                          border: Border.all(color: isAvailable ? Colors.orange.shade300 : Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("• $n", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isAvailable ? Colors.orange.shade900 : Colors.grey.shade600)),
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

  Widget _buildNotificationIcon(int count) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.notifications_active, color: Colors.white, size: 26),
        if (count > 0)
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
                '$count',
                style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}