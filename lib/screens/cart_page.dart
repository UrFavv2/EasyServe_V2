import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Order", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ၁။ မှာထားတဲ့ item များစာရင်း
          Expanded(
            child: ListView.builder(
              itemCount: 3, // နမူနာ ၃ ခုပြထားမယ်
              itemBuilder: (context, index) {
                return _buildCartItem();
              },
            ),
          ),

          // ၂။ ငွေရှင်းမယ့် အပိုင်း (Bill Summary)
          _buildBillSummary(),
        ],
      ),
    );
  }

  // မှာထားတဲ့ ဟင်းပွဲ တစ်ခုချင်းစီရဲ့ UI
  Widget _buildCartItem() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.fastfood, color: Colors.orange),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fried Rice", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("4,500 Ks", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            // အရေအတွက် တိုး/လျှော့ လုပ်တဲ့ ခလုတ်များ
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.remove_circle_outline, color: Colors.red)),
                const Text("1", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // အောက်ခြေက စုစုပေါင်းကျသင့်ငွေနဲ့ Confirm လုပ်မယ့်ခလုတ်
  Widget _buildBillSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount", style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text("13,500 Ks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // မှာယူမှုကို အတည်ပြုမယ့် logic (ဥပမာ- Database ထဲထည့်တာမျိုး)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("CONFIRM ORDER", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}