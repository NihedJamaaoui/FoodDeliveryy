import 'package:flutter/material.dart';
import 'package:projet/pages/home.dart';
import 'package:projet/database/AuthProvider.dart';
import 'package:projet/pages/admin.dart';
import 'package:projet/pages/login.dart';
import 'package:projet/pages/register.dart';
import 'package:provider/provider.dart';

import 'database/DatabaseProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<FoodDataProvider>(
          create: (_) => FoodDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Food App',
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/admin': (context) => AdminPage(),
          '/home': (context) => HomeScreen(),
          '/add_food': (context) => AddFoodForm(onFoodAdded: () {}),
        },
      ),
    );
  }
}
