import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';

import 'package:flutteradmotors/provider/model/model_provider.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/textfields/textfield_widget.dart';
import 'package:flutteradmotors/ui/model/item/item.dart';
import 'package:flutteradmotors/constant/route_paths.dart';

class AddExtraInformationScreen extends StatefulWidget {
  @override
  _AddExtraInformationScreenState createState() =>
      _AddExtraInformationScreenState();
}

class _AddExtraInformationScreenState extends State<AddExtraInformationScreen> {
  List<String> data = ['Ahmed', 'Omar', 'Sayed'];
  List<Item> condition = [
    Item(name: 'None', selected: false),
    Item(name: 'Excellent', selected: false),
    Item(name: 'Very good', selected: false),
    Item(name: 'Good', selected: false),
  ];
  List<Item> transmission = [
    Item(name: 'Automatic', selected: false),
    Item(name: 'Manual', selected: false),
    Item(name: 'Tiptronic', selected: false),
  ];
  List<Item> sunroof = [
    Item(name: 'None', selected: false),
    Item(name: 'Normal', selected: false),
    Item(name: 'Panoramic', selected: false),
  ];
  List<Item> cylinders = [
    Item(name: 'None', selected: false),
    Item(name: '3', selected: false),
    Item(name: '4', selected: false),
    Item(name: '5', selected: false),
    Item(name: '6', selected: false),
    Item(name: '8', selected: false),
    Item(name: '6', selected: false),
    Item(name: '10', selected: false),
    Item(name: '12', selected: false),
  ];

  List<Item> imports = [
    Item(name: 'None', selected: false),
    Item(name: 'Gulf', selected: false),
    Item(name: 'Kuwait', selected: false),
    Item(name: 'Germany', selected: false),
    Item(name: 'USA', selected: false),
  ];
  String _selectedModel;
  String _selectedmanufacture;
  String _selectedYear;
  String _selectedColorInterior;
  String _selectedFuel;
  String _selectedMaterial;
  String _selectedColorExterior;
  final TextEditingController userInputMileage = TextEditingController();
  final TextEditingController userInputPlateNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        brightness: Utils.getBrightnessForAppBar(context),
        backgroundColor:
            Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
        title: Text(
          Utils.getString(context, 'Add Extra Information'),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: PsColors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('much information as possible'),
                  ),
                  //
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: PsColors.mainColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      child: Text(
                        'Optional Information',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: PsColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  //

                  /* Padding(
                    padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                        left: PsDimens.space10,
                        right: PsDimens.space10),
                    child: Container(
                        height: 50.0,
                        width: width * 0.95,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                              hint: Text(
                                  Utils.getString(
                                      context, 'item_entry__manufacture'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w600)),
                              value: _selectedmanufacture,
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
                                _selectedmanufacture = selectedValue;
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
                  ),*/

                  //
                  Padding(
                    padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                        left: PsDimens.space10,
                        right: PsDimens.space10),
                    child: Container(
                        height: 50.0,
                        width: width * 0.95,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                              hint: Text(Utils.getString(context, 'Model'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w600)),
                              value: _selectedModel,
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
                                _selectedModel = selectedValue;
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
                        width: width * 0.95,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                              hint: Text(Utils.getString(context, 'Year'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w600)),
                              value: _selectedYear,
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
                                _selectedYear = selectedValue;
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
                        width: width * 0.95,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                              hint: Text(
                                  Utils.getString(context, 'Color Exterior'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w600)),
                              value: _selectedColorExterior,
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
                                _selectedColorExterior = selectedValue;
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
                        width: width * 0.95,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                              hint: Text(Utils.getString(context, 'Fuel Type'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w600)),
                              value: _selectedFuel,
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
                                _selectedFuel = selectedValue;
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
                        width: width * 0.95,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                              hint: Text(
                                  Utils.getString(context, 'Color Interior'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w600)),
                              value: _selectedColorInterior,
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
                                _selectedColorInterior = selectedValue;
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
                        width: width * 0.95,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                              hint: Text(
                                  Utils.getString(context, 'Seats Material'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontWeight: FontWeight.w600)),
                              value: _selectedMaterial,
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
                                _selectedMaterial = selectedValue;
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
                  header('Transmission'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: transmission.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                            onTap: () {
                              for (int r = 0; r < transmission.length; r++) {
                                transmission[r].selected = false;
                              }
                              transmission[i].selected = true;
                              setState(() {});
                            },
                            child: shape(transmission[i].name,
                                transmission[i].selected));
                      },
                    ),
                  ),

                  //
                  header('Sunroof'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sunroof.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                            onTap: () {
                              for (int r = 0; r < sunroof.length; r++) {
                                sunroof[r].selected = false;
                              }
                              sunroof[i].selected = true;
                              setState(() {});
                            },
                            child: shape(sunroof[i].name, sunroof[i].selected));
                      },
                    ),
                  ),
                  //
                  header('Import'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imports.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                            onTap: () {
                              for (int r = 0; r < imports.length; r++) {
                                imports[r].selected = false;
                              }
                              imports[i].selected = true;
                              setState(() {});
                            },
                            child: shape(imports[i].name, imports[i].selected));
                      },
                    ),
                  ),
                  //
                  header('Cylinders'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cylinders.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                            onTap: () {
                              for (int r = 0; r < cylinders.length; r++) {
                                cylinders[r].selected = false;
                              }
                              cylinders[i].selected = true;
                              setState(() {});
                            },
                            child: shape(
                                cylinders[i].name, cylinders[i].selected));
                      },
                    ),
                  ),
                  //
                  header("Condition"),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: condition.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                            onTap: () {
                              for (int r = 0; r < condition.length; r++) {
                                condition[r].selected = false;
                              }
                              condition[i].selected = true;
                              setState(() {});
                            },
                            child: shape(
                                condition[i].name, condition[i].selected));
                      },
                    ),
                  ),
                  //
                  textField(
                      hint: 'Mileage ( 0-1000000 )',
                      controller: userInputMileage),
                  textField(
                      hint: 'Plate number', controller: userInputPlateNumber),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ), //
          InkWell(
            onTap: () async {
              // Navigation Caruzen
              await Navigator.pushNamed(context, RoutePaths.extra_info2);
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
                    Utils.getString(context, 'Next Step'),
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

  Widget shape(String key, bool selected) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40.0,
        decoration: BoxDecoration(
            color: selected ? PsColors.mainColor : Colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            key,
            style: TextStyle(
                fontSize: 14,
                color: selected ? Colors.white : PsColors.mainColor),
          ),
        ),
      ),
    );
  }
}
