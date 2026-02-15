import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'menu_manager.dart';
import 'order_history.dart';
import 'staff_list.dart'; // 🌟 Staff List ကို import လုပ်ဖို့ မမေ့ပါနဲ့ Bro
import '../../data/constants.dart'; 

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  String formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalRevenue = calculateTodayRevenue();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("SERVE AI ADMIN", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      drawer: _buildDrawer(), 
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Total Revenue",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 5),
                    Text("${formatPrice(totalRevenue)} MMK",
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text("Keep up the good work!",
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),

              const Text("Dashboard Overview",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              _buildStatsGrid(totalRevenue),
              const SizedBox(height: 25),

              _buildSalesChart(),
              const SizedBox(height: 25),
              
              _buildRecentOrders(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF1A1C1E),
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text("SERVE AI",
                  style: TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            _drawerItem(Icons.dashboard, "Dashboard", true, () {
              Navigator.pop(context);
            }),
            _drawerItem(Icons.restaurant_menu, "Menu Manager", false, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuManager()));
            }),
            _drawerItem(Icons.history, "Order History", false, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistory()));
            }),

            // 🌟 ဤနေရာတွင် Staff List ကို ချိတ်ဆက်လိုက်ပါပြီ Bro
            _drawerItem(Icons.people_outline, "Staff List", false, () {
              Navigator.pop(context); // Drawer အရင်ပိတ်မယ်
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StaffList())
              );
            }),

            const Spacer(),
            _drawerItem(Icons.logout, "Logout", false, () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, bool isActive, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.orange : Colors.grey),
      title: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.grey)),
      onTap: onTap,
    );
  }

  Widget _buildStatsGrid(double revenue) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: [
        _statCard("Revenue", "${(revenue / 1000).toStringAsFixed(0)}K", Icons.payments, Colors.green),
        _statCard("Orders", "${orderHistory.length}", Icons.shopping_bag, Colors.blue),
        _statCard("Popular", "Ramen", Icons.star, Colors.orange),
        _statCard("Tables", "8/12", Icons.table_bar, Colors.purple),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSalesChart() {
    return Container(
      width: double.infinity,
      height: 280,
      padding: const EdgeInsets.fromLTRB(10, 20, 25, 10),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text("Weekly Sales Trends", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return value >= 0 && value < 7 
                          ? Text(days[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 12))
                          : const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 5), FlSpot(4, 4), FlSpot(5, 6), FlSpot(6, 5.5)],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 4,
                    belowBarData: BarAreaData(show: true, color: Colors.orange.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Live Feed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.receipt_long, color: Colors.orange),
              title: Text("Table ${index + 1}"),
              trailing: const Text("Pending", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}