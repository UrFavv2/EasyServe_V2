import 'package:flutter/material.dart';
import '../../data/constants.dart';

class InventoryManager extends StatefulWidget {
  const InventoryManager({super.key});

  @override
  State<InventoryManager> createState() => _InventoryManagerState();
}

class _InventoryManagerState extends State<InventoryManager> {
  // 🌟 စမ်းသပ်ရန်အတွက် local list အနေနဲ့ သုံးပါမယ်
  List<Map<String, dynamic>> items = List.from(inventoryList);

  // Controller များ
  final TextEditingController nameController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  // 🌟 ပစ္စည်းအသစ်ထည့်ရန် Dialog Box
  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Add New Stock", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, "Item Name (e.g. Rice)"),
              const SizedBox(height: 15),
              _buildTextField(stockController, "Quantity (e.g. 50)", isNumber: true),
              const SizedBox(height: 15),
              _buildTextField(unitController, "Unit (e.g. kg / cans)"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              if (nameController.text.isNotEmpty && stockController.text.isNotEmpty) {
                setState(() {
                  items.add({
                    "itemName": nameController.text,
                    "category": "Raw Material",
                    "stock": int.parse(stockController.text),
                    "unit": unitController.text,
                    "minThreshold": 5,
                  });
                });
                nameController.clear();
                stockController.clear();
                unitController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Add Item", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("INVENTORY CONTROL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildQuickSummary(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                bool isLowStock = item['stock'] <= item['minThreshold'];
                return _buildInventoryCard(item, isLowStock);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemDialog, // Dialog ကို ခေါ်လိုက်မယ်
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add_business, color: Colors.white),
        label: const Text("Add New Stock", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // Inventory Card Widget
  Widget _buildInventoryCard(Map<String, dynamic> item, bool isLowStock) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(
          backgroundColor: isLowStock ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
          child: Icon(isLowStock ? Icons.priority_high : Icons.inventory_2, color: isLowStock ? Colors.red : Colors.blue),
        ),
        title: Text(item['itemName'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item['category']),
        trailing: Text("${item['stock']} ${item['unit']}", 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isLowStock ? Colors.red : Colors.black)),
      ),
    );
  }

  Widget _buildQuickSummary() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _infoBox("Total Items", "${items.length}", Colors.blue),
          const SizedBox(width: 15),
          _infoBox("Low Stock", "${items.where((i) => i['stock'] <= i['minThreshold']).length}", Colors.red),
        ],
      ),
    );
  }

  Widget _infoBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }
}