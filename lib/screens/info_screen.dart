import 'package:flutter/material.dart';
import 'package:wildfiretracker/utils/body.dart';

import '../utils/custom_appbar.dart';
import '../utils/theme.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: ThemeColors.paltetteColor1,
        appBar: CustomAppBar(),
        body: CustomBody(content: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),
              Center(
                child: Image.asset(
                  'assets/images/logo_gsoc24_round.png', // Ensure this image is added to your assets folder
                  height: 200,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Wildfire Tracker for Liquid Galaxy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Monitoring of all fires in the world and the history of all Catalan wildfires.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The project will be a responsive Flutter application designed for tablets, which through an SSH connection and API calls, we will be able to represent the desired information on the LG. Additionally, the application will be autonomous, and without being connected to the LG, it will be able to represent and display information on the mobile device itself. The project will consist of two parts:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'The first part is intended to represent past forest fires, to see all the affected areas, the development of the forest fire, and all the information represented on the Liquid Galaxy.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'The second part will be to visualize real-time fires, whether they are forest fires or house fires, on the Liquid Galaxy and see their information.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'In the third part of the project, what is dealt with is to represent the risks of forest fires in the United States area.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'The Liquid Galaxy is a cluster of screens with Google Earth that synchronize with each other to create the sensation of a single screen, depending on the configuration it can be panoramic, vertical, curved, etc. Through this tool, we will be able to represent fires and see the impacts in an interactive and easy-to-see detail. Additionally, we will have many important data about the fire, such as the extent, emitted gases, possible victims, key points, extinguishing techniques, possible improvements, front speed, fire score, type of smoke column, smoke data, etc. All those data that we can extract from our API.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20.0,),
              Center(
                child: Image.asset(
                  'assets/images/collaborators.png', // Ensure this image is added to your assets folder
                  //height: 200,
                ),
              ),
            ],
          ),)
        )));
  }
}