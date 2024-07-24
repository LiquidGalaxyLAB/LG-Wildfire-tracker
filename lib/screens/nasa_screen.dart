import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wildfiretracker/utils/body.dart';
import 'package:wildfiretracker/utils/custom_appbar.dart';
import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wildfiretracker/services/nasa/country.dart';
import 'package:wildfiretracker/services/nasa/nasa_service.dart';
import 'package:wildfiretracker/services/nasa/satellite_data.dart';
import 'package:wildfiretracker/widgets/nasa_live_fire_card.dart';

import '../entities/kml/kml_entity.dart';
import '../services/lg_service.dart';
import '../utils/snackbar.dart';
import '../utils/theme.dart';

import '../utils/theme.dart';


class NasaApiPage extends StatefulWidget {
  @override
  _NasaApiPageState createState() => _NasaApiPageState();
}

class _NasaApiPageState extends State<NasaApiPage> {
  late List<Country> _contries = [];
  late List<SatelliteData> _satelliteData = [];

  late dynamic _selectedSatelliteData = false;
  late Country _selectedCountry = Country();

  bool _loadingCountries = true;

  // bool _loadingSatelliteData = false;
  final ValueNotifier<bool> _loadingSatelliteData = ValueNotifier<bool>(false);

  GoogleMapController? _mapsController;

  LGService get _lgService => GetIt.I<LGService>();

  NASAService get _nasaService => GetIt.I<NASAService>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ThemeColors.paltetteColor1,
        appBar: CustomAppBar(),
        body: CustomBody(
            content: Column(
                    mainAxisAlignment: MainAxisAlignment.start, children: [
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownSearch<Country>(
                              /*clearButtonProps: ClearButtonProps(
                              isVisible: true,
                            ),*/
                              onChanged: (Country? country) {
                                _selectedCountry = country!;
                              },
                              enabled: !_loadingCountries,
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  label: Text('Select country'),
                                  prefixIcon: Icon(Icons.flag),
                                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  hintText: 'Select country',
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
                              dropdownButtonProps: DropdownButtonProps(
                                icon: _loadingCountries
                                    ? const SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(),
                                )
                                    : Icon(Icons.arrow_drop_down),
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
                                    hintText: 'Search country',
                                  ),
                                ),
                              ),
                              filterFn: (item, filter) => item.name
                                  .toLowerCase()
                                  .contains(filter.toLowerCase()),
                              itemAsString: (item) => item.name,
                              items: _contries,
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
                              icon: Icon(Icons.search),
                              color: Colors.white,
                              onPressed: () {
                                getLiveFireByCountry();
                              },
                            ),
                          )
                        ],
                      )),
                  _loadingSatelliteData.value
                      ? _buildSpinner()
                      :
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0, bottom: 10.0),
                              child: ListView.builder(
                                itemCount: _satelliteData.length,
                                itemBuilder: (context, index) {
                                  return FadeIn(
                                      duration: Duration(milliseconds: 600),
                                      delay: Duration(
                                          milliseconds: (250 * 1).round()),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 16),
                                        child: NasaLiveFireCard(
                                          satelliteData:
                                          _satelliteData[index],
                                          selected: _selectedSatelliteData
                                          is SatelliteData &&
                                              _satelliteData[index].id ==
                                                  _selectedSatelliteData.id,
                                          disabled: false,
                                          onBalloonToggle:
                                              (satelliteData, showBallon) {
                                            viewSatelliteData(
                                                satelliteData: satelliteData,
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
                                          onView: (satelliteData) {
                                            setState(() {
                                              _selectedSatelliteData =
                                                  satelliteData;
                                            });
                                            viewSatelliteData(
                                                satelliteData: satelliteData,
                                                showBallon: true);
                                          },
                                          onMaps: (satelliteData) async {
                                            /*String googleMapsUrl =
                                                "https://www.google.com/maps/search/?api=1&query=${satelliteData.latitude},${satelliteData.longitude}";
                                            if (!await launchUrlString(
                                                googleMapsUrl)) {
                                              showSnackbar(context,
                                                  "Could not open the map.");
                                            }*/


                                          },
                                        ),
                                      ));
                                },
                              )
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                            ),
                            padding: const EdgeInsets.only(top: 15.0, right: 20.0, bottom: 5.0), // Adjust the padding as needed
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12), // Same as the outer container
                              child: GoogleMap(
                                initialCameraPosition: const CameraPosition(
                                  target: LatLng(10.7749, -122.4194), // replace with your initial coordinates
                                  zoom: 0.0,
                                ),

                                onMapCreated: (GoogleMapController controller) {
                                  setState(() {
                                    _mapsController = controller;
                                  });
                                },
                              ),
                            ),
                          )

                        ),
                      ],
                    ),
                  ),
                ])

                ));
  }

  void getCountries() {
    setState(() {
      _loadingCountries = true;
    });
    _nasaService.getCountries().then((countries) {
      _contries = countries;
      setState(() {
        _loadingCountries = false;
      });
    });
  }

  Future<void> _goToLatLang(double lat, double lng) async {
    // wait 1 second
    await Future.delayed(const Duration(seconds: 3));

    CameraPosition position = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(lat, lng),
      zoom: 5.0,
      tilt: 59.440717697143555,
    );
    setState(() {
      _mapsController?.animateCamera(CameraUpdate.newCameraPosition(position));
    });
  }

  Future<void> _goToCountry(String countryName) async {
    // wait 1 second
    //await Future.delayed(Duration(seconds: 5));
    Coordinates cords = await GeoCode().forwardGeocoding(address: _selectedCountry.name);
    CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 9.151926040649414);
    CameraPosition position = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(cords.latitude ?? 40.712776, cords.longitude ?? -74.005974),
      zoom: 6.0,
      tilt: 59.440717697143555,
    );
    //final GoogleMapController controller = await _mapsController.future;
    setState(() {
      _mapsController?.animateCamera(CameraUpdate.newCameraPosition(position));
    });
  }

  void getLiveFireByCountry() {
    //_goToLatLang(33.89589, 62.97857);
    //return;

    setState(() {
      _loadingSatelliteData.value = true;
    });
    _nasaService
        .getLiveFire(countryAbbreviation: _selectedCountry.abbreviation)
        .then((satelliteData) async {
      _satelliteData = satelliteData;
      setState(() {
        _loadingSatelliteData.value = false;
      });
      SatelliteData.setPlacemarkFromCoordinates(
          satelliteData, _loadingSatelliteData, refreshState);
      //_goToCountry(_selectedCountry.name);
      if (_satelliteData.isNotEmpty) {
        _goToLatLang(_satelliteData[0].latitude, _satelliteData[0].longitude);
      }

    }).onError((error, stackTrace) {
      _satelliteData = [];
      setState(() {
        _loadingSatelliteData.value = false;
      });
      showSnackbar(context, 'NASA Api Timeout');
    });
  }

  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  @override
  void dispose() {
    super.dispose();
    _loadingSatelliteData.dispose();
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

  Future<void> viewSatelliteData(
      {required SatelliteData satelliteData, required bool showBallon}) async {
    await _lgService.sendKml(satelliteData.toKMLEntity(),
        images: SatelliteData.getFireImg());
    if (showBallon) {
      final kmlBalloon = KMLEntity(
        name: '',
        content: satelliteData.toPlacemarkEntity().balloonOnlyTag,
      );
      await _lgService.sendKMLToSlave(
        _lgService.balloonScreen,
        kmlBalloon.body,
      );
    }
    await _lgService.flyTo(satelliteData.toLookAtEntity());
    await _lgService.sendTour(satelliteData.buildOrbit(), 'Orbit');
  }
}
