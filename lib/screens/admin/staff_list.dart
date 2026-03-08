import 'package:flutter/material.dart';
import '../../data/constants.dart';
import '../../services/database_service.dart';

class StaffList extends StatefulWidget {
  const StaffList({super.key});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = 'Waiter';
  String _selectedFilter = 'All';

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin': return Colors.purple;
      case 'Chef': return Colors.orange;
      case 'Waiter': return Colors.blue;
      default: return Colors.grey;
    }
  }

  Future<void> _handleRegister(Map<String, dynamic>? staff) async {
    if (_nameController.text.isNotEmpty && _idController.text.isNotEmpty) {
      try {
        if (staff == null) {
          // 1. Supabase Database ထဲသို့ အသစ်ထည့်ခြင်း
          await DatabaseService().addStaff(
            _nameController.text,
            _selectedRole,
            "1234",
          );

          // 2. Local List ကို Update လုပ်ခြင်း (UI မှာ ချက်ချင်းပေါ်စေရန်)
          setState(() {
            staffList.add({
              "id": _idController.text,
              "name": _nameController.text,
              "role": _selectedRole,
              "status": "Active"
            });
          });
        } else {
          // Update Logic (လိုအပ်လျှင် DatabaseService မှာ ထပ်တိုးနိုင်သည်)
          int realIndex = staffList.indexOf(staff);
          setState(() {
            staffList[realIndex] = {
              "id": _idController.text,
              "name": _nameController.text,
              "role": _selectedRole,
              "status": staff['status']
            };
          });
        }

        _clearControllers();
        if (mounted) Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Success!")),
        );
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }

  void _showStaffDialog({Map<String, dynamic>? staff, int? index}) {
    if (staff != null) {
      _idController.text = staff['id'];
      _nameController.text = staff['name'];
      _selectedRole = staff['role'];
    } else {
      _clearControllers();
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(staff == null ? "Register New Staff" : "Edit Staff Info",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(_idController, "Staff ID", enabled: staff == null),
                  const SizedBox(height: 15),
                  _buildTextField(_nameController, "Full Name"),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRole,
                        isExpanded: true,
                        items: ['Admin', 'Chef', 'Waiter'].map((String role) {
                          return DropdownMenuItem<String>(value: role, child: Text(role));
                        }).toList(),
                        onChanged: (newValue) => setDialogState(() => _selectedRole = newValue!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () => _handleRegister(staff), // 👈 ဤနေရာတွင် logic ပြောင်းလိုက်သည်
                child: Text(staff == null ? "Register" : "Update",
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> staff) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to remove ${staff['name']}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                setState(() => staffList.remove(staff));
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  void _clearControllers() {
    _idController.clear();
    _nameController.clear();
    _selectedRole = 'Waiter';
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        filled: !enabled,
        fillColor: enabled ? Colors.transparent : Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int adminCount = staffList.where((s) => s['role'] == 'Admin').length;
    int chefCount = staffList.where((s) => s['role'] == 'Chef').length;
    int waiterCount = staffList.where((s) => s['role'] == 'Waiter').length;

    List<Map<String, dynamic>> filteredList = _selectedFilter == 'All'
        ? staffList
        : staffList.where((s) => s['role'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("STAFF MANAGEMENT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                _buildSummaryCard("Admins", adminCount.toString(), Colors.purple),
                const SizedBox(width: 10),
                _buildSummaryCard("Chefs", chefCount.toString(), Colors.orange),
                const SizedBox(width: 10),
                _buildSummaryCard("Waiters", waiterCount.toString(), Colors.blue),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: ['All', 'Admin', 'Chef', 'Waiter'].map((role) {
                bool isSelected = _selectedFilter == role;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(role),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = role;
                      });
                    },
                    selectedColor: Colors.black,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text("No staff found in this category"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final staff = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getRoleColor(staff['role']).withValues(alpha: 0.1),
                            child: Text(staff['name'][0],
                                style: TextStyle(color: _getRoleColor(staff['role']), fontWeight: FontWeight.bold)),
                          ),
                          title: Text(staff['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("ID: ${staff['id']} • ${staff['role']}"),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') _showStaffDialog(staff: staff);
                              if (value == 'delete') _confirmDelete(staff);
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 10), Text("Edit")])),
                              const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(children: [
                                    Icon(Icons.delete, color: Colors.red, size: 20),
                                    SizedBox(width: 10),
                                    Text("Delete", style: TextStyle(color: Colors.red))
                                  ])),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStaffDialog(),
        backgroundColor: Colors.black,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}