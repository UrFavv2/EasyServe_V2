import 'package:flutter/material.dart';
import './menu_page.dart';
import './checkout_page.dart';
import '../../data/constants.dart'; // 🌟 Shared Menu List ကို Import လုပ်ပါ

class TableSelectionScreen extends StatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  late List<Map<String, dynamic>> tables;

  List<Map<String, dynamic>> notifications = [
    {"table": "3", "item": "Fried Rice", "time": "2 mins ago", "status": "Ready"},
    {"table": "5", "item": "Coca Cola", "time": "Just now", "status": "Ready"},
  ];

  @override
  void initState() {
    super.initState();
    tables = List.generate(12, (index) => {
      'isOccupied': false,
      'hasKitchenNoti': (index == 0 || index == 2), 
    });
  }

  void showNotificationPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Kitchen Notifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFCC5500))),
            ),
            Expanded(
              child: notifications.isEmpty 
                ? const Center(child: Text("No new notifications"))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final noti = notifications[index];
                      return ListTile(
                        leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.restaurant, color: Colors.white, size: 20)),
                        title: Text("Table ${noti['table']} - ${noti['item']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(noti['time']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() => notifications.removeAt(index));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          child: const Text("Pick Up"),
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

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 Drawer ထဲမှာပြရန် ပစ္စည်းပြတ်နေသော စာရင်းကို စစ်ထုတ်ခြင်း
    final outOfStockItems = sharedMenuList.where((item) => item['isAvailable'] == false).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("EasyServe POS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFCC5500),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Badge(
              label: Text(notifications.length.toString()),
              isLabelVisible: notifications.isNotEmpty,
              child: const Icon(Icons.notifications_active, color: Colors.white, size: 28),
            ),
            onPressed: showNotificationPanel,
          ),
          const SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFCC5500)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFFCC5500), size: 45),
              ),
              accountName: const Text("Waiter Alex", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail: Row(
                children: const [
                  Icon(Icons.circle, color: Colors.greenAccent, size: 10),
                  SizedBox(width: 5),
                  Text("Online | ID: W-204"),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem("Tables", "5", Colors.blue),
                  _buildStatItem("Orders", "12", Colors.orange),
                  _buildStatItem("Sales", "150K", Colors.green),
                ],
              ),
            ),
            const Divider(),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.table_bar, color: Colors.blue),
                    title: const Text("My Workspace"),
                    subtitle: const Text("Table 1, 3, 5, 8, 10"),
                    trailing: const Badge(label: Text("5"), backgroundColor: Colors.blue),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.teal),
                    title: const Text("My Order History"),
                    onTap: () {},
                  ),

                  // 🌟 ပြင်ဆင်ထားသော Out of Stock Section (ExpansionTile)
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                      title: const Text("Out of Stock Items"),
                      trailing: Badge(
                        label: Text(outOfStockItems.length.toString()), 
                        backgroundColor: Colors.red,
                      ),
                      children: [
                        if (outOfStockItems.isEmpty)
                          const ListTile(title: Text("All items available", style: TextStyle(fontSize: 13, color: Colors.grey)))
                        else
                          ...outOfStockItems.map((item) => ListTile(
                            dense: true,
                            title: Text(item['name'], style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
                            leading: const Icon(Icons.remove_circle_outline, size: 18, color: Colors.red),
                          )).toList(),
                      ],
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.wallet_giftcard, color: Colors.purple),
                    title: const Text("My Tips Report"),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text("Kitchen Support"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("End Shift", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {},
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            bool isOccupied = tables[index]['isOccupied'];
            bool hasNoti = tables[index]['hasKitchenNoti'];
            String tableNum = (index + 1).toString();

            return Card(
              elevation: 5,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isOccupied ? Colors.red : Colors.green.withOpacity(0.5), width: 3),
              ),
              child: Stack(
                children: [
                  Positioned.fill(child: Image.asset('assets/images/table img.jpg', fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[300]))),
                  Positioned.fill(child: Container(color: isOccupied ? Colors.red.withOpacity(0.4) : Colors.black.withOpacity(0.7))),
                  
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("TABLE $tableNum", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                            if (hasNoti && isOccupied) const Icon(Icons.restaurant_menu, color: Colors.yellow, size: 24),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => tables[index]['isOccupied'] = true);
                            Navigator.push(context, MaterialPageRoute(builder: (c) => MenuPage(tableNumber: tableNum)));
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: isOccupied ? Colors.red[800] : Colors.green, foregroundColor: Colors.white),
                          child: Text(isOccupied ? "ADD ORDER" : "NEW ORDER"),
                        ),
                        if (isOccupied) ...[
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(context, MaterialPageRoute(builder: (c) => CheckoutPage(tableNumber: tableNum, orders: const [])));
                              if (result == true) setState(() => tables[index]['isOccupied'] = false);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red[900]),
                            child: const Text("BILL OUT", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}