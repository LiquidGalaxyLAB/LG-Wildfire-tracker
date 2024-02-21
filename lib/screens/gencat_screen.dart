import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wildfiretracker/entities/kml/kml_entity.dart';
import 'package:wildfiretracker/services/gencat/fire_perimeter.dart';
import 'package:wildfiretracker/services/gencat/gencat_service.dart';
import 'package:wildfiretracker/services/gencat/historic_year.dart';
import 'package:wildfiretracker/services/nasa/nasa_service.dart';
import 'package:wildfiretracker/widgets/button.dart';
import 'package:wildfiretracker/widgets/gencat_fire_perimeter_card.dart';
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
  late HistoricYear _selectedHisotricYear;

  bool _loadingFirePerimeterData = false;

  LGService get _lgService => GetIt.I<LGService>();
  GencatService  get _gencatService => GetIt.I<GencatService>();

  late List<FirePerimeter> _firePerimeterData = [];
  late dynamic _selectedFirePerimeterData = false;

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
              child: Row(
                children: [
                  Expanded(
                    child: DropdownSearch<HistoricYear>(
                      /*clearButtonProps: ClearButtonProps(
                              isVisible: true,
                            ),*/
                      onChanged: (HistoricYear? hy) {
                        _selectedHisotricYear = hy!;
                      },
                      enabled: true,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          label: Text('Select historic year'),
                          prefixIcon: Icon(Icons.flag),
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          hintText: 'Select year',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      dropdownButtonProps: const DropdownButtonProps(
                        icon: Icon(Icons.arrow_drop_down),
                        selectedIcon: Icon(Icons.arrow_drop_up),
                      ),
                      /*dropdownBuilder: (context, selectedItem) =>
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Row(children: [
                                Icon(Icons.flag),
                                SizedBox(width: 8),
                                Text(
                                  selectedItem?.name ?? 'Select country',
                                )
                              ]),
                            ),*/
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search year',
                          ),
                        ),
                      ),
                      filterFn: (item, filter) => item.year.toString().contains(filter.toLowerCase()),
                      itemAsString: (item) => item.year.toString(),
                      items: HistoricYear.getLocalHistoricYears(),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: ThemeColors.primaryColor,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () {
                        getHistoricFirePerimeter();
                      },
                    ),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Button(
                onPressed: () async {
                  List<FirePerimeter> fp = await _gencatService.getFirePerimeters('incendis22');
                  print(fp[38]);
                  await _lgService.clearKml();
                  await _lgService.sendKml(fp[38].toKMLEntity());
                  await _lgService.flyTo(
                      fp[38].toLookAtEntity());

                  await _lgService.sendTour(
                      fp[38].buildOrbit(), 'Orbit');
                  await _lgService.startTour('Orbit');

                  /*_lgService.sendTour(
                      satelliteData.buildOrbit(), 'Orbit');*/
                },
                label: 'Test',
              )),
          _loadingFirePerimeterData
              ? _buildSpinner()
              : Expanded(
              child: Padding(
                padding:
                const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                child: SizedBox(
                    width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                    child: _firePerimeterData.isEmpty
                        ? _buildEmptyMessage('No live fire data.')
                        : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _firePerimeterData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GencatFirePerimeterCard(
                            firePerimeter: _firePerimeterData[index],
                            selected: _selectedFirePerimeterData is FirePerimeter &&
                                _firePerimeterData[index].properties.codiFinal ==
                                _selectedFirePerimeterData.properties.codiFinal,
                            disabled: false,
                            onBalloonToggle: (value) {
                              //onStationBalloonToggle!(_satelliteData[index], value);
                            },
                            onOrbit: (value) {
                              //onStationOrbit!(value);
                            },
                            onView: (firePerimeter) async {

                              await _lgService.flyTo(
                                  firePerimeter.toLookAtEntity());
                              /*_lgService.sendKml(
                                  satelliteData.toPlacemarkEntity(),
                                  images: SatelliteData.getFireImg());

                              _lgService.flyTo(
                                  satelliteData.toLookAtEntity());

                              _lgService.sendTour(
                                  satelliteData.buildOrbit(), 'Orbit');*/

                              //onStationView!(station);
                            },
                            onMaps: (firePerimeter) async {
                              /*String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${satelliteData.latitude},${satelliteData.longitude}";
                              if (!await launchUrlString(googleMapsUrl)) {
                                showSnackbar(context, "Could not open the map.");
                              }*/
                            },
                          ),
                        );
                      },
                    )),
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

  void getHistoricFirePerimeter() async {
    setState(() {
      _loadingFirePerimeterData = true;
    });

    _firePerimeterData = await _gencatService.getFirePerimeters('incendis22');

    setState(() {
      _loadingFirePerimeterData = false;
    });
  }

}
