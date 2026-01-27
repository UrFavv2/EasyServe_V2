import 'package:flutter/material.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  // နမူနာ အော်ဒါစာရင်းများ
  final List<Map<String, dynamic>> orders = [
    {
      "table": "5",
      "time": "5 mins ago",
      "items": ["Fried Rice x 2", "Chicken Curry x 1"],
      "status": "Pending"
    },
    {
      "table": "2",
      "time": "12 mins ago",
      "items": ["Pad Thai x 1", "Green Tea x 3"],
      "status": "Cooking"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Kitchen အတွက် မျက်စိအေးတဲ့ အရောင်ရင့်
      appBar: AppBar(
        title: const Text("KITCHEN DISPLAY (KDS)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal, // အော်ဒါကတ်ပြားတွေကို ဘေးတိုက်စီမယ်
        padding: const EdgeInsets.all(15),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(orders[index]);
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ကတ်ပြားရဲ့ အပေါ်ပိုင်း (Table No & Time)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: order['status'] == "Cooking" ? Colors.orange : Colors.redAccent,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TABLE ${order['table']}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(order['time'], style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          
          // အော်ဒါစာရင်း
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: (order['items'] as List).length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text("• ${order['items'][i]}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                );
              },
            ),
          ),

          // အောက်ခြေခလုတ် (အော်ဒါပြီးကြောင်း အကြောင်းကြားရန်)
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: order['status'] == "Cooking" ? Colors.green : Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  order['status'] == "Cooking" ? "READY TO SERVE" : "START COOKING",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}