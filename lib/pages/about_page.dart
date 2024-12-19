import 'package:flutter/material.dart';

import '../constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About us'),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: kContainerColor,
        ),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                kStringAboutTeam,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Mission',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                kStringMissionText,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
