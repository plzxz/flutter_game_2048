import 'package:flutter/material.dart';
import 'package:flutter_game_2048/components/front_Button.dart';
import 'package:flutter_game_2048/components/front_textfield.dart';
import 'package:flutter_game_2048/pages/login_page.dart';
import 'package:flutter_game_2048/pages/menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});
  
  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  // sign user in method
  Future<void> signUserUp() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // check username exists
    final exists = await checkUsernameExists(username);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username already exists"),duration: Duration(seconds: 1),),
      );
      return;
    }

    // register new user
    final url = Uri.parse('https://2048-api.vercel.app/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Store user in local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        await prefs.setString('username', username);

        if (!context.mounted) return;

        // Go to menu
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MenuPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to register"),duration: Duration(seconds: 1),),
        );
      }
    } catch (e) {
      print("Registration error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong"),duration: Duration(seconds: 1),),
      );
    }
  }

  //check username
  Future<bool> checkUsernameExists(String username) async {
    final url = Uri.parse('https://2048-api.vercel.app/check-username/$username'); // <- change this if deployed
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exists'] == true;
      } else {
        throw Exception('Failed to check username');
      }
    } catch (e) {
      print("Error checking username: $e");
      return true;
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
                  Icons.person_add_alt_1,
                  size: 100,
                ),
            
                const SizedBox(height: 30),
            
                // welcome back, you've been missed!
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
                      } else if (value.length < 6) {
                        return 'Password need to be 6 character long';
                      } else {
                        return null;
                      }
                    },
                ),
            
                const SizedBox(height: 20),
            
                // password confirm textfield
                MyTextField(
                  controller: passwordConfirmController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.contains(';')) {
                        return 'Not valid password';
                      } else if (value != passwordController.text) {
                        return 'password dose not match';
                      } else {
                        return null;
                      }
                    },
                ),
            
                const SizedBox(height: 60),
            
                // sign up button
                MyButton(
                  label: "Sign Up",
                  onTap: () {
                    if(_formKey.currentState!.validate()) {
                      signUserUp();
                    }
                  },
                ),
            
                const SizedBox(height: 30),
            
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a Member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                         Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: SizedBox(
                        child: const Text(
                          'Go to Login',
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