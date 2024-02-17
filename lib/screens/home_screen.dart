import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/lg_settings_sreen.dart';
import 'package:flutterapp/utils/theme.dart';

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
      'asset': 'assets/images/fire.png',
      'icon': false
    },
    {
      'name': 'Settings',
      'route': '/settings',
      'asset': '',
      'icon': Icons.settings
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
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
        body: SingleChildScrollView(
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 400,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                // physics: NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (BuildContext context, int index) {
                  return FadeIn(
                      duration: Duration(milliseconds: 1000),
                      delay: Duration(seconds: (1.0 + index).round()),
                      child: serviceContainer(
                          services[index]['asset']!,
                          services[index]['name']!,
                          services[index]['route']!,
                          services[index]['icon']!,
                          index));
                }),
          ),
          SizedBox(
            height: 20,
          ),
        ])));
  }

  serviceContainer(String asset, String name, String route, dynamic icon, int index) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: ThemeColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon is IconData)
                Icon(icon,
                size: 65,),
              if (asset != '')
                Image.asset(asset, height: 65),
              const SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: const TextStyle(fontSize: 20),
              )
            ]),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
