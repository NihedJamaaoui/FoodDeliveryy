import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet/Utilities/colors.dart';
import 'package:projet/Utilities/constant.dart';
import 'package:projet/database/DatabaseHelper.dart';
import 'package:projet/models/User.dart';
import 'package:provider/provider.dart';
import '../database/AuthProvider.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      final DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.initDatabase();

      final User? user = await dbHelper.getUserByEmail(email);

      if (user != null) {
        if (user.password == password) {
          if (user.isAdmin) {
            // Admin login
            Provider.of<AuthProvider>(context, listen: false).login();
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            Provider.of<AuthProvider>(context, listen: false).login();
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          _showErrorDialog('Login Failed', 'Incorrect password.');
        }
      } else {
        _showErrorDialog( 'Login Failed', 'User not found. Please sign up or check your credentials.');
      }
    } else {
      _showErrorDialog('Login Failed', 'Please enter both email and password.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize();

    return Scaffold(
      backgroundColor: backgroundclr,
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: backgroundclr,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'images/Logofood.png',
                height: screenSize.height * 0.3,
              ),
              SizedBox(height: 32.0),
              SizedBox(
                height: screenSize.height * 0.065,
                width: screenSize.width * 0.785,
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    fillColor: lbackgroundclr,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: screenSize.height * 0.065,
                width: screenSize.width * 0.785,
                child: TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    fillColor: lbackgroundclr,
                    filled: true,

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  primary: lbackgroundclr,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      size: 24,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text('Login'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
