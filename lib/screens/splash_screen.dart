import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'home_screen.dart';

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
      'assets/images/logo-eps.png',
      'assets/images/logo-udl.png',
    ],
    [
      'assets/images/lglab-logo.png',
      'assets/images/lgeu-logo.png',
      'assets/images/laboratoris-tic-logo.png',
      'assets/images/pcital-logo.jpg',
      'assets/images/nasa-firms.png',
    ],
    [
      'assets/images/bombers-catalunya.jpg',
      'assets/images/generalitat-de-catalunya.png'
    ]
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    /*Timer(const Duration(seconds: 3), (){

    });*/

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
                //transformAlignment: Alignment.center,
                //padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  // Adjust the border radius as needed.
                  child: Center(child: Image.asset('assets/images/logo.jpeg')),
                ), // Image.asset('assets/images/logo.jpeg'),
              ),
              Expanded(
                child: ResponsiveGridView.builder(
                  gridDelegate: const ResponsiveGridDelegate(
                    maxCrossAxisExtent: 180,
                    // Maximum item size.
                    childAspectRatio: 1,
                    // Aspect ratio for items.
                    crossAxisSpacing: 16,
                    // Horizontal spacing between items.
                    mainAxisSpacing: 16,
                    // Vertical spacing between items.
                    minCrossAxisExtent: 100,
                    // Minimum item size.
                    crossAxisExtent: 180, // Maximum item size.
                  ),
                  alignment: Alignment.bottomCenter,
                  //maxRowCount: 4,
                  shrinkWrap: false,
                  padding: const EdgeInsets.all(16),
                  itemCount: _imageRows.expand((images) => images).length,
                  // Total number of items.
                  itemBuilder: (context, index) {
                    var img =
                        _imageRows.expand((images) => images).elementAt(index);
                    return FadeIn(
                        duration: Duration(milliseconds: 1000),
                        delay: Duration(milliseconds: (250 * index).round()),
                        child: Image.asset(img));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }
}
