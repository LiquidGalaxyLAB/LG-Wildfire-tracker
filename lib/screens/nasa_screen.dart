import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:wildfiretracker/entities/kml/kml_entity.dart';
import 'package:wildfiretracker/entities/kml/look_at_entity.dart';
import 'package:wildfiretracker/services/nasa_service.dart';
import 'package:wildfiretracker/widgets/button.dart';
import 'package:wildfiretracker/widgets/nasa_live_fire_card.dart';

import '../services/lg_service.dart';
import '../utils/snackbar.dart';
import '../utils/theme.dart';

class NasaApiPage extends StatefulWidget {
  const NasaApiPage({super.key});

  @override
  State<NasaApiPage> createState() => _NasaApiState();
}

class _NasaApiState extends State<NasaApiPage> {
  bool _uploading = false;

  late List<Country> _contries = [];
  late List<SatelliteData> _satelliteData = [];

  late SatelliteData _selectedSatelliteData = SatelliteData();

  bool _loadingCountries = true;
  bool _loadingSatelliteData = true;

  List<DropdownMenuEntry> _contriesDropdownItemss = [];

  LGService get _lgService => GetIt.I<LGService>();

  NASAService get _nasaService => GetIt.I<NASAService>();

  get _contriesDropdownItems {
    List<DropdownMenuEntry> contriesDropdownItems = [];
    for (Country c in _contries) {
      contriesDropdownItems
          .add(DropdownMenuEntry(label: c.name, value: c.abbreviation));
    }

    return contriesDropdownItems;
  }

  @override
  void initState() {
    setState(() {
      _loadingCountries = true;
    });
    super.initState();
    _nasaService.getCountries().then((countries) {
      _contries = countries;

      setState(() {
        _loadingCountries = false;
      });

      for (Country c in _contries) {
        _contriesDropdownItemss
            .add(DropdownMenuEntry(label: c.name, value: c.abbreviation));
      }

      setState(() {
        //_contriesDropdownItemss = _contriesDropdownItemss;
      });
    });
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
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _viewExample() async {
    if (_uploading) {
      return;
    }

    try {
      setState(() {
        _uploading = true;
      });

      final timer = Timer(const Duration(seconds: 5), () {
        setState(() {
          //_satelliteBalloonVisible = true;
          //_selectedSatellite = null;
          //_satellitePlacemark = null;
          //_selectedStation = null;
          _uploading = false;
        });

        throw Exception('connection-timed-out');
      });

      // final result = await _sshService.connect();
      final result = 'session_connected';
      timer.cancel();

      if (result != 'session_connected') {
        setState(() {
          _uploading = false;
        });

        return showSnackbar(context, 'Connection failed');
      }

      /*final matchTLEs =
      _tles.where((element) => element.satelliteId == satellite.id);
      TLEEntity? tle = matchTLEs.isNotEmpty ? matchTLEs.toList()[0] : null;*/
      List<SatelliteData> satelliteData = await _nasaService.getLiveFire();

      if (satelliteData.isEmpty) {
        setState(() {
          _uploading = false;
        });

        return showSnackbar(context,
            'Connection failed'); // _showErrorDialog('No TLE available for this satellite!');
      }

      setState(() {
        //_selectedSatellite = satellite.id;
        //_selectedStation = null;
      });

      /*final tleCoord = tle.read();

      final transmitters = _transmitters
          .where((element) => element.satelliteId == satellite.id)
          .toList();

      final placemark = _satelliteService.buildPlacemark(
        satellite,
        tle,
        transmitters,
        showBalloon,
        orbitPeriod,
        lookAt: _satellitePlacemark != null && !updatePosition
            ? _satellitePlacemark!.lookAt
            : null,
        updatePosition: updatePosition,
      );*/

      SatelliteData sd = satelliteData.first;

      setState(() {
        //_satellitePlacemark = placemark;
      });

      final kml = KMLEntity(
        name: 'test', //satellite.name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
        content: sd.toPlacemarkEntity().tag,
      );

      await _lgService.sendKml(
        kml,
        images: [
          {
            'name': 'logo.jpeg',
            'path': 'assets/images/logo.jpeg',
          }
        ],
      );

      /*if (_lgService.balloonScreen == _lgService.logoScreen) {
        await _lgService.setLogos(
          name: 'SVT-logos-balloon',
          content: '''
            <name>Logos-Balloon</name>
            ${placemark.balloonOnlyTag}
          ''',
        );
      } else {
        final kmlBalloon = KMLEntity(
          name: 'SVT-balloon',
          content: placemark.balloonOnlyTag,
        );

        await _lgService.sendKMLToSlave(
          _lgService.balloonScreen,
          kmlBalloon.body,
        );
      }

      if (updatePosition) {
        await _lgService.flyTo(LookAtEntity(
          lat: tleCoord['lat']!,
          lng: tleCoord['lng']!,
          altitude: tleCoord['alt']!,
          range: '4000000',
          tilt: '60',
          heading: '0',
        ));
      }

      final orbit = _satelliteService.buildOrbit(satellite, tle);
      await _lgService.sendTour(orbit, 'Orbit');*/
    } on Exception catch (_) {
      showSnackbar(context, 'Connection failed');
    } catch (_) {
      showSnackbar(context, 'Connection failed');
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  void _testScreen() async {
    if (_uploading) {
      return;
    }

    try {
      setState(() {
        _uploading = true;
      });

      final timer = Timer(const Duration(seconds: 5), () {
        setState(() {
          //_satelliteBalloonVisible = true;
          //_selectedSatellite = null;
          //_satellitePlacemark = null;
          //_selectedStation = null;
          _uploading = false;
        });

        throw Exception('connection-timed-out');
      });

      // final result = await _sshService.connect();
      final result = 'session_connected';
      timer.cancel();

      if (result != 'session_connected') {
        setState(() {
          _uploading = false;
        });

        return showSnackbar(context, 'Connection failed');
      }

      /*final matchTLEs =
      _tles.where((element) => element.satelliteId == satellite.id);
      TLEEntity? tle = matchTLEs.isNotEmpty ? matchTLEs.toList()[0] : null;*/
      List<SatelliteData> satelliteData = await _nasaService.getLiveFire();

      if (satelliteData.isEmpty) {
        setState(() {
          _uploading = false;
        });

        return showSnackbar(context,
            'Connection failed'); // _showErrorDialog('No TLE available for this satellite!');
      }

      setState(() {
        _satelliteData = satelliteData;
        _loadingSatelliteData = false;
      });
    } on Exception catch (_) {
      showSnackbar(context, 'Connection failed');
    } catch (_) {
      showSnackbar(context, 'Connection failed');
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

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
            padding: EdgeInsets.only(left: 20.0, right: 10.0),
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
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*Button(
                    label: 'Test',
                    width: 150,
                    height: 48,
                    //icon: Icon(
                    //  Icons.connected_tv_rounded,
                    //  color: ThemeColors.backgroundColor,
                    //),
                    onPressed: () async {
                      //_viewExample();
                      _testScreen();
                    },
                  )*/
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                          child: DropdownSearch<Country>(
                            /*clearButtonProps: ClearButtonProps(
                              isVisible: true,
                            ),*/
                            enabled: !_loadingCountries,
                            dropdownButtonProps: DropdownButtonProps(
                              icon: _loadingCountries ? SizedBox(width: 10, height: 10, child: CircularProgressIndicator(),) : Icon(Icons.arrow_drop_down),
                              selectedIcon: Icon(Icons.arrow_drop_up),
                            ),
                            dropdownBuilder: (context, selectedItem) => Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Row(children: [
                                Icon(Icons.flag),
                                SizedBox(width: 8),
                                Text(
                                  selectedItem?.name ?? 'Select country',
                                )
                              ]),
                            ),
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  //contentPadding: EdgeInsets.fromLTRB(0, 25.0, 0, 0),
                                  hintText: 'Search country',
                                  //border: OutlineInputBorder(
                                  //  borderRadius: BorderRadius.circular(10),
                                  //),
                                ),
                              ),
                            ),
                            filterFn: (item, filter) =>
                                item.name.contains(filter),
                            itemAsString: (item) => item.name,
                            items: _contries,
                          ),
                        ),
                  Container(
                    color: Colors.black,
                    child: IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () {
                        // Handle button press here
                      },
                    ),
                  )
                ],
              )),
          _loadingSatelliteData
              ? _buildSpinner()
              : Expanded(
                  child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10.0),
                  child: SizedBox(
                      width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                      child: _satelliteData.isEmpty
                          ? _buildEmptyMessage('No satellite data.')
                          : ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _satelliteData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: NasaLiveFireCard(
                                    satelliteData: _satelliteData[index],
                                    selected: _satelliteData[index].id ==
                                        _selectedSatelliteData!.id,
                                    disabled: _uploading ?? false,
                                    onBalloonToggle: (value) {
                                      //onStationBalloonToggle!(_satelliteData[index], value);
                                    },
                                    onOrbit: (value) {
                                      //onStationOrbit!(value);
                                    },
                                    onView: (station) {
                                      //onStationView!(station);
                                    },
                                  ),
                                );
                              },
                            )),
                )),
        ]));
  }
}
