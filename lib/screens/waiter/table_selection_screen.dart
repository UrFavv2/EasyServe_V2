import 'package:flutter/material.dart';
import './menu_page.dart';

class TableSelectionScreen extends StatelessWidget {
  const TableSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EasyServe - Waiter Mode",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFCC5500),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFCC5500)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.person, color: Color(0xFFCC5500), size: 35),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Waiter: Kyaw Kyaw",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Service Staff ID: #001", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.table_restaurant, color: Color(0xFFCC5500)),
              title: const Text("Dining Tables"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Color(0xFFCC5500)),
              title: const Text("My Order History"),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85, 
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
              child: Card(
                elevation: 5,
                clipBehavior: Clip.antiAlias, // ပုံကို Card ရဲ့ ဝိုင်းနေတဲ့ ထောင့်တွေအတိုင်း ညှပ်ထုတ်ဖို့
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: [
                    // ၁။ Background Image (Card အပြည့်)
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/table img.jpg',
                        fit: BoxFit.cover, // ပုံကို Card အပြည့် ဖြန့်ခင်းဖို့
                      ),
                    ),

                    // ၂။ Gradient Overlay (စာသားတွေ ဖတ်ရလွယ်အောင် ပုံကို အမှောင်ချခြင်း)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8), // အောက်ခြေနားမှာ ပိုမှောင်မယ်
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ၃။ Content (Table Number & Status)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end, // စာသားတွေကို အောက်ခြေမှာထားမယ်
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TABLE ${index + 1}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isOccupied ? const Color(0xFFCC5500) : Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isOccupied ? "Occupied" : "Available",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Occupied ဖြစ်ရင် ပုံကို နည်းနည်း ဝါးသွားစေချင်ရင် သုံးဖို့ (Optional)
                    if (isOccupied)
                      Positioned.fill(
                        child: Container(color: const Color(0xFFCC5500).withOpacity(0.2)),
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