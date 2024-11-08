import 'package:flutter/material.dart';
import '../models/auth_service.dart'; // Import AuthService
import 'package:provider/provider.dart'; // For using AuthService with provider

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  double currentBalance = 0.0; // Initialize with default value
  final TextEditingController _topUpController = TextEditingController();

  // Method to perform top-up operation
  Future<void> _topUp() async {
    double? amount = double.tryParse(_topUpController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid amount')),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService
          .topUp(amount.toString()); // Call top-up method from AuthService

      setState(() {
        currentBalance +=
            amount; // Update the current balance after successful top-up
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Top Up Successful!')),
      );

      // Navigate to the payment page after successful top-up
      Navigator.pushReplacementNamed(
          context, '/payment'); // Assuming '/payment' is the payment page route
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance AuthService
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              // Header
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Back to previous screen
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Kembali",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Top Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Card Saldo with dynamic balance
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
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
                    SizedBox(height: 4),
                    Text(
                      "Rp ${currentBalance.toStringAsFixed(2)}", // Display dynamic balance
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
              SizedBox(height: 46),

              // Input for Top Up amount
              Text(
                "Silahkan masukan",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 4),
              Text(
                "nominal Top Up",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 64),

              // TextField for entering the top-up amount
              TextField(
                controller: _topUpController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.money),
                  hintText: "10.000",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24),

              // Nominal selection buttons
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildNominalButton("Rp10.000")),
                      SizedBox(width: 8),
                      Expanded(child: _buildNominalButton("Rp20.000")),
                      SizedBox(width: 8),
                      Expanded(child: _buildNominalButton("Rp50.000")),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildNominalButton("Rp100.000")),
                      SizedBox(width: 8),
                      Expanded(child: _buildNominalButton("Rp250.000")),
                      SizedBox(width: 8),
                      Expanded(child: _buildNominalButton("Rp500.000")),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 64),

              // Top Up button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    double? amount = double.tryParse(_topUpController.text);
                    if (amount == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid amount')),
                      );
                    } else {
                      try {
                        await authService.topUp(amount.toString());
                        setState(() {
                          currentBalance += amount;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Top Up Successful!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to top up')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "Top Up",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build the nominal buttons
  Widget _buildNominalButton(String nominal) {
    return OutlinedButton(
      onPressed: () {
        _topUpController.text =
            nominal.replaceAll('Rp', '').replaceAll('.', '');
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Text(
        nominal,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
