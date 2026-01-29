import 'package:flutter/material.dart';

class KitchenKdsScreen extends StatelessWidget {
  const KitchenKdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text("KITCHEN CONTROL CENTER",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFFCC5500),
        centerTitle: true,
        actions: const [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text("ORDERS: 5", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75, // Aspect Ratio ကို နည်းနည်းပြန်ညှိထားပါတယ်
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return _buildProfessionalOrderCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildProfessionalOrderCard(int index) {
    bool isUrgent = index == 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isUrgent ? Colors.red.shade700 : const Color(0xFF333333),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                // Flexible သုံးလိုက်ရင် Overflow မဖြစ်တော့ပါဘူး
                Expanded(
                  child: Text("TBL-${index + 10}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const Icon(Icons.timer, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text(isUrgent ? "15:02" : "04:20",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _foodItemRow(img: 'assets/images/food1.jpg', qty: 2, name: "Special Fried Rice"),
                const Divider(height: 10),
                _foodItemRow(img: 'assets/images/food2.jpg', qty: 1, name: "Spicy Ramen"),
                const Divider(height: 10),
                _foodItemRow(img: 'assets/images/food3.jpg', qty: 3, name: "Iced Lemon Tea"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("MARK DONE", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _foodItemRow({required String img, required int qty, required String name}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(img, width: 35, height: 35, fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => 
              Container(width: 35, height: 35, color: Colors.grey[200], child: const Icon(Icons.fastfood, size: 20, color: Colors.grey)),
          ),
        ),
        const SizedBox(width: 8),
        Text("$qty x", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFCC5500))),
        const SizedBox(width: 6),
        // Flexible သုံးပြီး နာမည်ရှည်ရင် ... နဲ့ ဖြတ်ပစ်ပါမယ်
        Expanded(
          child: Text(name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
        ),
      ],
    );
  }
}