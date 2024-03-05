import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wildfiretracker/services/gencat/fire_perimeter.dart';

import '../utils/theme.dart';

class GencatFirePerimeterCard extends StatefulWidget {
  const GencatFirePerimeterCard({
    Key? key,
    required this.firePerimeter,
    required this.selected,
    required this.onOrbit,
    required this.onBalloonToggle,
    required this.onView,
    required this.onMaps,
    required this.disabled,
  }) : super(key: key);

  final bool selected;
  final bool disabled;
  final FirePerimeter firePerimeter;

  final Function(bool) onOrbit;
  final Function(FirePerimeter, bool) onBalloonToggle;
  final Function(FirePerimeter) onView;
  final Function(FirePerimeter) onMaps;

  @override
  State<GencatFirePerimeterCard> createState() =>
      _GencatFirePerimeterCardState();
}

class _GencatFirePerimeterCardState extends State<GencatFirePerimeterCard> {
  bool _orbiting = false;
  bool _balloonVisible = true;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    final screenWidth = MediaQuery.of(context).size.width;

    return  Container(
      //width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
      decoration: BoxDecoration(
          color: ThemeColors.card.withOpacity(0.7),
          border: Border.all(color: ThemeColors.cardBorder),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(
                      Icons.forest_outlined,
                      color: ThemeColors.primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.firePerimeter.properties.municipi != "" ? widget.firePerimeter.properties.municipi : widget.firePerimeter.properties.codiFinal,
                      style: TextStyle(
                        color: ThemeColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ]),
                  /*Text('${widget.satelliteData.version} - ${widget.satelliteData.satellite} - ${widget.satelliteData.instrument}',
                        style: TextStyle(
                          color: ThemeColors.textPrimary,
                          fontWeight: FontWeight.w600,

                        )),*/
                ]),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              'Latitude: ${widget.firePerimeter.geometry.centeredLatitude.toString().substring(0, 10)}',
                              style:
                              TextStyle(color: ThemeColors.primaryColor)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              'Longitude: ${widget.firePerimeter.geometry.centeredLongitude.toString().substring(0, 10)}',
                              style:
                              TextStyle(color: ThemeColors.primaryColor)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              'Area: ${widget.firePerimeter.geometry.area.toStringAsFixed(4)} ha',
                              style:
                              TextStyle(color: ThemeColors.primaryColor)),
                        ],
                      )
                    ],
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      tapTargetSize: MaterialTapTargetSize.padded,
                      alignment: Alignment.centerRight,
                      minimumSize: const Size(120, 24),
                    ),
                    icon: Icon(
                      widget.selected ? Icons.map_sharp : Icons.map,
                      color: widget.disabled
                          ? Colors.grey
                          : ThemeColors.primaryColor,
                    ),
                    label: Text(
                      'VIEW IN MAPS',
                      style: TextStyle(
                        color: widget.disabled
                            ? Colors.grey
                            : ThemeColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () {
                      if (widget.disabled) {
                        return;
                      }
                      widget.onMaps(widget.firePerimeter);
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.firePerimeter.properties.dataIncen,
                  style: TextStyle(
                    color: ThemeColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    tapTargetSize: MaterialTapTargetSize.padded,
                    alignment: Alignment.centerRight,
                    minimumSize: const Size(120, 24),
                  ),
                  icon: Icon(
                    widget.selected
                        ? (!_orbiting
                        ? Icons.flip_camera_android_rounded
                        : Icons.stop_rounded)
                        : Icons.travel_explore_rounded,
                    color: widget.disabled
                        ? Colors.grey
                        : ThemeColors.primaryColor,
                  ),
                  label: Text(
                    widget.selected
                        ? (_orbiting ? 'STOP ORBIT' : 'ORBIT')
                        : 'VIEW IN LG',
                    style: TextStyle(
                      color: widget.disabled
                          ? Colors.grey
                          : ThemeColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {
                    if (widget.disabled) {
                      return;
                    }

                    if (widget.selected) {
                      widget.onOrbit(!_orbiting);

                      setState(() {
                        _orbiting = !_orbiting;
                      });

                      return;
                    }

                    widget.onView(widget.firePerimeter);

                    setState(() {
                      _orbiting = false;
                      _balloonVisible = true;
                    });
                  },
                )
              ],
            ),
            widget.selected
                ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Switch(
                  value: _balloonVisible,
                  activeColor: ThemeColors.primaryColor,
                  activeTrackColor:
                  ThemeColors.primaryColor.withOpacity(0.6),
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.withOpacity(0.6),
                  onChanged: widget.disabled
                      ? null
                      : (value) {
                    setState(() {
                      _balloonVisible = !_balloonVisible;
                      _orbiting = false;
                    });

                    widget.onBalloonToggle(widget.firePerimeter, _balloonVisible);
                  },
                ),
                Text(
                  'BALLON',
                  style: TextStyle(
                    color: widget.disabled
                        ? Colors.grey
                        : ThemeColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  selectionColor: ThemeColors.backgroundCardColor,
                ),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
