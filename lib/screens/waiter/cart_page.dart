import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final Map<String, int> cart; // Menu Page ကနေ ပါလာမယ့် အော်ဒါစာရင်း
  final String tableNumber;

  const CartPage({super.key, required this.cart, required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    // စုစုပေါင်း ကျသင့်ငွေကို တွက်ချက်ခြင်း (ဥပမာ ဈေးနှုန်း ၅၀၀၀ နဲ့ မြှောက်ထားပါတယ်)
    int totalPrice = cart.values.fold(0, (sum, qty) => sum + (qty * 5000));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Confirm Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFCC5500),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // စားပွဲနံပါတ် ပြကွက်
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: const Color(0xFFCC5500).withOpacity(0.1),
            child: Text("Table Number: $tableNumber", 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFCC5500))),
          ),

          // မှာထားတဲ့ ဟင်းပွဲစာရင်း
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                String foodName = cart.keys.elementAt(index);
                int qty = cart.values.elementAt(index);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFCC5500),
                    child: Text(qty.toString(), style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("5,000 MMK"),
                  trailing: Text("${qty * 5000} MMK", style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),

          // စုစုပေါင်း ငွေပမာဏနဲ့ Confirm Button
          _buildSummarySection(totalPrice, context),
        ],
      ),
    );
  }

  Widget _buildSummarySection(int totalPrice, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("$totalPrice MMK", 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFCC5500))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showSuccessDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("SEND TO KITCHEN", 
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text("Order has been sent to the kitchen successfully!", textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to Menu
              Navigator.pop(context); // Back to Table Selection
            },
            child: const Center(child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }
}