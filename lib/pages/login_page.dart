import 'package:flutter/material.dart';
import 'package:flutter_game_2048/pages/menu_page.dart';
import 'package:flutter_game_2048/pages/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_game_2048/components/front_Button.dart';
import 'package:flutter_game_2048/components/front_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;


    final bool isValid = await checkUsernamePassword(username, password);
    if (!isValid) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username or password"), duration: Duration(seconds: 1),),
      );
      return;
    }

    // Store login status and username
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
    await prefs.setString('username', username); // ← Save this idiot string

    if (!context.mounted) return;

    // ไปที่ menu
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MenuPage()),
    );
  }

  Future<bool> checkUsernamePassword(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://2048-api.vercel.app/check-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['valid'] == true;
      } else {
        print("Server responded with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
            
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
            
                const SizedBox(height: 30),
            
                // welcome back
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
            
                const SizedBox(height: 25),
            
                // username textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                  validator: (value) {
                    //เช็ค ว่าในช่องมันว่างมั้ยหรือไม่มีค่าไรเลย
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    } else if (value.contains(';')) {
                      return 'Not valid username';
                    } else {
                      return null;
                    }
                  },
            
                ),
            
                const SizedBox(height: 20),
            
                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.contains(';')) {
                      return 'Not valid password';
                    } else {
                      return null;
                    }
                  },
                ),
            
                const SizedBox(height: 60),
            
                // sign in button
                MyButton(
                  label: "Sign in",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      signUserIn();
                    }
                  },
                ),
            
                const SizedBox(height: 30),
            
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      //ข้อความ ไม่มีสามารชิก
                      'not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                         Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpPage()),
                        );
                      },
                      child: SizedBox(
                        child: const Text(
                          'register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}