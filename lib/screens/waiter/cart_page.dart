import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final Map<String, int> cart;
  final String tableNumber;

  const CartPage({super.key, required this.cart, required this.tableNumber});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // ဟင်းပွဲအလိုက် ရွေးချယ်ထားသော Note များကို သိမ်းမည့် Map
  Map<String, List<String>> selectedNotes = {};

  // အသုံးများသော Note စာရင်းများ
  final List<String> presetNotes = [
    "အစပ်လျှော့",
    "အချိုမထည့်နဲ့",
    "အသားများများ",
    "အသီးအရွက်မပါ",
    "ပါဆယ်ထုပ်ပေးပါ"
  ];

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.cart.values.fold(0, (sum, qty) => sum + (qty * 5000));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Confirm Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFCC5500),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: const Color(0xFFCC5500).withOpacity(0.1),
            child: Text("Table Number: ${widget.tableNumber}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFCC5500))),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                String foodName = widget.cart.keys.elementAt(index);
                int qty = widget.cart.values.elementAt(index);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFCC5500),
                            child: Text(qty.toString(), style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text("${qty * 5000} MMK", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        ),
                        
                        // 🌟 Quick Select Notes Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Wrap(
                            spacing: 8, // ကန့်လန့်ဖြတ် အကွာအဝေး
                            runSpacing: 0, // အောက်တန်းနှင့် အကွာအဝေး
                            children: presetNotes.map((note) {
                              bool isSelected = selectedNotes[foodName]?.contains(note) ?? false;
                              return FilterChip(
                                label: Text(note, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
                                selected: isSelected,
                                selectedColor: const Color(0xFFCC5500),
                                checkmarkColor: Colors.white,
                                backgroundColor: Colors.grey[200],
                                onSelected: (bool value) {
                                  setState(() {
                                    if (value) {
                                      // Note ကို ထည့်မယ်
                                      if (selectedNotes[foodName] == null) {
                                        selectedNotes[foodName] = [note];
                                      } else {
                                        selectedNotes[foodName]!.add(note);
                                      }
                                    } else {
                                      // Note ကို ပြန်ဖြုတ်မယ်
                                      selectedNotes[foodName]?.remove(note);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildSummarySection(totalPrice, context),
        ],
      ),
    );
  }

  Widget _buildSummarySection(int totalPrice, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              const Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("$totalPrice MMK",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFCC5500))),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Kitchen ဆီပို့တဲ့အခါ selectedNotes ကိုပါ ထည့်ပို့ပေးရပါမယ်
                print("Final Orders with Notes: $selectedNotes");
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
        content: const Text("Order Sent Successfully!", textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Center(child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }
}