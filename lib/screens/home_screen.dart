import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wildfiretracker/screens/lg_settings_sreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  List<Map<String, dynamic>> services = [
    {
      'name': 'NASA - Live Fire',
      'route': '/nasa',
      'asset': '',
      'icon': Icons.local_fire_department,
      'keys': [
        {'name': 'Fires', 'icon': Icons.fireplace_sharp},
        {'name': 'Countries', 'icon': Icons.public_outlined},
        {'name': 'Satellites', 'icon': Icons.satellite_alt},
        {'name': 'NASA', 'icon': Icons.data_saver_on}
      ]
    },
    {
      'name': 'GenCat - Historic Wildfire',
      'route': '/gencat',
      'asset': '',
      'icon': Icons.forest,
      'keys': [
        {'name': 'Fire perimeters', 'icon': Icons.polyline_outlined},
        {'name': 'Wildfires', 'icon': Icons.forest_outlined},
        {'name': 'Catalonia', 'icon': Icons.location_city},
        {'name': 'Historical', 'icon': Icons.history}
      ]
    },
    {
      'name': 'Preciesly - USA Forest Fire Risk',
      'route': '/precisely-usa-forest-fire-risk',
      'asset': '',
      'icon': Icons.forest_outlined,
      'keys': [
        {'name': 'Wildfires', 'icon': Icons.forest_outlined},
        {'name': 'USA', 'icon': Icons.location_city},
        {'name': 'Risk', 'icon': Icons.warning_amber}
      ]
    },
    {
      'name': 'Settings',
      'route': '/settings',
      'asset': '',
      'icon': Icons.settings,
      'keys': [
        {'name': 'LG Settings', 'icon': Icons.settings},
        {'name': 'LG Comands', 'icon': Icons.terminal},
        {'name': 'NASA API', 'icon': Icons.key}
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenAspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Home',
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
      body: Expanded(
          child: Column(children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //height: screenHeight,
          child: Container(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (screenWidth ~/ 300),
                  //childAspectRatio: screenAspectRatio*1.5,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                // physics: NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeIn(
                      duration: const Duration(milliseconds: 1000),
                      delay: Duration(seconds: (1.0 + index).round()),
                      child: serviceContainer(
                          services[index]['asset']!,
                          services[index]['name']!,
                          services[index]['route']!,
                          services[index]['icon']!,
                          services[index]['keys']!,
                          index));
                })
          )
        )
      ])),
    );
  }

  serviceContainer(String asset, String name, String route, dynamic icon,
      List<dynamic> keys, int index) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(20.0),
        decoration: ShapeDecoration(
          color: Colors.grey.shade100,
          shadows: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 6,
              offset: Offset(0, 2),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Color(0x4C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (icon is IconData)
                Icon(
                  icon,
                  size: 65,
                ),
              if (asset != '') Image.asset(asset, height: 65),
              const SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              ResponsiveGridView.builder(
                //addAutomaticKeepAlives: true,
                shrinkWrap: true,
                gridDelegate: const ResponsiveGridDelegate(
                  maxCrossAxisExtent: 200,
                  // Maximum extent of tiles in the grid along the cross axis.
                  minCrossAxisExtent: 100,
                  // Minimum extent of tiles in the grid along the cross axis.
                  childAspectRatio: 3.5,
                  // Aspect ratio for items.
                  crossAxisSpacing: 10,
                  // Horizontal spacing between items.
                  mainAxisSpacing: 10, // Vertical spacing between items.
                ),
                itemCount: keys.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Color(0x4C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 6, left: 8, right: 16, bottom: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                transformAlignment: Alignment.center,
                                child: Icon(
                                  keys[index]['icon'] as IconData,
                                  color: Colors.black,
                                  size: 15.0,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                keys[index]['name'].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF49454F),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
