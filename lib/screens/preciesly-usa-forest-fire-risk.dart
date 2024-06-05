import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreciselyUsaForestFireRisk extends StatefulWidget {
  const PreciselyUsaForestFireRisk({super.key});

  @override
  State<PreciselyUsaForestFireRisk> createState() => _PreciselyUsaForestFireRisk();
}

class _PreciselyUsaForestFireRisk extends State<PreciselyUsaForestFireRisk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Precisely - USA Forest Fire Risk',
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
              child: Icon(Icons.forest_outlined),
            )
          ],
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Write USA location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          /*Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownSearch<HistoricYear>(
                      /*clearButtonProps: ClearButtonProps(
                              isVisible: true,
                            ),*/
                      onChanged: (HistoricYear? hy) {
                        _selectedHisotricYear = hy!;
                      },
                      enabled: true,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          label: Text('Select historic year'),
                          prefixIcon: Icon(Icons.flag),
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          hintText: 'Select year',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      dropdownButtonProps: const DropdownButtonProps(
                        icon: Icon(Icons.arrow_drop_down),
                        selectedIcon: Icon(Icons.arrow_drop_up),
                      ),
                      /*dropdownBuilder: (context, selectedItem) =>
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Row(children: [
                                Icon(Icons.flag),
                                SizedBox(width: 8),
                                Text(
                                  selectedItem?.name ?? 'Select country',
                                )
                              ]),
                            ),*/
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search year',
                          ),
                        ),
                      ),
                      filterFn: (item, filter) =>
                          item.year.toString().contains(filter.toLowerCase()),
                      itemAsString: (item) => item.year.toString(),
                      items: HistoricYear.getLocalHistoricYears(),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: ThemeColors.primaryColor,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () {
                        getHistoricFirePerimeter();
                      },
                    ),
                  )
                ],
              )),
          _loadingFirePerimeterData
              ? _buildSpinner()
              : Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 10.0, right: 10.0),
                  child: SizedBox(
                    //width: screenWidth >= 768 ? screenWidth / 2 - 24 : 360,
                    width: screenWidth,
                    child: _firePerimeterData.isEmpty
                        ? _buildEmptyMessage('There are no wildfire.')
                        : ResponsiveGridView.builder(
                      addAutomaticKeepAlives: true,
                      gridDelegate: ResponsiveGridDelegate(
                        //maxCrossAxisExtent: 180,
                        //crossAxisExtent: screenWidth >= 768? screenWidth / 2 - 224 : 360,
                        // Maximum item size.
                        childAspectRatio: 2.5,
                        // Aspect ratio for items.
                        crossAxisSpacing: 16,
                        // Horizontal spacing between items.
                        mainAxisSpacing: 16,
                        // Vertical spacing between items.
                        minCrossAxisExtent: screenWidth > 820? screenWidth / 2 - 224 : screenWidth-100,
                        // Minimum item size.
                      ),
                      alignment: Alignment.topCenter,
                      //maxRowCount: ,
                      shrinkWrap: false,
                      padding: const EdgeInsets.all(16),
                      itemCount: _firePerimeterData.length,
                      // Total number of items.
                      itemBuilder: (context, index) {
                        return FadeIn(
                            duration: Duration(milliseconds: 600),
                            delay: Duration(
                                milliseconds: (250 * 1).round()),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: GencatFirePerimeterCard(
                                firePerimeter: _firePerimeterData[index],
                                selected: _selectedFirePerimeterData
                                is FirePerimeter &&
                                    _firePerimeterData[index]
                                        .properties
                                        .codiFinal ==
                                        _selectedFirePerimeterData
                                            .properties.codiFinal,
                                disabled: false,
                                onBalloonToggle: (firePerimeter, showBallon) {
                                  viewFirePerimeter(
                                      firePerimeter: firePerimeter,
                                      showBallon: showBallon);
                                },
                                onOrbit: (value) async {
                                  if (value) {
                                    await _lgService.startTour('Orbit');
                                  } else {
                                    await _lgService.stopTour();
                                  }
                                },
                                onView: (firePerimeter) {
                                  setState(() {
                                    _selectedFirePerimeterData =
                                        firePerimeter;
                                  });
                                  viewFirePerimeter(
                                      firePerimeter: firePerimeter,
                                      showBallon: true);
                                },
                                onMaps: (firePerimeter) async {
                                  String googleMapsUrl =
                                      "https://www.google.com/maps/search/?api=1&query=${firePerimeter.geometry.centeredLatitude},${firePerimeter.geometry.centeredLongitude}";
                                  if (!await launchUrlString(
                                      googleMapsUrl)) {
                                    showSnackbar(
                                        context, "Could not open the map.");
                                  }
                                },
                              ),
                            ));
                      },
                    ),
                  )
              )),*/
        ]));
  }

}