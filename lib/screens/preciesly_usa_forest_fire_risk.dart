import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart' as loc;
import 'package:uuid/uuid.dart';
import 'package:wildfiretracker/services/precisely/fire_risk.dart';
import 'package:wildfiretracker/services/precisely/precisely_service.dart';

import '../entities/kml/kml_entity.dart';
import '../services/lg_service.dart';
import '../utils/body.dart';
import '../utils/custom_appbar.dart';
import '../utils/snackbar.dart';
import '../utils/theme.dart';


class PreciselyUsaForestFireRisk extends StatefulWidget {
  const PreciselyUsaForestFireRisk({super.key});

  @override
  State<PreciselyUsaForestFireRisk> createState() =>
      _PreciselyUsaForestFireRisk();
}

class _PreciselyUsaForestFireRisk extends State<PreciselyUsaForestFireRisk> {

  FireRisk _fireRisk = FireRisk();

  final ValueNotifier<bool> _loadingFireRisk = ValueNotifier<bool>(false);

  GoogleMapController? _mapsController;

  bool _orbiting = false;
  bool _searched = false;

  LGService get _lgService => GetIt.I<LGService>();

  PreciselyService get _preciselyService => GetIt.I<PreciselyService>();
  final _addressController = TextEditingController();
  var uuid = const Uuid();

  final String googleApiKey = dotenv.get('GOOGLE_MAPS_APY_KEY');

  GoogleMapController? mapController;
  LatLng? pickedLocation = const LatLng(37.7749, -122.4194);

  TextEditingController controller = TextEditingController();


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
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
                      'Text forest fire risk:',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        // todo: fer que al seleccionar del mapa es fiqui l'adreça.
                        child: GooglePlaceAutoCompleteTextField(
                          textEditingController: _addressController,
                          googleAPIKey: googleApiKey,
                          inputDecoration: const InputDecoration(
                            label: Text('Select address'),
                            prefixIcon: Icon(Icons.edit_road_sharp),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            hintText: 'Select address',
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
                          debounceTime: 400,
                          countries: const ["us"],
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (Prediction prediction) {
                            print("placeDetails${prediction.lat}");
                          },
                          itemClick: (Prediction prediction) {
                            setState(() {
                              _addressController.text =
                                  prediction.description ?? "";
                              _addressController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: prediction.description?.length ??
                                          0));
                            });
                          },
                          seperatedBuilder: Container(
                              color: ThemeColors.backgroundColor,
                              child: Divider()),
                          // containerHorizontalPadding: 10,

                          itemBuilder: (context, index, Prediction prediction) {
                            return Container(
                              color: ThemeColors.backgroundColor,
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Expanded(
                                      child: Text(prediction.description ?? ""))
                                ],
                              ),
                            );
                          },
                          isCrossBtnShown: true,
                        ),
                        /*TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        label: Text('Select address'),
                        prefixIcon: Icon(Icons.edit_road_sharp),
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        hintText: 'Select address',
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
                      onTap: () async {
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid street address';
                        }
                        return null;
                      },
                    )*/
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeColors.primaryColor,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          color: Colors.white,
                          onPressed: () {
                            // todo: fer que al cercar, faci la crida a la api i faci print
                            pickedLocation = null;
                            getFireRiskByAddress();
                          },
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
                          icon: const Icon(Icons.map),
                          color: Colors.white,
                          onPressed: () async {
                            await _pickLocationOnMap();
                          },
                        ),
                      ),
                    ],
                  )),
              /*Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {

                  },
                  child: ListTile(
                    title: Text(_placeList[index]["description"]),
                  ),
                );
              },
            ),
          ),*/
              _loadingFireRisk.value
                  ? _buildSpinner()
                  : Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(padding: const EdgeInsets.only(
                          top: 15.0, left: 20.0, right: 20.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Expanded(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        top: 20.0, left: 10.0, right: 10.0),
                                    child: SizedBox(
                                      //width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                                      child: _fireRisk.noharmId.isEmpty
                                          ? _buildEmptyMessage(
                                          'No fire risk data.')
                                          : ListView(
                                        padding: const EdgeInsets.all(16.0),
                                        children: [
                                          _buildCard('State', _fireRisk.state),
                                          _buildCard(
                                              'No Harm ID', _fireRisk.noharmId),
                                          _buildCard('No Harm Class',
                                              _fireRisk.noharmCls),
                                          _buildCard(
                                              'No Harm Model',
                                              _fireRisk.noharmModel),
                                          _buildCard(
                                              'Risk Description',
                                              _fireRisk.riskDesc),
                                          _buildCard(
                                              'Risk 50',
                                              _fireRisk.risk50.toString()),
                                          _buildCard(
                                              'Severity',
                                              _fireRisk.severity.toString()),
                                          _buildCard(
                                              'Frequency',
                                              _fireRisk.frequency.toString()),
                                          _buildCard(
                                              'Community',
                                              _fireRisk.community.toString()),
                                          _buildCard('Damage',
                                              _fireRisk.damage.toString()),
                                          _buildCard('Mitigation',
                                              _fireRisk.mitigation.toString()),
                                          _buildMapCard(
                                              'Severity Group Elements',
                                              _fireRisk.severityGroupElements),
                                          _buildMapCard(
                                              'Frequency Group Elements',
                                              _fireRisk.frequencyGroupElements),
                                          _buildMapCard(
                                              'Community Group Elements',
                                              _fireRisk.communityGroupElements),
                                          _buildMapCard('Damage Group Elements',
                                              _fireRisk.damageGroupElements),
                                          _buildMapCard(
                                              'Mitigation Group Elements',
                                              _fireRisk
                                                  .mitigationGroupElements),
                                          _buildMapCard(
                                              'Geometry', _fireRisk.geometry),
                                          _buildMapCard(
                                              'Matched Address',
                                              _fireRisk.matchedAddress),
                                          _buildCard('Centered Latitude',
                                              _fireRisk.centeredLatitude
                                                  .toString()),
                                          _buildCard('Centered Longitude',
                                              _fireRisk.centeredLongitude
                                                  .toString()),
                                          _buildCard('Area',
                                              _fireRisk.area.toString()),
                                        ],
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(10),
                                        tapTargetSize: MaterialTapTargetSize
                                            .padded,
                                        alignment: Alignment.centerRight,
                                        backgroundColor:
                                        _searched
                                            ? ThemeColors.primaryColor
                                            : Colors.grey,
                                      ),
                                      icon: Icon(
                                        Icons.travel_explore_rounded,
                                        color: ThemeColors.backgroundColor,
                                      ),
                                      label: Text(
                                        'VIEW IN LG',
                                        style: TextStyle(
                                          color: ThemeColors.backgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        viewFirePerimeter(showBallon: true);
                                      },
                                    ),
                                  const SizedBox(width: 16.0),
                                   TextButton.icon(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(10),
                                        tapTargetSize: MaterialTapTargetSize
                                            .padded,
                                        alignment: Alignment.centerRight,
                                        backgroundColor:
                                        _searched
                                            ? ThemeColors.primaryColor
                                            : Colors.grey,
                                      ),
                                      icon: Icon(
                                        !_orbiting
                                            ? Icons.flip_camera_android_rounded
                                            : Icons.stop_rounded,
                                        color: _searched
                                            ? ThemeColors.backgroundColor
                                            : ThemeColors.backgroundColor,
                                      ),
                                      label: Text(
                                        'ORBIT',
                                        style: TextStyle(
                                          color: _searched
                                              ? ThemeColors.backgroundColor
                                              : ThemeColors.backgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        //print(_fireRisk.getColorByRiskTest(34));
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          )
                      ),
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
                                target: LatLng(39.8283, -98.5795),
                                // Coordinates for the center of the USA
                                zoom: 4.0,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId(_fireRisk.noharmId),
                                  position: LatLng(_fireRisk.centeredLatitude,
                                      _fireRisk.centeredLongitude),
                                  infoWindow: InfoWindow(
                                    title: _fireRisk.state,
                                    snippet: _fireRisk.riskDesc,
                                  ),
                                )
                              },
                              /*polygons: {
                            Polygon(
                              polygonId: PolygonId(_fireRisk.noharmId),
                              points: _fireRisk?.geometry['coordinates']?[0]
                                  ?.map((e) => LatLng(e[1], e[0]))
                                  ?.toList() ?? [],
                              //fillColor: _fireRisk.getColorByRisk(),
                              //strokeColor: _fireRisk.getColorByRisk(),
                              strokeWidth: 2,
                            )
                          },*/
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
            ])));
  }

  Future<void> _pinToLatLang(double lat, double lng, MarkerId markerId) async {
    // wait 1 second
    await Future.delayed(const Duration(seconds: 1));
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

  Future<void> _pickLocationOnMap() async {
    loc.Location location = loc.Location();
    bool _serviceEnabled;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    /*_permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }*/

    /*final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng initialPosition = LatLng(position.latitude, position.longitude);*/

    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            child: Container(
              height: 400,
              child: GoogleMap(
                /*initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 14,
            ),*/
                initialCameraPosition: CameraPosition(
                  target: pickedLocation ?? const LatLng(37.7749, -122.4194),
                  zoom: 10,
                ),
                onMapCreated: (controller) {
                  mapController = controller;
                },
                onTap: (LatLng location) {
                  setState(() {
                    pickedLocation = location;
                    _addressController.text =
                    '${location.latitude}, ${location.latitude}';
                  });
                  getFireRiskByAddress();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
    );
  }

  Widget _buildGoogleMap() {
    return pickedLocation == null
        ? Center(child: Text('No location selected'))
        : GoogleMap(
      initialCameraPosition: CameraPosition(
        target: pickedLocation!,
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: MarkerId('selected-location'),
          position: pickedLocation!,
        ),
      },
    );
  }


  Widget _buildCard(String title, String content) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(content),
      ),
    );
  }

  Widget _buildMapCard(String title, Map<String, dynamic> map) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(title),
        children: map.entries
            .map((entry) =>
            ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value.toString()),
            ))
            .toList(),
      ),
    );
  }

  void getFireRiskByAddress() {
    setState(() {
      _loadingFireRisk.value = true;
      _searched = false;
    });
    _preciselyService
        .getFireRisk(_addressController.text, pickedLocation)
        .then((fireRisk) async {
      _fireRisk = fireRisk;
      setState(() {
        _loadingFireRisk.value = false;
        _searched = true;
        _pinToLatLang(_fireRisk.centeredLatitude, _fireRisk.centeredLongitude,
            MarkerId(_fireRisk.noharmId));
      });
    }).onError((error, stackTrace) {
      setState(() {
        _fireRisk = FireRisk();
        _loadingFireRisk.value = false;
        _searched = false;
      });
      if (kDebugMode) print(error);
      showSnackbar(context, 'Preciesly Api Timeout');
    });
  }

  Widget _buildSpinner() {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

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

  Future<void> viewFirePerimeter({required bool showBallon}) async {
    await _lgService.sendKml(_fireRisk.toKMLEntity(),
        images: FireRisk.getRiskImg());
    if (showBallon) {
      final kmlBalloon = KMLEntity(
        name: '',
        content: _fireRisk
            .toPlacemarkEntity()
            .balloonOnlyTag,
      );
      await _lgService.sendKMLToSlave(
        _lgService.balloonScreen,
        kmlBalloon.body,
      );
    }
    await _lgService.flyTo(_fireRisk.toLookAtEntity());
    await _lgService.sendTour(_fireRisk.buildOrbit(), 'Orbit');
  }

/*Future<void> displayPrediction(Prediction p, BuildContext context) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKey);
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);

      final address = detail.result.addressComponents;

      String street = "";
      String city = "";
      String state = "";
      String zip = "";

      for (var component in address) {
        if (component.types.contains("street_number")) {
          street = component.longName;
        }
        if (component.types.contains("route")) {
          street += " ${component.longName}";
        }
        if (component.types.contains("locality")) {
          city = component.longName;
        }
        if (component.types.contains("administrative_area_level_1")) {
          state = component.shortName;
        }
        if (component.types.contains("postal_code")) {
          zip = component.longName;
        }
      }

      setState(() {
        _streetController.text = street;
        _cityController.text = city;
        _stateController.text = state;
        _zipController.text = zip;
      });
    }
  }*/
}