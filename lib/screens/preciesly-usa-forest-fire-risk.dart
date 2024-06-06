import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:wildfiretracker/services/lg_service.dart';
import 'package:wildfiretracker/services/precisely/precisely_service.dart';
import 'package:wildfiretracker/widgets/button.dart';

class PreciselyUsaForestFireRisk extends StatefulWidget {
  const PreciselyUsaForestFireRisk({super.key});

  @override
  State<PreciselyUsaForestFireRisk> createState() => _AddressInputScreenState();
}

class _PreciselyUsaForestFireRisk extends State<PreciselyUsaForestFireRisk> {

  LGService get _lgService => GetIt.I<LGService>();

  PreciselyService get _preciselyService  => GetIt.I<PreciselyService>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Precisely - USA Forest Fire Risk',
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
              child: Icon(Icons.forest_outlined),
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
                  'Write USA location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Button(onPressed: (){

            _preciselyService.getFireRisk('Death Valley National Park, USA').then((fr) {
              print(fr);
            });
            
          })
          /*Padding(
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
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 10.0, right: 10.0),
                  child: SizedBox(
                    //width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                    width: screenWidth,
                    child: _firePerimeterData.isEmpty
                        ? _buildEmptyMessage('There are no wildfire.')
                        : ResponsiveGridView.builder(
                      addAutomaticKeepAlives: true,
                      gridDelegate: ResponsiveGridDelegate(
                        //maxCrossAxisExtent: 180,
                        //crossAxisExtent: screenWidth >= 768? screenWidth / 2 - 224 : 360,
                        // Maximum item size.
                        childAspectRatio: 2.5,
                        // Aspect ratio for items.
                        crossAxisSpacing: 16,
                        // Horizontal spacing between items.
                        mainAxisSpacing: 16,
                        // Vertical spacing between items.
                        minCrossAxisExtent: screenWidth > 820? screenWidth / 2 - 224 : screenWidth-100,
                        // Minimum item size.
                      ),
                      alignment: Alignment.topCenter,
                      //maxRowCount: ,
                      shrinkWrap: false,
                      padding: const EdgeInsets.all(16),
                      itemCount: _firePerimeterData.length,
                      // Total number of items.
                      itemBuilder: (context, index) {
                        return FadeIn(
                            duration: Duration(milliseconds: 600),
                            delay: Duration(
                                milliseconds: (250 * 1).round()),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: GencatFirePerimeterCard(
                                firePerimeter: _firePerimeterData[index],
                                selected: _selectedFirePerimeterData
                                is FirePerimeter &&
                                    _firePerimeterData[index]
                                        .properties
                                        .codiFinal ==
                                        _selectedFirePerimeterData
                                            .properties.codiFinal,
                                disabled: false,
                                onBalloonToggle: (firePerimeter, showBallon) {
                                  viewFirePerimeter(
                                      firePerimeter: firePerimeter,
                                      showBallon: showBallon);
                                },
                                onOrbit: (value) async {
                                  if (value) {
                                    await _lgService.startTour('Orbit');
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
                                  String googleMapsUrl =
                                      "https://www.google.com/maps/search/?api=1&query=${firePerimeter.geometry.centeredLatitude},${firePerimeter.geometry.centeredLongitude}";
                                  if (!await launchUrlString(
                                      googleMapsUrl)) {
                                    showSnackbar(
                                        context, "Could not open the map.");
                                  }
                                },
                              ),
                            ));
                      },
                    ),
                  )
              )),*/
        ]));
  }

}



class _AddressInputScreenState extends State<PreciselyUsaForestFireRisk> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  final String googleApiKey = 'YOUR_GOOGLE_API_KEY';

  GoogleMapController? mapController;
  LatLng? pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                ),
                onTap: () async {
                  /*Prediction? p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: googleApiKey,
                    mode: Mode.overlay,
                    language: "en",
                    components: [Component(Component.country, "us")],
                  );
                  displayPrediction(p!, context);*/
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid street address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid state';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _zipController,
                decoration: InputDecoration(
                  labelText: 'ZIP Code',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 5) {
                    return 'Please enter a valid ZIP code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data
                    print("Street: ${_streetController.text}");
                    print("City: ${_cityController.text}");
                    print("State: ${_stateController.text}");
                    print("ZIP: ${_zipController.text}");
                  }
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _pickLocationOnMap();
                },
                child: Text('Pick Location on Map'),
              ),
              SizedBox(height: 300, child: _buildGoogleMap())
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickLocationOnMap() async {
    loc.Location location = loc.Location();
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng initialPosition = LatLng(position.latitude, position.longitude);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 400,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                pickedLocation = location;
              });
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