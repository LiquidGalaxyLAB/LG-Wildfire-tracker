
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wildfiretracker/utils/storage_keys.dart';
import 'package:wildfiretracker/utils/theme.dart';

import '../services/local_storage_service.dart';

class CustomBody extends StatefulWidget {
  var content;

  CustomBody({super.key, required this.content});

  @override
  CustomBodyState createState() => CustomBodyState();
}

class CustomBodyState extends State<CustomBody> {
  String _selectedMenu = '/nasa';

  // get current named page and set to _selectedMenu
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeName = ModalRoute.of(context)?.settings.name;
      setState(() {
        _selectedMenu = routeName ?? '/nasa'; // default to '/nasa' if routeName is null
      });
    });
    // check on local store if LG is connected
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        NavigationDrawer(
          onMenuSelected: (menu) {
            setState(() {
              _selectedMenu = menu;
            });
            Navigator.pushReplacementNamed(context, menu);
          },
          isMenuSelected: (menu) {
            return _selectedMenu == menu;
          },
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:  Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child:  widget.content,
              )),
        ),
      ],
    );
  }
}


class NavigationDrawer extends StatelessWidget {
  final Function(String) onMenuSelected;
  final Function(String) isMenuSelected;

  NavigationDrawer({required this.onMenuSelected, required this.isMenuSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 140.0,
      child: Container(
        color: ThemeColors.paltetteColor2,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Center(child: Image.asset('assets/images/logo_gsoc24_black_round.png')),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _createDrawerItem(name:'/nasa', icon: Icons.local_fire_department, text: 'Live Fire', onTap: () =>  onMenuSelected('/nasa'), isSelected: () => isMenuSelected('/nasa')),
                  _createDrawerItem(name:'/gencat', icon: Icons.forest, text: 'Historic Wildfire', onTap: () => onMenuSelected('/gencat'), isSelected: () => isMenuSelected('/gencat')),
                  _createDrawerItem(name:'/precisely-usa-forest-fire-risk', icon: Icons.forest_outlined, text: 'Forest Fire Risk', onTap: () => onMenuSelected('/precisely-usa-forest-fire-risk'), isSelected: () => isMenuSelected('/precisely-usa-forest-fire-risk')),
                  _createDrawerItem(name:'/settings', icon: Icons.settings, text: 'Settings', onTap: () => onMenuSelected('/settings'), isSelected: () => isMenuSelected('/settings')),
                  _createDrawerItem(name:'/about', icon: Icons.info, text: 'About', onTap: () => onMenuSelected('/info'), isSelected: () => isMenuSelected('/info')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _createDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap, required String name, required Function() isSelected}) {
    return ListTile(
      focusColor: ThemeColors.warning,
      hoverColor: ThemeColors.warning,
      selectedColor: ThemeColors.info,
      //selected: true,
      titleAlignment: ListTileTitleAlignment.center,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          // get selectedMenu from CustomBodyState
        isSelected() ?
          Container(
            width: 5,
            height: 70,
            color: ThemeColors.primaryColor,
          ) :   SizedBox(height: 70, width: 5,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.black,size: 40),
              Container(
                  width: 100,
                  child: Text(
                text, textAlign: TextAlign.center, softWrap: true, overflow: TextOverflow.clip,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),)),


            ],
          ),
          SizedBox(height: 70, width: 5,)
        ],
      ),
      onTap: onTap,
      selectedTileColor: ThemeColors.primaryColor,
      tileColor: ThemeColors.primaryColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

}