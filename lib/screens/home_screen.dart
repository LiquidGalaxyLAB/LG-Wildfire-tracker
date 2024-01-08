import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:wildfiretracker/screens/lg_settings_sreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  List<Map<String, String>> services = [
    {
      'name': 'NASA',
      'route': '/nasa',
      'imageUrl':
          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'
    },
    {
      'name': 'Test1',
      'route': '/nasa',
      'imageUrl':
          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'
    },
    {
      'name': 'Test2',
      'route': '/nasa',
      'imageUrl':
          'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png'
    },
    {
      'name': 'Test3',
      'route': '/nasa',
      'imageUrl':
          'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png'
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
                    MaterialPageRoute(builder: (context) => LGSettings()));
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
                          services[index]['imageUrl']!,
                          services[index]['name']!,
                          services[index]['route']!,
                          index));
                }),
          ),
          SizedBox(
            height: 20,
          ),
        ])));
  }

  serviceContainer(String image, String name, String route, int index) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(image, height: 45),
              SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 15),
              )
            ]),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
