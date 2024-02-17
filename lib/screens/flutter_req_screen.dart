import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/entities/kml/look_at_entity.dart';
import 'package:flutterapp/entities/kml/orbit_entity.dart';
import 'package:flutterapp/entities/kml/tour_entity.dart';
import 'package:flutterapp/screens/lg_settings_sreen.dart';
import 'package:flutterapp/utils/theme.dart';
import 'package:get_it/get_it.dart';

import '../services/lg_service.dart';

class FlutterReqPage extends StatefulWidget {
  const FlutterReqPage({super.key});

  @override
  State<FlutterReqPage> createState() => _FlutterState();
}

class _FlutterState extends State<FlutterReqPage> {

  LGService get _lgService => GetIt.I<LGService>();

  LookAtEntity lae = LookAtEntity(
      lat: 42.002399,
      lng: 0.759925,
      altitude: 100,
      range: '1500',
      tilt: '60',
      heading: '0',
      altitudeMode: 'relativeToGround'
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Flutter Req. 2 - Gerard Monsó',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              icon: Icon(
                Icons.settings,
                color: Colors.grey.shade700,
                size: 30,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Buttons',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 400,
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              // physics: NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: 0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: ThemeColors.primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.flutter_dash,
                            size: 65,),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'My Home City - Fly To',
                            style: TextStyle(fontSize: 20),
                          )
                        ]),
                  ),
                  onTap: () {
                    _lgService.clearKml(keepLogos: true);
                    _lgService.flyTo(lae);
                  },
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: 0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: ThemeColors.primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.flutter_dash,
                            size: 65,),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'My Home City - Orbit',
                            style: TextStyle(fontSize: 20),
                          )
                        ]),
                  ),
                  onTap: () {
                      _lgService.clearKml(keepLogos: true);
                      _lgService.sendTour(OrbitEntity.buildOrbit(OrbitEntity.tag(lae)), 'Orbitt');
                      _lgService.startTour('Orbitt');
                    //_lgService.startTour('OrbitAger');
                  },
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: 0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(
                        color: ThemeColors.primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.flutter_dash,
                            size: 65,),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'My Home City - Bubble',
                            style: TextStyle(fontSize: 20),
                          )
                        ]),
                  ),
                  onTap: () {
                    //_lgService.stopTour();
                    _lgService.clearKml(keepLogos: true);

                  },
                ),

              ],
            ),
            ),
          SizedBox(
            height: 20,
          ),
        ])));
  }
}
