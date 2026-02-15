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

  // 🌟 Order တင်မယ့် အဓိက Function
  Future<void> _placeOrder() async {
    setState(() => isOrdering = true);

    try {
      double totalAmount = widget.cart.values.fold(
          0, (sum, item) => sum + (item['price'] * item['quantity']));

      // ၁။ 'orders' table ထဲသို့ အချက်အလက်သွင်းခြင်း
      final orderResponse = await supabase.from('orders').insert({
        'table_id': widget.tableId,
        'total_amount': totalAmount,
        'status': 'Pending', // စစချင်းမှာ Pending အနေနဲ့ သွင်းမယ်
      }).select().single();

      final int newOrderId = orderResponse['id'];

      // ၂။ 'order_items' table ထဲသို့ item များ အစုလိုက်သွင်းခြင်း (Bulk Insert)
      final List<Map<String, dynamic>> orderItems = widget.cart.entries.map((entry) {
        return {
          'order_id': newOrderId,
          'product_id': int.parse(entry.key), // Item ID
          'quantity': entry.value['quantity'],
          'price_at_order': entry.value['price'],
        };
      }).toList();

      await supabase.from('order_items').insert(orderItems);

      // ၃။ 'tables' table ရဲ့ status ကို 'Occupied' သို့ ပြောင်းခြင်း
      await supabase
          .from('tables')
          .update({'status': 'Occupied'})
          .eq('id', widget.tableId);

      // အားလုံးအောင်မြင်ရင်
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
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
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text("Order placed successfully!", textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              // အစဆုံး Table Selection Screen ကို ပြန်သွားမယ်
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.cart.values.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(
        title: Text("Order for Table ${widget.tableNumber}"),
        backgroundColor: const Color(0xFFCC5500),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                String key = widget.cart.keys.elementAt(index);
                var item = widget.cart[key]!;
                return ListTile(
                  title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${item['quantity']} x ${item['price']} MMK"),
                  trailing: Text("${item['quantity'] * item['price']} MMK"),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("${total.toInt()} MMK", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFCC5500))),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCC5500)),
                    onPressed: isOrdering ? null : _placeOrder,
                    child: isOrdering
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("CONFIRM ORDER", style: TextStyle(color: Colors.white, fontSize: 16)),
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