import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wildfiretracker/screens/nasa_screen.dart';

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
      'assets/images/gsoc20_years.png',
    ],
    [
      'assets/images/lgeu-logo.png',
      'assets/images/lglab-logo.png',
      'assets/images/gdglleida.png',
      'assets/images/flutter-lleida.png',
      'assets/images/laboratoris-tic-logo.png',
      'assets/images/parcagrobiotech.png',
    ],
    [
      'assets/images/logo-udl.png',
      'assets/images/logo-eps.png',
      'assets/images/android.png',
      'assets/images/flutter.png',
    ]
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = 16.0;
    double spacing = 8.0;
    double rowSpacing = 8.0;

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
                alignment: Alignment.center,
                //transformAlignment: Alignment.center,
                //padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.only(top: 16, bottom: 0),
                child: Center(child: Image.asset('assets/images/logo_gsoc24_round.png')),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _imageRows.asMap().entries.map((imageRow) {
                      int rowCount = imageRow.value.length;
                      double effectiveHeight = screenHeight*0.6 - (padding * 2) - (spacing * (rowCount - 1));
                      double effectiveWidth = screenWidth*0.90 - (padding * 2) - (spacing * (rowCount - 1));
                      double imageHeightSize = effectiveHeight / rowCount;
                      double imageWidthSize = effectiveWidth / rowCount;

                      return FadeIn(
                          duration: Duration(milliseconds: 300),
                          delay: Duration(milliseconds: (1500 * imageRow.key).round()),
                          child:
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: screenWidth * 0.05),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: spacing, // Space between images
                          runSpacing: spacing, // Space between rows
                          children: imageRow.value.map((imagePath) {
                            return Image.asset(
                              imagePath,
                              fit: BoxFit.contain,
                              width: imageWidthSize, // Dynamic width for each image
                              height: imageHeightSize, // Dynamic height for each image
                            );
                          }).toList(),
                        ),
                      ));
                    }).toList(),
                  ),
                ),
                /*child: ResponsiveGridView.builder(
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
                ),*/
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
        //MaterialPageRoute(builder: (context) => const HomePage()),
        MaterialPageRoute(builder: (context) => NasaApiPage()),
      );
    });
  }
}
