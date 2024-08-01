import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../services/nasa/satellite_data.dart';
import '../utils/theme.dart';

class NasaLiveFireCard extends StatefulWidget {
  const NasaLiveFireCard({
    Key? key,
    required this.satelliteData,
    required this.selected,
    required this.onOrbit,
    required this.onBalloonToggle,
    required this.onView,
    required this.onMaps,
    required this.disabled,
  }) : super(key: key);

  final bool selected;
  final bool disabled;
  final SatelliteData satelliteData;

  final Function(bool) onOrbit;
  final Function(SatelliteData, bool) onBalloonToggle;
  final Function(SatelliteData) onView;
  final Function(SatelliteData) onMaps;

  @override
  State<NasaLiveFireCard> createState() => _NasaLiveFireCardState();
}

class _NasaLiveFireCardState extends State<NasaLiveFireCard> {
  bool _orbiting = false;
  bool _balloonVisible = true;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    //final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      //width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
      //width: 100,
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
                      Icons.local_fire_department,
                      color: ThemeColors.primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '[${widget.satelliteData.countryId}] ${widget.satelliteData.geocodeAddress.countryName != null ? '${widget.satelliteData.geocodeAddress.countryName} - ' : ''}${widget.satelliteData.geocodeAddress.city ?? ''}',
                      style: TextStyle(
                        color: ThemeColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ]),
                  Text(
                      '${widget.satelliteData.version} - ${widget.satelliteData.satellite} - ${widget.satelliteData.instrument}',
                      style: TextStyle(
                        color: ThemeColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      )),
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
                          Text('Latitude: ${widget.satelliteData.latitude}',
                              style:
                                  TextStyle(color: ThemeColors.primaryColor)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Longitude: ${widget.satelliteData.longitude}',
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
                      widget.onMaps(widget.satelliteData);
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.satelliteData.getDateTime()}',
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
                        : 'VIEW IN GALAXY',
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

                    widget.onView(widget.satelliteData);

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

                                widget.onBalloonToggle(
                                    widget.satelliteData, _balloonVisible);
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
