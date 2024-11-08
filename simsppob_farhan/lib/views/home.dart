import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String? userName;
  String? balance;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profile =
          await Provider.of<AuthService>(context, listen: false).getProfile();
      setState(() {
        userName = '${profile['first_name']} ${profile['last_name']}';
      });
    } catch (e) {
      print("Error loading profile data: $e");
    }
  }

  List<Map<String, dynamic>> services = [
    {'icon': 'assets/PBB.png', 'label': 'PBB'},
    {'icon': 'assets/Listrik.png', 'label': 'Listrik'},
    {'icon': 'assets/Pulsa.png', 'label': 'Pulsa'},
    {'icon': 'assets/PDAM.png', 'label': 'PDAM'},
    {'icon': 'assets/PGN.png', 'label': 'PGN'},
    {'icon': 'assets/Televisi.png', 'label': 'Televisi'},
    {'icon': 'assets/Musik.png', 'label': 'Musik'},
    {'icon': 'assets/Game.png', 'label': 'Game'},
    {'icon': 'assets/Makanan.png', 'label': 'Makanan'},
    {'icon': 'assets/Kurban.png', 'label': 'Kurban'},
    {'icon': 'assets/Zakat.png', 'label': 'Zakat'},
    {'icon': 'assets/Data.png', 'label': 'Data'},
  ];

  List<String> banners = [
    'assets/Banner 1.png',
    'assets/Banner 2.png',
    'assets/Banner 3.png',
    'assets/Banner 4.png',
    'assets/Banner 5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/Logo.png', width: 16, height: 16),
                      SizedBox(width: 4),
                      Text(
                        'SIMS PPOB',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage('assets/Profile Photo.png'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Selamat datang,",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              Text(
                userName ?? "Loading...",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Background Saldo.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Saldo anda",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      balance != null ? "Rp $balance" : "Loading...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "Lihat Saldo",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Wrap(
                spacing: 6,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: services.map((service) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 6 - 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          child: Image.asset(
                            service['icon']!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          service['label']!,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              Text(
                'Temukan promo menarik',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 200,
                      margin: EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          banners[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
