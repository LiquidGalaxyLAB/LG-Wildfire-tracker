import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutterapp/services/nasa/nasa_service.dart';
import 'package:flutterapp/widgets/nasa_live_fire_card.dart';

import '../services/lg_service.dart';
import '../services/nasa/country.dart';
import '../services/nasa/satellite_data.dart';
import '../utils/snackbar.dart';
import '../utils/theme.dart';

class NasaApiPage extends StatefulWidget {
  const NasaApiPage({super.key});

  @override
  State<NasaApiPage> createState() => _NasaApiState();
}

class _NasaApiState extends State<NasaApiPage> {
  //bool _uploading = false;

  late List<Country> _contries = [];
  late List<SatelliteData> _satelliteData = [];

  late SatelliteData _selectedSatelliteData = SatelliteData();
  late Country _selectedCountry = Country();

  bool _loadingCountries = true;
  bool _loadingSatelliteData = false;


  LGService get _lgService => GetIt.I<LGService>();

  NASAService get _nasaService => GetIt.I<NASAService>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'NASA - Current Live Fire',
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
                    child: DropdownSearch<Country>(
                      /*clearButtonProps: ClearButtonProps(
                              isVisible: true,
                            ),*/
                      onChanged: (Country? country) {
                        _selectedCountry = country!;
                      },
                      enabled: !_loadingCountries,
                      dropdownDecoratorProps: DropDownDecoratorProps(
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
                      filterFn: (item, filter) => item.name.contains(filter),
                      itemAsString: (item) => item.name,
                      items: _contries,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
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
          _loadingSatelliteData
              ? _buildSpinner()
              : Expanded(
                  child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  child: SizedBox(
                      width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                      child: _satelliteData.isEmpty
                          ? _buildEmptyMessage('No live fire data.')
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _satelliteData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: NasaLiveFireCard(
                                    satelliteData: _satelliteData[index],
                                    selected: _satelliteData[index].id ==
                                        _selectedSatelliteData.id,
                                    disabled: false,
                                    onBalloonToggle: (value) {
                                      //onStationBalloonToggle!(_satelliteData[index], value);
                                    },
                                    onOrbit: (value) {
                                      //onStationOrbit!(value);
                                    },
                                    onView: (satelliteData) {
                                      _lgService.sendKml(
                                          satelliteData.toPlacemarkEntity(),
                                          images: SatelliteData.getFireImg());

                                      _lgService.flyTo(
                                          satelliteData.toLookAtEntity());

                                      _lgService.sendTour(
                                          satelliteData.buildOrbit(), 'Orbit');

                                      //onStationView!(station);
                                    },
                                    onMaps: (satelliteData) async {
                                      String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${satelliteData.latitude},${satelliteData.longitude}";
                                      if (!await launchUrlString(googleMapsUrl)) {
                                        showSnackbar(context, "Could not open the map.");
                                      }
                                    },
                                  ),
                                );
                              },
                            )),
                )),
        ]));
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

  void getLiveFireByCountry() {
    setState(() {
      _loadingSatelliteData = true;
    });
    _nasaService
        .getLiveFire(countryAbbreviation: _selectedCountry.abbreviation)
        .then((satelliteData) {
      _satelliteData = satelliteData;
      setState(() {
        _loadingSatelliteData = false;
      });
    }).onError((error, stackTrace) {
      _satelliteData = [];
      setState(() {
        _loadingSatelliteData = false;
      });
      showSnackbar(context, 'NASA Api Timeout');
    });
  }

  @override
  void initState() {
    super.initState();
    getCountries();
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
