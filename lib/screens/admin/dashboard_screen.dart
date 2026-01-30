import 'package:flutter/material.dart';

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
      // 🌟 Sidebar အစား Drawer ကို ပြောင်းသုံးလိုက်ပါတယ်
      appBar: AppBar(
        title: const Text("SERVE AI ADMIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
            const Text("Dashboard Overview", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // 🌟 Stats Grid (Overflow မဖြစ်အောင် childAspectRatio ကို ပြင်ထားတယ်)
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

  // 🌟 Sidebar ကို Drawer အဖြစ် ပြောင်းလဲခြင်း
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF1A1C1E),
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text("SERVE AI", style: TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            _drawerItem(Icons.dashboard, "Dashboard", true),
            _drawerItem(Icons.restaurant_menu, "Menu Manager", false),
            _drawerItem(Icons.people, "Staff List", false),
            const Spacer(),
            _drawerItem(Icons.logout, "Logout", false),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, bool isActive) {
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.orange : Colors.grey),
      title: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.grey)),
      onTap: () => Navigator.pop(context), // နှိပ်ရင် Drawer ပိတ်မယ်
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2, // ဖုန်းမှာဆိုရင် ၂ ခုစီပြမယ်
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.2, // 🌟 Card ထဲမှာ စာသားဆံ့အောင် အချိုးချဲ့လိုက်တယ်
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
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: const Center(child: Text("Sales Analytics Chart Placeholder")),
    );
  }

  Widget _buildRecentOrders() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
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
              trailing: const Text("Pending", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}