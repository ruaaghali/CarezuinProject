import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/ui/textfields/textfield_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';

class AddAdvertismentFinalScreen extends StatefulWidget {
  @override
  _AddAdvertismentFinalScreenState createState() =>
      _AddAdvertismentFinalScreenState();
}

class _AddAdvertismentFinalScreenState
    extends State<AddAdvertismentFinalScreen> {
  final TextEditingController userInputLocation = TextEditingController();
  List<String> data = ['Ahmed', 'Omar', 'Sayed'];
  String selectedDistrict;
  String selectedArea;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Utils.getBrightnessForAppBar(context),
        backgroundColor:
            Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
        title: Text(
          Utils.getString(context, 'Choose your listing location'),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: PsColors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                        left: PsDimens.space10,
                        right: PsDimens.space10),
                    child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                              hint: Text(Utils.getString(context, 'District'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w600)),
                              value: selectedDistrict,
                              iconSize: 35.0,
                              iconEnabledColor: Colors.grey,
                              iconDisabledColor: Colors.grey,
                              underline: Container(),
                              isExpanded: true,
                              icon: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size: 25,
                                ),
                              ),
                              items: data.map((scan) {
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    scan,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  value: scan,
                                );
                              }).toList(),
                              onChanged: (String selectedValue) {
                                selectedDistrict = selectedValue;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade400, width: 0.9),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ])),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                        left: PsDimens.space10,
                        right: PsDimens.space10),
                    child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                              hint: Text(Utils.getString(context, 'Area'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w600)),
                              value: selectedArea,
                              iconSize: 35.0,
                              iconEnabledColor: Colors.grey,
                              iconDisabledColor: Colors.grey,
                              underline: Container(),
                              isExpanded: true,
                              icon: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size: 25,
                                ),
                              ),
                              items: data.map((scan) {
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    scan,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  value: scan,
                                );
                              }).toList(),
                              onChanged: (String selectedValue) {
                                selectedArea = selectedValue;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade400, width: 0.9),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ])),
                  ),
                  //
                  header('Location'),
                  textField(
                      hint: 'Enter Location', controller: userInputLocation),
                  /*  CurrentLocationWidget(
        androidFusedLocation: true,
        textEditingController: widget.userInputAddress,
        latController: widget.userInputLattitude,
        lngController: widget.userInputLongitude,
        valueHolder: valueHolder,
        updateLatLng: (Position currentPosition) {
          if (currentPosition != null) {
            setState(() {
              _latlng =
                  LatLng(currentPosition.latitude, currentPosition.longitude);
              widget.mapController.move(_latlng, widget.zoom);
            });
          }
        },
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Container(
          height: 250,
          child: FlutterMap(
            mapController: widget.mapController,
            options: MapOptions(
                center:
                    _latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                zoom: widget.zoom, //10.0,
                onTap: (LatLng latLngr) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _handleTap(_latlng, widget.mapController);
                }),
            layers: <LayerOptions>[
              TileLayerOptions(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayerOptions(markers: <Marker>[
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: _latlng,
                  builder: (BuildContext ctx) => Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: PsColors.mainColor,
                      ),
                      iconSize: 45,
                      onPressed: () {},
                    ),
                  ),
                )
              ])
            ],
          ),
        ),
      ),*/
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              // Navigation Caruzen
              /* await Navigator.pushNamed(
                  context, RoutePaths.addAdvertisment_Final_Screen);*/
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: PsColors.mainColor,
                  ),
                  child: Center(
                      child: Text(
                    Utils.getString(context, 'Done'),
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget header(String key) {
    return Padding(
      padding: const EdgeInsets.only(
          top: PsDimens.space16,
          left: PsDimens.space12,
          right: PsDimens.space12),
      child: Text(Utils.getString(context, key),
          style: Theme.of(context).textTheme.bodyText2),
    );
  }
  /* dynamic _handleTap(LatLng latLng, MapController mapController) async {
    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng.latitude.toString(),
            mapLng: _latlng.longitude.toString()));
    if (result != null && result is MapPinCallBackHolder) {
      if (mounted) {
        setState(() {
          _latlng = result.latLng;
          mapController.move(_latlng, widget.zoom);
          widget.userInputAddress.text = result.address;
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        });
      }
      widget.userInputLattitude.text = result.latLng.latitude.toString();
      widget.userInputLongitude.text = result.latLng.longitude.toString();
    }
  }*/
}
