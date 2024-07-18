
import 'package:flutter/material.dart';
import 'package:wildfiretracker/utils/theme.dart';

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
                  _createDrawerItem(name:'/about', icon: Icons.info, text: 'About', onTap: () => onMenuSelected('/settings'), isSelected: () => isMenuSelected('/about')),
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