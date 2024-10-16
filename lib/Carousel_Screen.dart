import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({Key? key}) : super(key: key);

  @override
  _CarouselScreenState createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  late double carouselHeight; // Declare a variable for carousel height

  @override
  void initState() {
    super.initState();
    // Automatically navigate to LoginScreen after 7 seconds
    Future.delayed(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive carousel height for small and large screens
    carouselHeight = screenHeight * (screenWidth < 700 ? 0.7 : 0.7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alapon-NDC90', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
        leading: null,
      ),
      body: Column(
        children: [
          // Carousel Slider
          CarouselSlider(
            options: CarouselOptions(
              height: carouselHeight, // Use responsive height here
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 16 / 9,
            ),
            items: [
              _carouselItem('assets/images/slider1.png', 'Explore Opportunities', 'Join our network and grow.'),
              _carouselItem('assets/images/sliderb.jpg', 'Stay Connected', 'Be a part of our alumni community.'),
              _carouselItem('assets/images/sliderc.jpg', 'Stay Connected', 'Be a part of our alumni community.'),
            ],
          ),
          const Spacer(),
          // Center the Skip Button
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width:80,
                // Set a fixed width for the box
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent, // Background color of the box
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white), // Bold text
                  ),
                ),
              ),
            ),
          ),


          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Carousel item builder
  Widget _carouselItem(String imagePath, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.black.withOpacity(0.2)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}