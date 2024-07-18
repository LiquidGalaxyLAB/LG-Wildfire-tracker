import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wildfiretracker/utils/theme.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar() : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isOnline = false;


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.paltetteColor1,
      title: Row(
        children: [
          const Expanded(
            child: Text('Wildfire Tracker for LG',
                style: TextStyle(
                  fontSize: 24)
          ),
          ),
          _buildStatusIndicator(),
        ],
      ),
    );
  }


  Widget _buildStatusIndicator() {
    return Row(
      children: [
        Icon(
          _isOnline ? Icons.connected_tv_rounded : Icons.circle_outlined,
          color: _isOnline ? Colors.green : Colors.red,
          size: 24,
        ),
        SizedBox(width: 8),
        Text(
          _isOnline ? 'Connected' : 'Disconnected',
          style: TextStyle(fontSize: 14),
        ),
        Switch(
          value: _isOnline,
          onChanged: (value) {
            setState(() {
              _isOnline = value;
            });
          },
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
        ),
      ],
    );
  }
}