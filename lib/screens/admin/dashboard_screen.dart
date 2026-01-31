import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
// 🌟 MenuManager ကို import လုပ်ဖို့ မမေ့ပါနဲ့ (File path မှန်အောင် စစ်ပေးပါ)
import 'menu_manager.dart'; 

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dashboard Overview", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            _buildStatsGrid(),
            const SizedBox(height: 25),

            _buildSalesChart(),
            const SizedBox(height: 20),
            
            _buildRecentOrders(),
          ],
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
            // 🌟 Dashboard Menu
            _drawerItem(Icons.dashboard, "Dashboard", true, () {
              Navigator.pop(context); // Drawer ကိုပဲ ပိတ်လိုက်မယ်
            }),
            // 🌟 Menu Manager Menu (ချိတ်ဆက်မှု အပိုင်း)
            _drawerItem(Icons.restaurant_menu, "Menu Manager", false, () {
              Navigator.pop(context); // Drawer ပိတ်မယ်
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuManager()),
              );
            }),
            _drawerItem(Icons.people, "Staff List", false, () {}),
            const Spacer(),
            _drawerItem(Icons.logout, "Logout", false, () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🌟 onTap ပါဝင်အောင် ပြုပြင်ထားသော Drawer Item helper
  Widget _drawerItem(IconData icon, String title, bool isActive, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.orange : Colors.grey),
      title: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.grey)),
      onTap: onTap,
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: [
        _statCard("Revenue", "1.2M", Icons.payments, Colors.green),
        _statCard("Orders", "148", Icons.shopping_bag, Colors.blue),
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
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        if (value >= 0 && value < 7) {
                          return Text(days[value.toInt()], 
                            style: const TextStyle(color: Colors.grey, fontSize: 12));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 4),
                      const FlSpot(2, 3.5),
                      const FlSpot(3, 5),
                      const FlSpot(4, 4),
                      const FlSpot(5, 6),
                      const FlSpot(6, 5.5),
                    ],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.orange.withOpacity(0.1),
                    ),
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
          const Text("Live Feed", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.receipt_long, color: Colors.orange),
              title: Text("Table ${index + 1}"),
              trailing: const Text("Pending", 
                style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}