import 'package:animate_do/animate_do.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wildfiretracker/services/gencat/fire_perimeter.dart';
import 'package:wildfiretracker/services/gencat/gencat_service.dart';
import 'package:wildfiretracker/services/gencat/historic_year.dart';

import '../entities/kml/kml_entity.dart';
import '../services/lg_service.dart';
import '../utils/body.dart';
import '../utils/custom_appbar.dart';
import '../utils/snackbar.dart';
import '../utils/theme.dart';
import '../widgets/gencat_fire_perimeter_card.dart';

class GencatPage extends StatefulWidget {
  const GencatPage({super.key});

  @override
  State<GencatPage> createState() => _GencatState();
}

class _GencatState extends State<GencatPage> {
  late HistoricYear _selectedHisotricYear = HistoricYear(year: 0, filename: '');

  bool _loadingFirePerimeterData = false;

  LGService get _lgService => GetIt.I<LGService>();

  GoogleMapController? _mapsController;

  GencatService get _gencatService => GetIt.I<GencatService>();

  late List<FirePerimeter> _firePerimeterData = [];
  late dynamic _selectedFirePerimeterData = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: ThemeColors.paltetteColor1,
        appBar: CustomAppBar(),
        body: CustomBody(
          content:
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select the year of the historical Catalan forest fires:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                        filterFn: (item, filter) =>
                            item.year.toString().contains(filter.toLowerCase()),
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
            _loadingFirePerimeterData
                ? _buildSpinner()
                : Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 10.0),
                              child: _firePerimeterData.length == 0 ?
                                  _buildInfoMessage()
                                  : ListView.builder(
                                itemCount: _firePerimeterData.length,
                                itemBuilder: (context, index) {
                                  return FadeIn(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      delay: Duration(
                                          milliseconds: (250 * 1).round()),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: GencatFirePerimeterCard(
                                          firePerimeter:
                                              _firePerimeterData[index],
                                          selected: _selectedFirePerimeterData
                                                  is FirePerimeter &&
                                              _firePerimeterData[index]
                                                      .properties
                                                      .codiFinal ==
                                                  _selectedFirePerimeterData
                                                      .properties.codiFinal,
                                          disabled: false,
                                          onBalloonToggle:
                                              (firePerimeter, showBallon) {
                                            viewFirePerimeter(
                                                firePerimeter: firePerimeter,
                                                showBallon: showBallon);
                                          },
                                          onOrbit: (value) async {
                                            if (value) {
                                              await _lgService
                                                  .startTour('Orbit');
                                            } else {
                                              await _lgService.stopTour();
                                            }
                                          },
                                          onView: (firePerimeter) {
                                            setState(() {
                                              _selectedFirePerimeterData =
                                                  firePerimeter;
                                            });
                                            viewFirePerimeter(
                                                firePerimeter: firePerimeter,
                                                showBallon: true);
                                          },
                                          onMaps: (firePerimeter) async {
                                            /*String googleMapsUrl =
                                      "https://www.google.com/maps/search/?api=1&query=${firePerimeter.geometry.centeredLatitude},${firePerimeter.geometry.centeredLongitude}";
                                  if (!await launchUrlString(
                                      googleMapsUrl)) {
                                    showSnackbar(
                                        context, "Could not open the map.");
                                  }*/
                                            _pinToLatLang(
                                                firePerimeter
                                                    .geometry.centeredLatitude,
                                                firePerimeter
                                                    .geometry.centeredLongitude,
                                                MarkerId(firePerimeter
                                                    .properties.name));
                                          },
                                        ),
                                      ));
                                },
                              )),
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                12), // Adjust the radius as needed
                          ),
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 20.0, bottom: 5.0),
                          // Adjust the padding as needed
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            // Same as the outer container
                            child: GoogleMap(
                              initialCameraPosition: const CameraPosition(
                                target: LatLng(41.5912, 1.5209),
                                zoom: 7.0,
                              ),
                              markers: _firePerimeterData
                                  .map((e) => Marker(
                                        markerId: MarkerId(e.properties.name),
                                        position: LatLng(
                                            e.geometry.centeredLatitude,
                                            e.geometry.centeredLongitude),
                                        infoWindow: InfoWindow(
                                          title: e.properties.name,
                                          snippet: e.properties.dataIncen,
                                        ),
                                      ))
                                  .toSet(),
                              onMapCreated: (GoogleMapController controller) {
                                setState(() {
                                  _mapsController = controller;
                                });
                              },
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
          ]),
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _goToLatLang(double lat, double lng) async {
    // wait 1 second
    await Future.delayed(const Duration(seconds: 3));

    CameraPosition position = CameraPosition(
      //bearing: 80.8334901395799,
      target: LatLng(lat, lng),
      zoom: 5.0,
      //tilt: 59.440717697143555,
    );
    setState(() {
      _mapsController?.animateCamera(CameraUpdate.newCameraPosition(position));
    });
  }

  Future<void> _pinToLatLang(double lat, double lng, MarkerId markerId) async {
    // wait 1 second
    //await Future.delayed(const Duration(seconds: 3));
    CameraPosition position = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(lat, lng),
      zoom: 12.0,
      tilt: 59.440717697143555,
    );
    setState(() {
      _mapsController?.animateCamera(CameraUpdate.newCameraPosition(position));
      _mapsController?.showMarkerInfoWindow(markerId);
    });
  }

  Widget _buildInfoMessage() {
    return const Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(
            'This screen gives us the history of forest fires throughout Catalonia (Spain). Through the year we want, it allows us to obtain the perimeters and then we can send them to the LG',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500),
            softWrap: true,
          ),)
        ],
      ),
    );
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

    if (_selectedHisotricYear.filename == '') {
      showSnackbar(context, 'Please select a year.');
      setState(() {
        _loadingFirePerimeterData = false;
      });
      return;
    }

    try {
      _firePerimeterData = await _gencatService
          .getFirePerimeters(_selectedHisotricYear.filename);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        rethrow;
      }
      showSnackbar(context, 'Error getting fire perimeter data.');
    }

    setState(() {
      _loadingFirePerimeterData = false;
    });
  }

  Future<void> viewFirePerimeter(
      {required FirePerimeter firePerimeter, required bool showBallon}) async {
    if (kDebugMode) {
      print(showBallon);
    }
    if (kDebugMode) {
      print('show ballon');
    }

    await _lgService.sendKml(firePerimeter.toKMLEntity(),
        images: FirePerimeter.getFireImg());
    if (showBallon) {
      final kmlBalloon = KMLEntity(
        name: '',
        content: firePerimeter.toPlacemarkEntity().balloonOnlyTag,
      );
      await _lgService.sendKMLToSlave(
        _lgService.balloonScreen,
        kmlBalloon.body,
      );
    }
    await _lgService.flyTo(firePerimeter.toLookAtEntity());
    await _lgService.sendTour(firePerimeter.buildOrbit(), 'Orbit');
  }
}
