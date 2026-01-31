import 'package:flutter/material.dart';
import '../../data/constants.dart';

class InventoryManager extends StatefulWidget {
  const InventoryManager({super.key});

  @override
  State<InventoryManager> createState() => _InventoryManagerState();
}

class _InventoryManagerState extends State<InventoryManager> {
  // 🌟 စမ်းသပ်ရန် local list
  List<Map<String, dynamic>> items = List.from(inventoryList);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

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
                _clearControllers();
                Navigator.pop(context);
              }
            },
            child: const Text("Add Item", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    nameController.clear();
    stockController.clear();
    unitController.clear();
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Stocks Overview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 🌟 တစ်တန်းမှာ ၂ ခုပြမယ်
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85, // Card ရဲ့ အချိုးအစား (အလျား/အနံ)
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                bool isLowStock = item['stock'] <= item['minThreshold'];
                return _buildGridInventoryCard(item, isLowStock);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemDialog,
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add_business, color: Colors.white),
        label: const Text("Add New Stock", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // 🌟 အသစ်ပြင်ဆင်ထားတဲ့ Grid Card UI
  Widget _buildGridInventoryCard(Map<String, dynamic> item, bool isLowStock) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        border: isLowStock ? Border.all(color: Colors.red.withValues(alpha: 0.5), width: 1) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: isLowStock ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
              child: Icon(isLowStock ? Icons.warning_amber_rounded : Icons.inventory_2, 
                color: isLowStock ? Colors.red : Colors.blue, size: 28),
            ),
            const SizedBox(height: 12),
            Text(item['itemName'], 
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(item['category'], 
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${item['stock']}", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, 
                  color: isLowStock ? Colors.red : Colors.black)),
                const SizedBox(width: 4),
                Text(item['unit'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
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
        padding: const EdgeInsets.symmetric(vertical: 15),
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