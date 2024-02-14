import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wildfiretracker/entities/kml/kml_entity.dart';
import 'package:wildfiretracker/services/gencat/fire_perimeter.dart';
import 'package:wildfiretracker/services/gencat/gencat_service.dart';
import 'package:wildfiretracker/services/nasa/nasa_service.dart';
import 'package:wildfiretracker/widgets/button.dart';
import 'package:wildfiretracker/widgets/nasa_live_fire_card.dart';

import '../services/lg_service.dart';
import '../services/nasa/country.dart';
import '../services/nasa/satellite_data.dart';
import '../utils/snackbar.dart';
import '../utils/theme.dart';

class GencatPage extends StatefulWidget {
  const GencatPage({super.key});

  @override
  State<GencatPage> createState() => _GencatState();
}

class _GencatState extends State<GencatPage> {
  LGService get _lgService => GetIt.I<LGService>();
  GencatService  get _gencatService => GetIt.I<GencatService>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Generalitat Catalunya - Historic Wildfire',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            splashRadius: 24,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.local_fire_department_outlined),
            )
          ],
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select the country of live fires:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Button(
                onPressed: () async {
                  List<FirePerimeter> fp = await _gencatService.getFirePerimeters('incendis22');
                  print(fp[38]);
                  _lgService.clearKml();
                  _lgService.sendKml(fp[38].toKMLEntity());
                  _lgService.flyTo(
                      fp[38].toLookAtEntity());

                  /*_lgService.sendTour(
                      satelliteData.buildOrbit(), 'Orbit');*/
                },
                label: 'Test',
              )),
        ]));
  }

  @override
  void initState() {
    super.initState();
  }

  /// Builds the list empty warn message.
  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Builds the spinner container that is used into the satellites and ground
  /// stations lists.
  Widget _buildSpinner() {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(color: ThemeColors.primaryColor)
        ]),
      ),
    );
  }

}
