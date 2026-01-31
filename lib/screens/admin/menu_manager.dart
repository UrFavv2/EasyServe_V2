import 'package:flutter/material.dart';
import '../../data/constants.dart';

class MenuManager extends StatefulWidget {
  const MenuManager({super.key});

  @override
  State<MenuManager> createState() => _MenuManagerState();
}

class _MenuManagerState extends State<MenuManager> {
  
  void _showAddMenuItemDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String selectedCategory = 'Main Course';

    showDialog(
      context: context,
      builder: (context) => _buildMenuDialog(
        "Add New Menu Item", 
        "Add", 
        nameController, 
        priceController, 
        selectedCategory, 
        (newData) {
          setState(() {
            sharedMenuList.add(newData);
          });
        }
      ),
    );
  }

  void _showEditMenuItemDialog(Map item, int index) {
    final nameController = TextEditingController(text: item['name']);
    final priceController = TextEditingController(text: item['price'].toString());
    String selectedCategory = item['category'] ?? 'Main Course';

    showDialog(
      context: context,
      builder: (context) => _buildMenuDialog(
        "Edit Menu Item", 
        "Update", 
        nameController, 
        priceController, 
        selectedCategory, 
        (newData) {
          setState(() {
            // Edit လုပ်တဲ့အခါ index အတိုင်း data အသစ်ကို အစားထိုးတယ်
            sharedMenuList[index] = newData;
          });
        }
      ),
    );
  }

  void _showDeleteConfirm(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
          TextButton(
            onPressed: () {
              setState(() {
                sharedMenuList.removeAt(index);
              });
              Navigator.pop(context);
            }, 
            child: const Text("Yes", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  // 🌟 Error ကင်းစေရန် ပြင်ဆင်ထားသော Dialog Helper
  Widget _buildMenuDialog(
    String title, 
    String btnText, 
    TextEditingController nameCtrl, 
    TextEditingController priceCtrl, 
    String category, 
    Function(Map<String, dynamic>) onSave // 🌟 Type ကို သေချာသတ်မှတ်ပေးလိုက်ပါ
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Item Name")),
            const SizedBox(height: 15),
            TextField(
              controller: priceCtrl, 
              keyboardType: TextInputType.number, 
              decoration: const InputDecoration(labelText: "Price (MMK)")
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
          onPressed: () {
            if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
              // 🌟 Map အသစ်ကို ဤနေရာတွင် တိတိကျကျ ဆောက်ပေးရပါမည်
              Map<String, dynamic> dataToSave = {
                'name': nameCtrl.text,
                'price': priceCtrl.text,
                'isAvailable': true, // default အနေနဲ့ true ထားမယ်
                'category': category,
              };
              
              onSave(dataToSave);
              Navigator.pop(context);
            }
          },
          child: Text(btnText),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("MENU MANAGER", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.orange, size: 30),
            onPressed: _showAddMenuItemDialog,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search menu items...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sharedMenuList.length,
              itemBuilder: (context, index) {
                final item = sharedMenuList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/table img.jpg', 
                        width: 55, height: 55, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: Colors.orange),
                      ),
                    ),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${item['price']} MMK", style: const TextStyle(color: Colors.orange)),
                    
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_note, color: Colors.blue),
                          onPressed: () => _showEditMenuItemDialog(item, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                          onPressed: () => _showDeleteConfirm(index),
                        ),
                        Switch(
                          value: item['isAvailable'],
                          activeColor: Colors.orange,
                          onChanged: (bool value) {
                            setState(() {
                              item['isAvailable'] = value; 
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}