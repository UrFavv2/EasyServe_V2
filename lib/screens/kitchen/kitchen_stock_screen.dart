import 'package:flutter/material.dart';
import '../../data/constants.dart'; // ✅ CORRECT IMPORT

class KitchenStockScreen extends StatefulWidget {
  const KitchenStockScreen({super.key});

  @override
  State<KitchenStockScreen> createState() => _KitchenStockScreenState();
}

class _KitchenStockScreenState extends State<KitchenStockScreen> {

  void _toggleAvailability(int index) {
    setState(() {
      sharedMenuList[index]['isAvailable'] =
          !(sharedMenuList[index]['isAvailable'] ?? false);
    });

    final item = sharedMenuList[index];
    final status = item['isAvailable'] ? "Available" : "Out of Stock";

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item['name']} is now $status"),
        backgroundColor:
            item['isAvailable'] ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int total = sharedMenuList.length;
    int available =
        sharedMenuList.where((i) => i['isAvailable'] == true).length;
    int soldOut = total - available;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Kitchen - Stock Control",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem("Total", total, Colors.grey),
                    _buildSummaryItem("Available", available, Colors.green),
                    _buildSummaryItem("Sold Out", soldOut, Colors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sharedMenuList.length,
                itemBuilder: (context, index) {
                  final item = sharedMenuList[index];
                  final bool isAvailable =
                      item['isAvailable'] ?? false;

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(
                        isAvailable
                            ? Icons.check_circle
                            : Icons.do_not_disturb_on,
                        color:
                            isAvailable ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        item['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: isAvailable
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                      subtitle: Text(item['category'] ?? "Food"),
                      trailing: Switch(
                        value: isAvailable,
                        activeColor: Colors.green,
                        onChanged: (_) =>
                            _toggleAvailability(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, int count, Color color) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
