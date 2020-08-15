import 'package:shared_preferences/shared_preferences.dart';

class Userinfo
{
  signedin()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", true);
  }

  Future<bool> issignin()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool issigned = prefs.getBool('login');
    if (issigned == null || issigned == false)
    {
      return false;
    }
    else
      return true;
  }
  logout()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", false);
  }

  username(name)
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", name);

  }

  Future<String> getusername()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString("user");
    return name;
  }
}