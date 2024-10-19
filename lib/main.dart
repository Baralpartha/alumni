import 'package:flutter/material.dart';
import 'package:alumni/carousel_screen.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ৩ সেকেন্ড পর কারোসেল স্ক্রিনে যাবে
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CarouselScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/ndccc.png', // আপনার লোগো ইমেজের পাথ
          width: 150, // ইমেজের প্রস্থ (আপনার ইচ্ছামত পরিবর্তন করতে পারেন)
          height: 150, // ইমেজের উচ্চতা (আপনার ইচ্ছামত পরিবর্তন করতে পারেন)
        ),
      ),
    );
  }
}