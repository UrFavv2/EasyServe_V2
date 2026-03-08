import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
  final Map<String, Map<String, dynamic>> cart;
  final int tableId;
  final String tableNumber;

  const CartPage({
    super.key,
    required this.cart,
    required this.tableId,
    required this.tableNumber,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final supabase = Supabase.instance.client;
  bool isOrdering = false;

  // 🌟 Order Confirm လုပ်မည့် Function
  Future<void> _placeOrder() async {
    if (widget.cart.isEmpty) return;

    setState(() => isOrdering = true);

    try {
      // ၁။ စုစုပေါင်း ကျသင့်ငွေကို တွက်ချက်ခြင်း
      double totalAmount = widget.cart.values.fold(
          0, (sum, item) => sum + (item['price'] * item['quantity']));

      // ၂။ 'orders' table ထဲသို့ အချက်အလက်အသစ် သွင်းခြင်း
      final orderResponse = await supabase.from('orders').insert({
        'table_id': widget.tableId,
        'total_amount': totalAmount,
        'status': 'Pending', 
      }).select().single();

      final int newOrderId = orderResponse['id'];

      // ၃။ 'order_items' table ထဲသို့ item များ ထည့်ခြင်း
      final List<Map<String, dynamic>> orderItems = widget.cart.entries.map((entry) {
        return {
          'order_id': newOrderId,
          'item_id': int.parse(entry.key.toString()), 
          'quantity': entry.value['quantity'],
          // ✅ ပြင်ဆင်ပြီး - ဘရိုရဲ့ database ထဲက column နာမည်ဖြစ်တဲ့ 'price_at_order' ကို သုံးထားပါတယ်
          'price_at_order': entry.value['price'], 
        };
      }).toList();

      await supabase.from('order_items').insert(orderItems);

      // ၄။ 🔥 Table Status ကို 'Occupied' သို့ ပြောင်းလဲခြင်း
      await supabase
          .from('tables')
          .update({'status': 'Occupied'}) 
          .eq('id', widget.tableId);

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      debugPrint("Order Error Details: $e"); // Error တက်ရင် terminal မှာ ဖတ်လို့ရအောင်
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Order Failed: ${e.toString()}"), 
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isOrdering = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("Order Successful!", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Table ${widget.tableNumber} is now Occupied.", 
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("BACK TO TABLES", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.cart.values.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text("Table ${widget.tableNumber} - Review Cart", 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFFCC5500),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: widget.cart.isEmpty 
        ? const Center(child: Text("No items in cart"))
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.cart.length,
                  itemBuilder: (context, index) {
                    String key = widget.cart.keys.elementAt(index);
                    var item = widget.cart[key]!;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange.withOpacity(0.1),
                          child: Text("${item['quantity']}x", 
                            style: const TextStyle(color: Color(0xFFCC5500), fontWeight: FontWeight.bold)),
                        ),
                        title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${item['price']} MMK"),
                        trailing: Text("${(item['quantity'] * item['price']).toInt()} MMK", 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    );
                  },
                ),
              ),
              // Total Section
              Container(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        Text("${total.toInt()} MMK", 
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFCC5500))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCC5500),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: isOrdering ? null : _placeOrder,
                        child: isOrdering
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("CONFIRM ORDER", 
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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