import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wildfiretracker/entities/kml/look_at_entity.dart';
import 'package:wildfiretracker/services/nasa_service.dart';
import 'package:wildfiretracker/widgets/button.dart';

import '../services/lg_service.dart';
import '../utils/theme.dart';

class NasaApiPage extends StatefulWidget {
  const NasaApiPage({super.key});

  @override
  State<NasaApiPage> createState() => _NasaApiState();
}

class _NasaApiState extends State<NasaApiPage> {
  LGService get _lgService => GetIt.I<LGService>();
  NASAService get _nasaService => GetIt.I<NASAService>();


  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Test Nasa',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
              Row(
                children: [
                  Button(
                    label: 'Test',
                    width: 150,
                    height: 48,
                    //icon: Icon(
                    //  Icons.connected_tv_rounded,
                    //  color: ThemeColors.backgroundColor,
                    //),
                    onPressed: () async {

                      LookAtEntity lookAt = LookAtEntity(
                        lng: 0.760833,
                        lat: 42.001022,
                        range: '4000000',
                        tilt: '60',
                        heading: '0',
                      );

                      // _lgService.flyTo(lookAt);

                      // la llista de paisos per mostrar al drop down
                      List<Country> countries = await _nasaService.getCountryList();
                      print(countries);

                    },
                  )
                ],
              )
        ])));
  }

}
