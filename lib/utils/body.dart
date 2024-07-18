
import 'package:flutter/material.dart';
import 'package:wildfiretracker/utils/theme.dart';

class CustomBody extends StatefulWidget {
  var content;

  CustomBody({super.key, required this.content});

  @override
  CustomBodyState createState() => CustomBodyState();
}

class CustomBodyState extends State<CustomBody> {
  String _selectedMenu = 'Home';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        NavigationDrawer(
          onMenuSelected: (menu) {
            setState(() {
              _selectedMenu = menu;
            });
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

  NavigationDrawer({required this.onMenuSelected});

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
                  _createDrawerItem(icon: Icons.local_fire_department, text: 'Live Fire', onTap: () => onMenuSelected('Home')),
                  _createDrawerItem(icon: Icons.forest, text: 'Historic Wildfire', onTap: () => onMenuSelected('Home')),
                  _createDrawerItem(icon: Icons.forest_outlined, text: 'Forest Fire Risk', onTap: () => onMenuSelected('Home')),
                  _createDrawerItem(icon: Icons.settings, text: 'Settings', onTap: () => onMenuSelected('Settings')),
                  _createDrawerItem(icon: Icons.info, text: 'About', onTap: () => onMenuSelected('About')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _createDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      focusColor: ThemeColors.warning,
      hoverColor: ThemeColors.warning,
      selectedColor: ThemeColors.info,
      //selected: true,
      titleAlignment: ListTileTitleAlignment.center,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: Colors.black,size: 40),
          Text(
              text, textAlign: TextAlign.center)
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


class AnimatedDrawerItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color selectedColor;
  final Color unselectedColor;
  final ValueChanged<bool> onTap;

  AnimatedDrawerItem({
    required this.icon,
    required this.title,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  _AnimatedDrawerItemState createState() => _AnimatedDrawerItemState();
}

class _AnimatedDrawerItemState extends State<AnimatedDrawerItem> with SingleTickerProviderStateMixin {
  bool isSelected = false;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: widget.unselectedColor,
      end: widget.selectedColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      isSelected = !isSelected;
      isSelected ? _controller.forward() : _controller.reverse();
    });
    widget.onTap(isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            color: _colorAnimation.value,
            child: ListTile(
              leading: Icon(
                widget.icon,
                color: isSelected ? widget.selectedColor : widget.unselectedColor,
              ),
              title: Text(
                widget.title,
                style: TextStyle(
                  color: isSelected ? widget.selectedColor : widget.unselectedColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}