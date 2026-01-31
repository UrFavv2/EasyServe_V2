import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 🌟 နေ့စွဲ format ဖတ်ဖို့ လိုအပ်ပါတယ် (pubspec.yaml မှာ intl ထည့်ထားပါ)
import '../../data/constants.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  // 🌟 Filter လုပ်ထားတဲ့ list ကို သိမ်းထားဖို့
  List<Map<String, dynamic>> filteredOrders = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // စစချင်းမှာ ဒီနေ့ order တွေကိုပဲ ပြထားမယ်
    _filterOrdersByDate(selectedDate);
  }

  // 🌟 နေ့စွဲအလိုက် Filter လုပ်တဲ့ Logic
  void _filterOrdersByDate(DateTime date) {
    String formattedTarget = DateFormat('dd MMM yyyy').format(date);
    setState(() {
      selectedDate = date;
      filteredOrders = orderHistory.where((order) {
        return order['date'] == formattedTarget;
      }).toList();
    });
  }

  // 🌟 Calendar Dialog ခေါ်ခြင်း
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.orange),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      _filterOrdersByDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("ORDER HISTORY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          // 🌟 Date ရွေးတဲ့ Icon
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.orange),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 📅 လက်ရှိပြနေတဲ့ နေ့စွဲကို ဖော်ပြခြင်း
          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            color: Colors.orange.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Showing: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                Text("${filteredOrders.length} Orders Found", style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          
          Expanded(
            child: filteredOrders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildOrderCard(order);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.1),
          child: const Icon(Icons.receipt, color: Colors.orange),
        ),
        title: Text("Table ${order['table']}", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(order['items']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${order['total']} MMK", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            Text(order['time'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 10),
          const Text("No orders found for this date.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}