import 'package:flutter/material.dart';

class NasaApiPage extends StatefulWidget {
  const NasaApiPage({super.key});

  @override
  State<NasaApiPage> createState() => _NasaApiState();
}

class _NasaApiState extends State<NasaApiPage> {

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
          const Padding(
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
        ])));
  }

}
