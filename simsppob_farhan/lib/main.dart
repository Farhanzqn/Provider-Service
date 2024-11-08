import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/auth_service.dart';
import 'views/mainscreen.dart';
import 'views/login.dart';
import 'views/registrasi.dart';
import 'views/pembayaran.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthService()), // Provider untuk AuthService
      ],
      child: MaterialApp(
        title: 'SIMS PPOB',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: '/', // Route awal aplikasi
        routes: {
          '/': (context) => LoginView(), // Halaman awal
          '/home': (context) => MainScreen(), // Rute untuk halaman utama
          '/registration': (context) =>
              RegistrationView(), // Rute untuk halaman registrasi
        },
      ),
    );
  }
}
