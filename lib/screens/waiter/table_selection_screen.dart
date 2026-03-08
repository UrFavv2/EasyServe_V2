import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './menu_page.dart';
import './checkout_page.dart';

class TableSelectionScreen extends StatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  final supabase = Supabase.instance.client;

  // Kitchen Notifications logic
  List<Map<String, dynamic>> notifications = [
    {"table": "3", "item": "Fried Rice", "time": "2 mins ago", "status": "Ready"},
    {"table": "5", "item": "Coca Cola", "time": "Just now", "status": "Ready"},
  ];

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

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // Realtime stream သုံးထားလို့ database ပြောင်းတာနဲ့ UI ချက်ချင်းလိုက်ပြောင်းပါလိမ့်မယ်
        stream: supabase.from('tables').stream(primaryKey: ['id']).order('table_number'),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final dbTables = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 12, 
                mainAxisSpacing: 12, 
                childAspectRatio: 0.65, 
              ),
              itemCount: dbTables.length,
              itemBuilder: (context, index) {
                final table = dbTables[index];
                final int tableId = table['id']; 
                final String tableNum = table['table_number'].toString();
                
                // 🌟 Logic ပြင်ဆင်ချက်- Database ထဲက status က "Occupied" ဖြစ်နေမှ isOccupied true ဖြစ်မယ်
                // Case-sensitive ဖြစ်တတ်လို့ "Occupied" လို့ တိုက်ရိုက်စစ်တာ ပိုစိတ်ချရပါတယ်
                final String status = table['status']?.toString() ?? "Available";
                final bool isOccupied = status == 'Occupied';
                
                return Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isOccupied ? Colors.red : Colors.green.withOpacity(0.5), 
                      width: 3
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/table img.jpg', 
                          fit: BoxFit.cover, 
                          errorBuilder: (c, e, s) => Container(color: Colors.grey[300])
                        )
                      ),
                      Positioned.fill(
                        child: Container(
                          color: isOccupied ? Colors.red.withOpacity(0.4) : Colors.black.withOpacity(0.6)
                        )
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "TABLE $tableNum", 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                            ),
                            const SizedBox(height: 8),
                            
                            // ADD ORDER Button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (c) => MenuPage(tableNumber: tableNum, tableId: tableId)
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isOccupied ? Colors.orange[800] : Colors.green, 
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(isOccupied ? "ADD ORDER" : "NEW ORDER", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            
                            // 🔥 BILL OUT Button (Occupied ဖြစ်နေမှ ပေါ်လာမယ်)
                            if (isOccupied) ...[
                              const SizedBox(height: 6),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (c) => CheckoutPage(tableNumber: tableNum, tableId: tableId)
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, 
                                  foregroundColor: Colors.red[900],
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: const Text("BILL OUT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
          );
        },
      ),
    );
  }
}