/// 🌟 App တစ်ခုလုံးအတွက် Menu Shared Data
List<Map<String, dynamic>> sharedMenuList = [
  {
    "name": "Special Fried Rice",
    "category": "Main Dish",
    "isAvailable": true,
  },
  {
    "name": "Spicy Ramen",
    "category": "Noodles",
    "isAvailable": true,
  },
  {
    "name": "Chicken Curry",
    "category": "Curry",
    "isAvailable": true,
  },
  {
    "name": "Coca Cola",
    "category": "Drink",
    "isAvailable": true,
  },
];

/// 🌟 Order History Shared Data
List<Map<String, dynamic>> orderHistory = [
  {
    "orderId": "ORD-1001",
    "table": "Table 04",
    "items": "Spicy Ramen x2, Coca Cola x1",
    "total": "14,500",
    "time": "12:30 PM",
    "status": "Completed"
  },
  {
    "orderId": "ORD-1002",
    "table": "Table 01",
    "items": "Special Fried Rice x1, Coca Cola x2",
    "total": "9,500",
    "time": "01:15 PM",
    "status": "Completed"
  },
  {
    "orderId": "ORD-1003",
    "table": "Table 08",
    "items": "Chicken Curry x1, Spicy Ramen x1",
    "total": "12,000",
    "time": "02:00 PM",
    "status": "Completed"
  },
];

/// 🌟 ယနေ့ရောင်းရငွေ စုစုပေါင်းကို တွက်ပေးမည့် Function
double calculateTodayRevenue() {
  double total = 0;
  for (var order in orderHistory) {
    // String price "14,500" ကို "," ဖြုတ်ပြီး double ပြောင်းမယ်
    String priceStr = order['total'].replaceAll(',', '');
    total += double.parse(priceStr);
  }
  return total;
}

/// 🌟 Inventory Shared Data
List<Map<String, dynamic>> inventoryList = [
  {
    "itemName": "Ramen Noodles",
    "category": "Raw Material",
    "stock": 50, // ကီလိုဂရမ် သို့မဟုတ် ထုပ်
    "unit": "kg",
    "minThreshold": 10, // ၁၀ အောက်ရောက်ရင် သတိပေးမယ်
  },
  {
    "itemName": "Chicken Breast",
    "category": "Meat",
    "stock": 8,
    "unit": "kg",
    "minThreshold": 15, // ဒါဆိုရင် Low Stock ဖြစ်နေပြီ
  },
  {
    "itemName": "Coca Cola",
    "category": "Drink",
    "stock": 120,
    "unit": "cans",
    "minThreshold": 24,
  },
];

/// 🌟 Staff Member List
List<Map<String, dynamic>> staffList = [
  {"id": "S001", "name": "Aung Aung", "role": "Admin", "status": "Active"},
  {"id": "S002", "name": "Su Su", "role": "Chef", "status": "Active"},
  {"id": "S003", "name": "Kyaw Kyaw", "role": "Waiter", "status": "On Leave"},
];