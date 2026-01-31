import 'package:flutter/material.dart';
import '../../data/constants.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("ORDER HISTORY", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: orderHistory.isEmpty 
          ? const Center(child: Text("No orders found")) 
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return Container(
                  // 🌟 ပြင်လိုက်တဲ့နေရာ: EdgeInsets.only သုံးရပါမယ်
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        // 🌟 ပြင်လိုက်တဲ့နေရာ: withValues သုံးတာ ပိုစိတ်ချရပါတယ်
                        color: Colors.black.withValues(alpha: 0.05), 
                        blurRadius: 10
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order['orderId'] ?? 'N/A', 
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                            Text(order['time'] ?? '', 
                              style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const Divider(height: 25),

                        Text(order['table'] ?? 'Unknown', 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(order['items'] ?? '', 
                          style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                        const Divider(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Total Amount", 
                                    style: TextStyle(color: Colors.grey, fontSize: 11)),
                                  Text("${order['total']} MMK", 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.orange)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(order['status'] ?? 'Completed', 
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}