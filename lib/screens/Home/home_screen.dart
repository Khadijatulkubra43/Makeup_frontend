import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makeup Recommendation',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MakeupRecommendationScreen(),
    );
  }
}

class MakeupRecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFFF8D6E3), // Light pink/purple mix background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'WELCOME TO THE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'AI Glam Fusion',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Center Image
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png', // Path to your logo image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Star Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) =>
                      Icon(Icons.star, color: Colors.yellow[700], size: 18),
                ),
              ),
              SizedBox(height: 20),
              // Instruction Text
              Text(
                'Upload or capture an image to get makeup recommendations.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Get Recommendations Button
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.check),
                label: Text("Get Recommendations"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              SizedBox(height: 20),
              // Recommended Images List
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    4,
                    (index) {
                      // List of image assets for each model
                      final List<String> images = [
                        'assets/images/mode1.png',
                        'assets/images/model2.png',
                        'assets/images/model3.png',
                        'assets/images/model1.jpg',
                      ];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(images[index]),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                5,
                                (starIndex) => Icon(
                                  Icons.star,
                                  size: 15,
                                  color: starIndex <= index
                                      ? Colors.yellow[700]
                                      : Colors.grey[300],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              // About Us Paragraph
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                child: Text(
                  'About Us: AI Glam Fusion is your go-to solution for personalized makeup recommendations. Our advanced AI technology analyzes your features and suggests makeup styles that complement your unique look. Join us on this beauty journey to discover looks tailored just for you!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              // Bottom Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.facebook),
                    color: Colors.blue[900],
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.chat_bubble_outline),
                    color: Colors.grey[700],
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
