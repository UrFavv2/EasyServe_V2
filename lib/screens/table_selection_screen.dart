import 'package:flutter/material.dart';
import './menu_page.dart';
import './kitchen_page.dart'; // Kitchen Page ကိုသွားဖို့ import လုပ်ထားပါ

class TableSelectionScreen extends StatelessWidget {
  const TableSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EasyServe - Select Table", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),

      // ၁။ Drawer Menu ထည့်သွင်းခြင်း
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.person, color: Colors.orange, size: 35),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Waiter: Kyaw Kyaw", 
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "EasyServe Staff", 
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Drawer List Items
            ListTile(
              leading: const Icon(Icons.table_restaurant, color: Colors.orange),
              title: const Text("Table Selection"),
              onTap: () {
                Navigator.pop(context); // Drawer ကို ပိတ်ရုံပဲ
              },
            ),
            ListTile(
              leading: const Icon(Icons.kitchen, color: Colors.orange),
              title: const Text("Kitchen Display (KDS)"),
              onTap: () {
                Navigator.pop(context); // Drawer ကို ပိတ်မယ်
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const KitchenPage())
                );
              },
            ),
            const Divider(), // မျဉ်းတားလေး
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                // Login Screen ကို ပြန်သွားမယ့် logic
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            bool isOccupied = index % 3 == 0;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuPage(tableNumber: (index + 1).toString()),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isOccupied ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isOccupied ? Colors.red : Colors.green,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.table_restaurant,
                      size: 50,
                      color: isOccupied ? Colors.red : Colors.green,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Table ${index + 1}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isOccupied ? "Occupied" : "Available",
                      style: TextStyle(color: isOccupied ? Colors.red : Colors.green),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}