import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final String tableNumber;
  final List<Map<String, dynamic>> orders;

  const CheckoutPage({super.key, required this.tableNumber, required this.orders});

  @override
  Widget build(BuildContext context) {
    // ကျသင့်ငွေ စုစုပေါင်းတွက်ချက်ခြင်း (Default Price 5,000 MMK ဖြင့် တွက်ထားသည်)
    double subtotal = orders.fold(0, (sum, item) => sum + (item['qty'] * 5000));
    double tax = subtotal * 0.05; // 5% Tax
    double total = subtotal + tax;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("CHECKOUT", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFCC5500),
        centerTitle: true,
        elevation: 0,
        // Back Button နှိပ်ရင် ဘာမှမဖြစ်ဘဲ ပြန်ထွက်ရုံပဲ (Status မပြောင်းစေရန်)
      ),
      body: Column(
        children: [
          // ၁။ Table Info Section
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFCC5500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Table: $tableNumber", 
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const Text("Status: Unpaid", 
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),

          // ၂။ Items List Section
          Expanded(
            child: orders.isEmpty 
              ? const Center(child: Text("No items ordered yet."))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final item = orders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: (item['notes'] as List).isNotEmpty 
                            ? Text((item['notes'] as List).join(", "), 
                                style: const TextStyle(fontSize: 12, color: Colors.grey))
                            : null,
                        trailing: Text("${item['qty']} x 5,000 MMK", 
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),
          ),

          // ၃။ Bill Summary Section
          _buildBillSummary(subtotal, tax, total, context),
        ],
      ),
    );
  }

  Widget _buildBillSummary(double subtotal, double tax, double total, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow("Subtotal", "${subtotal.toStringAsFixed(0)} MMK"),
          const SizedBox(height: 8),
          _summaryRow("Tax (5%)", "${tax.toStringAsFixed(0)} MMK"),
          const Divider(height: 25),
          _summaryRow("Total Amount", "${total.toStringAsFixed(0)} MMK", isTotal: true),
          const SizedBox(height: 25),
          
          // Payment Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showPaymentSuccess(context), // ဥပမာ Cash ရှင်းခြင်း
                  icon: const Icon(Icons.money),
                  label: const Text("CASH"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Colors.green, width: 2),
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showPaymentSuccess(context), // ဥပမာ K-Pay ရှင်းခြင်း
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("K-PAY / CB"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: const Color(0xFFCC5500),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, 
          style: TextStyle(fontSize: isTotal ? 20 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value, 
          style: TextStyle(fontSize: isTotal ? 22 : 16, 
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, 
            color: isTotal ? const Color(0xFFCC5500) : Colors.black)),
      ],
    );
  }

  // 🌟 Bill ရှင်းပြီးကြောင်း Dialog ပြသခြင်း
  void _showPaymentSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog အပြင်နှိပ်ရင် ပိတ်မသွားအောင်
      builder: (innerContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("Payment Successful!", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Table $tableNumber is now cleared.", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ၁။ Dialog ကို ပိတ်မယ်
                Navigator.pop(innerContext); 
                // ၂။ CheckoutPage ကို ပိတ်ပြီး 'true' ကို Table Screen ဆီ ပြန်ပို့မယ်
                Navigator.pop(context, true); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Done"),
            )
          ],
        ),
      ),
    );
  }
}