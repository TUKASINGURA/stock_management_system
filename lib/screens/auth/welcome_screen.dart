import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_stock_system/screens/auth/login_screen.dart';
import 'package:sales_stock_system/screens/auth/signup_screen.dart';
import 'package:sales_stock_system/screens/dashboard/dashboard.dart';

class StockManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get current date
    String currentDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    //Code for making sure the app fits on all the screen sizes
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 350;
    final isLargeScreen = screenSize.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16.0 : 24.0,
              vertical: isSmallScreen ? 16.0 : 32.0,
            ),
            constraints: BoxConstraints(
              minHeight: screenSize.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: isSmallScreen ? 10 : 30),
                    // Welcome text
                    Text(
                      'Welcome to Our Stock Management System',
                      style: TextStyle(
                        fontSize: isSmallScreen
                            ? 20
                            : isLargeScreen
                                ? 28
                                : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 15),
                    // Date
                    Text(
                      currentDate,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 40),
                    // Supermarket logo (replace with your actual logo)
                    Container(
                      width: isSmallScreen
                          ? 120
                          : isLargeScreen
                              ? 180
                              : 150,
                      height: isSmallScreen
                          ? 120
                          : isLargeScreen
                              ? 180
                              : 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        size: isSmallScreen
                            ? 60
                            : isLargeScreen
                                ? 100
                                : 80,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 40),
                  ],
                ),

                // Login/Signup section
                Column(
                  children: [
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to login screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                // builder: (context) => LoginPage()),

                                builder: (context) => DashboardScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 12 : 15,
                          ),
                          backgroundColor: Colors.blue[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 15),

                    // Sign up button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to sign up screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 12 : 15,
                          ),
                          side: BorderSide(color: Colors.blue[800]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 15),

                    // Forgot password
                    TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),

                // Social media icons
                Padding(
                  padding: EdgeInsets.only(
                    bottom: isSmallScreen ? 10 : 20,
                    top: isSmallScreen ? 20 : 40,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: isSmallScreen ? 10 : 15,
                    runSpacing: isSmallScreen ? 10 : 15,
                    children: [
                      SocialIcon(
                        icon: Icons.facebook,
                        color: Colors.blue[700]!,
                        isSmall: false,
                      ),
                      SocialIcon(
                        icon: Icons.camera_alt,
                        color: Colors.lightBlue[400]!, // Twitter
                        isSmall: false,
                      ),
                      SocialIcon(
                        icon: Icons.play_circle_fill,
                        color: Colors.red[700]!, // YouTube
                        isSmall: false,
                      ),
                      SocialIcon(
                        icon: Icons.music_note,
                        color: Colors.black, // TikTok
                        isSmall: false,
                      ),
                      SocialIcon(
                        icon: Icons.camera,
                        color: Colors.pink[600]!, // Instagram
                        isSmall: false,
                      ), // Instagram
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isSmall;

  const SocialIcon(
      {required this.icon, required this.color, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: isSmall ? 20 : 28, // ← Ternary operator in action
      ),
    );
  }
}
