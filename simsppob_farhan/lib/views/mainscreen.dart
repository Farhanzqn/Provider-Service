import 'package:flutter/material.dart';

import 'home.dart';
import 'topup.dart';
import 'transaction.dart';
import 'profile.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    TopUpPage(),
    TransactionPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Top Up"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: "Transaction"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Akun"),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
