import 'package:chatbot/main.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Your AI , Reimagined',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color:  Color.fromARGB(255, 141, 8, 250),
                ),
              ),
              SizedBox(height: 8), // Add spacing between title and description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                '"Introducing "ZephAI" - a fast, intelligent, and seamless AI, inspired by the effortless flow of the wind.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Image.asset('assets/onboarding.png'),
          SizedBox(
            width: 300, // Adjust the width as needed
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder:(context)=>const MyHomePage(title: 'chatbot',)),
                  (route)=>false
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 141, 8, 250), // Set button color
                foregroundColor: Colors.white, // Set text/icon color
                padding: EdgeInsets.symmetric(vertical: 12), // Increase height padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Continue'),
                  SizedBox(width: 8), // Correct spacing in a row
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
