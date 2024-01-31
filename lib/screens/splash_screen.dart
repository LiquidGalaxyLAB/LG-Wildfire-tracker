import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wildfiretracker/screens/home_screen.dart';
import 'package:wildfiretracker/screens/lg_settings_sreen.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final _imageRows = [
    [
      'assets/images/lg-logo.png',
      'assets/images/gsoc.png',
      'assets/images/flutter-lleida.png',
    ],
    [
      'assets/images/lglab-logo.png',
      'assets/images/lgeu-logo.png',
      'assets/images/laboratoris-tic-logo.png',
      'assets/images/pcital-logo.jpg',
    ],
    [
      'assets/images/logo-eps.png',
      'assets/images/logo-udl.png',
      'assets/images/nasa-firms.png',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
           // MaterialPageRoute(builder: (context) => const LGSettings()));
           MaterialPageRoute(builder: (context) => const HomePage()));
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.only(bottom: 16),
                child: Image.asset('assets/images/logo.jpeg'),
              ),
              ..._imageRows
                  .map(
                    (images) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images
                            .map(
                              (img) => Container(
                                alignment: Alignment.center,
                                width: screenWidth / images.length * 0.9,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Image.asset(img),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
