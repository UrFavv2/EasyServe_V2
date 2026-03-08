import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  // ------------------ STAFF & LOGIN ------------------

  // ဝန်ထမ်းအသစ်ထည့်ရန်
  Future<void> addStaff(String name, String role, String pin) async {
    await supabase.from('staff').insert({
      'name': name,
      'role': role,
      'pin_code': pin,
      'status': 'Active',
    });
  }

  // ဝန်ထမ်းစာရင်း (Real-time Stream)
  Stream<List<Map<String, dynamic>>> getStaffStream() {
    return supabase.from('staff').stream(primaryKey: ['id']).order('id');
  }

  // Login စစ်ဆေးရန်
  Future<Map<String, dynamic>?> loginWithPin(String pin) async {
    final response = await supabase
        .from('staff')
        .select()
        .eq('pin_code', pin)
        .eq('status', 'Active')
        .maybeSingle(); 
    return response;
  }

  // ------------------ TABLES & REALTIME ------------------

  // Table status တွေကို Real-time ကြည့်ရန် (ဒါကိုသုံးရင် အရောင်ချက်ချင်းပြောင်းမယ်)
  Stream<List<Map<String, dynamic>>> getTablesStream() {
    return supabase.from('tables').stream(primaryKey: ['id']).order('table_number');
  }

  // Bill ရှင်းပြီးတဲ့အခါ Table ကို Available ပြန်ပြောင်းရန်
  Future<void> updateTableToAvailable(int tableId) async {
    await supabase
        .from('tables')
        .update({'status': 'Available'})
        .eq('id', tableId);
  }

  // ------------------ MENU & ORDERS ------------------

  // Menu items (Real-time Stream)
  Stream<List<Map<String, dynamic>>> getMenuItemsStream() {
    return supabase
        .from('menu_with_categories')
        .stream(primaryKey: ['id'])
        .order('item_name');
  }

  // Table တစ်ခုရဲ့ နောက်ဆုံး Pending ဖြစ်နေတဲ့ Order Items တွေကို ဆွဲယူရန်
  Future<List<Map<String, dynamic>>> fetchPendingOrderItems(int tableId) async {
    try {
      final orderData = await supabase
          .from('orders')
          .select('id')
          .eq('table_id', tableId)
          .eq('status', 'Pending')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (orderData == null) return [];

      final int orderId = orderData['id'];

      final items = await supabase
          .from('order_items')
          .select()
          .eq('order_id', orderId);
      
      return items;
    } catch (e) {
      return [];
    }
  }

  // Bill ရှင်းပြီးပါက Order status ကို Completed ပြောင်းရန်
  Future<void> completeOrder(int tableId) async {
    await supabase
        .from('orders')
        .update({'status': 'Completed'})
        .eq('table_id', tableId)
        .eq('status', 'Pending');
  }

  // ================= KITCHEN ADD-ONS (ဘာမှမပြင်ဘဲ အောက်မှာ ပေါင်းထည့်ပေးထားပါသည်) =================

  // ၁။ Kitchen အတွက် Pending ဖြစ်နေသော Order အားလုံးကို Real-time Stream ဖြင့် ကြည့်ရန်
  Stream<List<Map<String, dynamic>>> getKitchenOrdersStream() {
    return supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('status', 'Pending') // ချက်ရန်ကျန်နေသည်များကိုပဲ ပြမည်
        .order('created_at', ascending: true); // အရင်မှာသောသူကို အပေါ်ဆုံးတွင် ပြမည်
  }

  // ၂။ Order တစ်ခုအတွင်းရှိ ဟင်းပွဲများကို အမည်နှင့်တကွ ဆွဲယူရန် (Order Card ထဲတွင် ပြရန်)
  Future<List<Map<String, dynamic>>> fetchOrderItemsWithNames(int orderId) async {
    try {
      final response = await supabase
          .from('order_items')
          .select('''
            quantity,
            notes,
            menu_items (item_name)
          ''')
          .eq('order_id', orderId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  // ၁။ Kitchen ကနေ ဟင်းချက်ပြီးကြောင်း Notification ပို့ရန်
Future<void> sendKitchenReadyNotification(int orderId, int tableId) async {
  await supabase.from('notifications').insert({
    'order_id': orderId,
    'table_id': tableId,
    'message': 'Order for Table $tableId is ready to serve!',
    'is_read': false,
  });
}

// ၂။ Waiter UI အတွက် Notification များကို Real-time Stream ကြည့်ရန်
Stream<List<Map<String, dynamic>>> getNotificationsStream() {
  return supabase
      .from('notifications')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);
}
}