import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  static late SharedPreferences sharedPreferences;


  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }


  static Future<bool> putBool({required String key, required bool value})async
  {
   return await sharedPreferences.setBool(key, value);
  }


  static String getString({required String key})
  {
    final data = sharedPreferences.getString(key) ?? '';
    print('SharedPref reading $key: $data');
    return data;
  }


  static int getInteger({required String key})
  {
    return  sharedPreferences.getInt(key) ?? 0;
  }


  static bool getBool({required String key})
  {
    return  sharedPreferences.getBool(key) ?? true;
  }


  static List<String> getStringList({required String key})
  {
    return  sharedPreferences.getStringList(key) ?? [];
  }


  static Future<bool> saveData({required String key, required dynamic value}) async
  {
    print('SharedPref to writing $key: $value');
     if(value is String) {
       return await sharedPreferences.setString(key, value);
     } else if(value is bool) {
       return await sharedPreferences.setBool(key, value);
     } else if(value is int) {
       return await sharedPreferences.setInt(key, value);
     } else if(value is double){
       return await sharedPreferences.setDouble(key, value);
     } else if(value is List<String>){
       return await sharedPreferences.setStringList(key, value);
     } else {
       return false;
     }

  }


  static Future<bool> removeData({required String key,}) async
  {
    return await sharedPreferences.remove(key);
  }

}