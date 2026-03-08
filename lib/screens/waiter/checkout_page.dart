import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';



class CheckoutPage extends StatefulWidget {

  final String tableNumber;

  final int tableId;



  const CheckoutPage({super.key, required this.tableNumber, required this.tableId});



  @override

  State<CheckoutPage> createState() => _CheckoutPageState();

}



class _CheckoutPageState extends State<CheckoutPage> {

  final supabase = Supabase.instance.client;

  bool isProcessing = false;



  // 🔥 လက်ရှိ Table ရဲ့ Pending Order စာရင်းကို ဆွဲထုတ်သည့် Function

  Future<List<Map<String, dynamic>>> _fetchOrderItems() async {

    try {

      // ၁။ Pending ဖြစ်နေတဲ့ Order အသစ်ဆုံးတစ်ခုကို ယူမယ်

      final orderData = await supabase

          .from('orders')

          .select('id')

          .eq('table_id', widget.tableId)

          .eq('status', 'Pending')

          .order('created_at', ascending: false) 

          .limit(1)

          .maybeSingle();



      if (orderData == null) return [];



      final int orderId = orderData['id'];



      // ၂။ ရလာတဲ့ Order ID နဲ့ သက်ဆိုင်တဲ့ item များကို ဆွဲထုတ်မယ်

      final List<Map<String, dynamic>> items = await supabase

          .from('order_items')

          .select()

          .eq('order_id', orderId);

      

      return items;

    } catch (e) {

      debugPrint("Fetch Error: $e");

      return [];

    }

  }



  // 🔥 ငွေချေစနစ်နှင့် Table Status Update လုပ်သည့် Function

  Future<void> _handlePayment(BuildContext context) async {

    if (isProcessing) return; // ခလုတ်ကို နှစ်ခါနှိပ်မိခြင်းမှ ကာကွယ်ရန်

    setState(() => isProcessing = true);



    try {

      // ၁။ Table status ကို "Available" (စာလုံးပေါင်း အကြီးအသေး သတိထားရန်) ပြောင်းမည်

      await supabase

          .from('tables')

          .update({'status': 'Available'}) 

          .eq('id', widget.tableId);



      // ၂။ လက်ရှိ Table ရဲ့ Pending Order အားလုံးကို "Completed" ပြောင်းမည်

      await supabase

          .from('orders')

          .update({'status': 'Completed'})

          .eq('table_id', widget.tableId)

          .eq('status', 'Pending');



      if (mounted) {

        _showPaymentSuccess(context);

      }

    } catch (e) {

      debugPrint("Payment Update Error: $e");

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(content: Text("Payment Error: $e"), backgroundColor: Colors.red),

        );

      }

    } finally {

      if (mounted) setState(() => isProcessing = false);

    }

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(

        title: const Text("BILLING", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

        backgroundColor: const Color(0xFFCC5500),

        centerTitle: true,

        elevation: 0,

        iconTheme: const IconThemeData(color: Colors.white),

      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(

        future: _fetchOrderItems(),

        builder: (context, snapshot) {

          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CircularProgressIndicator(color: Color(0xFFCC5500)));

          }



          final items = snapshot.data ?? [];

          if (items.isEmpty) return const Center(child: Text("No pending orders for this table."));



          // 💡 စုစုပေါင်းတန်ဖိုး တွက်ချက်ခြင်း

          double subtotal = items.fold(0, (sum, item) {

            final double price = (item['price_at_order'] ?? item['price_at_time'] ?? 0).toDouble();

            final int qty = (item['quantity'] ?? 0).toInt();

            return sum + (price * qty);

          });



          double tax = subtotal * 0.05; 

          double total = subtotal + tax;



          return Column(

            children: [

              _buildTableHeader(),

              Expanded(child: _buildOrderList(items)),

              _buildBillSummary(subtotal, tax, total, context),

            ],

          );

        },

      ),

    );

  }



  // --- UI Components ---



  Widget _buildTableHeader() {

    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

      color: const Color(0xFFCC5500),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text("TABLE ${widget.tableNumber}", 

                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),

              const Text("Invoice Pending", style: TextStyle(color: Colors.white70, fontSize: 14)),

            ],

          ),

          Container(

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),

            child: const Text("OCCUPIED", style: TextStyle(color: Color(0xFFCC5500), fontWeight: FontWeight.bold, fontSize: 12)),

          ),

        ],

      ),

    );

  }



  Widget _buildOrderList(List<Map<String, dynamic>> items) {

    return ListView.builder(

      padding: const EdgeInsets.all(15),

      itemCount: items.length,

      itemBuilder: (context, index) {

        final item = items[index];

        final double price = (item['price_at_order'] ?? item['price_at_time'] ?? 0).toDouble();

        final int qty = (item['quantity'] ?? 0).toInt();



        return Card(

          margin: const EdgeInsets.only(bottom: 10),

          elevation: 0,

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey[200]!)),

          child: Padding(

            padding: const EdgeInsets.all(12),

            child: Row(

              children: [

                CircleAvatar(

                  backgroundColor: Colors.orange[50],

                  child: Text("${qty}x", style: const TextStyle(color: Color(0xFFCC5500), fontWeight: FontWeight.bold)),

                ),

                const SizedBox(width: 15),

                Expanded(

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      // Product Name မရှိလျှင် ID ကိုပြပါမည်

                      Text(item['item_name'] ?? "Product ID: ${item['product_id']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                      Text("${price.toInt()} MMK / unit", style: const TextStyle(color: Colors.grey, fontSize: 12)),

                    ],

                  ),

                ),

                Text("${(qty * price).toInt()} MMK", style: const TextStyle(fontWeight: FontWeight.bold)),

              ],

            ),

          ),

        );

      },

    );

  }



  Widget _buildBillSummary(double subtotal, double tax, double total, BuildContext context) {

    return Container(

      padding: const EdgeInsets.fromLTRB(25, 20, 25, 35),

      decoration: const BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),

        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))],

      ),

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          _summaryRow("Subtotal", "${subtotal.toInt()} MMK"),

          const SizedBox(height: 8),

          _summaryRow("Service Tax (5%)", "${tax.toInt()} MMK"),

          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),

          _summaryRow("Total Payable", "${total.toInt()} MMK", isTotal: true),

          const SizedBox(height: 25),

          Row(

            children: [

              _paymentButton("CASH", Icons.payments_outlined, Colors.green, () => _handlePayment(context)),

              const SizedBox(width: 15),

              _paymentButton("DIGITAL", Icons.qr_code_2_rounded, const Color(0xFFCC5500), () => _handlePayment(context)),

            ],

          ),

        ],

      ),

    );

  }



  Widget _paymentButton(String label, IconData icon, Color color, VoidCallback onPressed) {

    return Expanded(

      child: ElevatedButton.icon(

        onPressed: isProcessing ? null : onPressed,

        icon: isProcessing ? const SizedBox.shrink() : Icon(icon, size: 20),

        label: isProcessing 

          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 

          : Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),

        style: ElevatedButton.styleFrom(

          backgroundColor: color,

          foregroundColor: Colors.white,

          padding: const EdgeInsets.symmetric(vertical: 18),

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

        ),

      ),

    );

  }



  Widget _summaryRow(String label, String value, {bool isTotal = false}) {

    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [

        Text(label, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500)),

        Text(value, style: TextStyle(fontSize: isTotal ? 22 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: isTotal ? const Color(0xFFCC5500) : Colors.black)),

      ],

    );

  }



  void _showPaymentSuccess(BuildContext context) {

    showDialog(

      context: context,

      barrierDismissible: false,

      builder: (ctx) => AlertDialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        content: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),

            const SizedBox(height: 20),

            const Text("PAYMENT COMPLETE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Text("Table ${widget.tableNumber} is now Available.", textAlign: TextAlign.center),

            const SizedBox(height: 30),

            ElevatedButton(

              onPressed: () {

                Navigator.pop(ctx); // Close dialog

                Navigator.pop(context); // Back to TableSelectionScreen

              },

              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),

              child: const Text("CLOSE"),

            )

          ],

        ),

      ),

    );

  }

}