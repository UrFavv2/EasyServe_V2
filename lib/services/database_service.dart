import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  // ➕ ဝန်ထမ်းအသစ်ထည့်ရန် (Insert Staff)
  Future<void> addStaff(String name, String role, String pin) async {
    await supabase.from('staff').insert({
      'name': name,
      'role': role,
      'pin_code': pin,
      'status': 'Active',
    });
  }

  // 📥 ဝန်ထမ်းစာရင်းကို Database မှ ပြန်ယူရန် (Stream သုံးရင် Real-time ရတယ်)
  Stream<List<Map<String, dynamic>>> getStaffStream() {
    return supabase.from('staff').stream(primaryKey: ['id']).order('id');
  }

  // database_service.dart ထဲမှာ ထည့်ရန်
Future<Map<String, dynamic>?> loginWithPin(String pin) async {
  final response = await supabase
      .from('staff')
      .select()
      .eq('pin_code', pin)
      .eq('status', 'Active')
      .maybeSingle(); // PIN တစ်ခုတည်းနဲ့ လူတစ်ယောက်ပဲ ရှိရမယ်

  return response;
}

Stream<List<Map<String, dynamic>>> getMenuItemsStream() {
  // 'menu_items' အစား 'menu_with_categories' လို့ ပြောင်းလိုက်တာပါ
  return supabase.from('menu_with_categories').stream(primaryKey: ['id']).order('item_name');
}
}