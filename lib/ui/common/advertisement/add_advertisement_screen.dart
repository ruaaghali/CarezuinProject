import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/ui/model/arguments.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/ui/textfields/textfield_widget.dart';
import 'package:flutteradmotors/viewobject/product.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen(
      {this.flag, this.item, @required this.animationController});

  final AnimationController animationController;
  final String flag;
  final Product item;
  @override
  _AdvertisementScreenState createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController userInputListingTitle = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();
  List<String> data = ['Ahmed', 'Omar', 'Sayed'];
  String _selectedCategory;
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Padding(
                padding: const EdgeInsets.only(
                    top: PsDimens.space16,
                    left: PsDimens.space10,
                    right: PsDimens.space10),
                child: Text(Utils.getString(context, 'What are you selling?'),
                    style: Theme.of(context).textTheme.bodyText2),
              ),
              //
              Padding(
                padding: const EdgeInsets.only(
                    top: PsDimens.space16,
                    left: PsDimens.space10,
                    right: PsDimens.space10),
                child: Container(
                    height: 50.0,
                    width: width * 0.9,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton(
                          hint: Text(
                              Utils.getString(context, 'Choose Category'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontWeight: FontWeight.w600)),
                          value: _selectedCategory,
                          iconSize: 35.0,
                          iconEnabledColor: Colors.grey,
                          iconDisabledColor: Colors.grey,
                          underline: Container(),
                          isExpanded: true,
                          icon: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
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
                            _selectedCategory = selectedValue;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade400, width: 0.9),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ])),
              ),
              _selectedCategory != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: PsDimens.space16,
                              left: PsDimens.space10,
                              right: PsDimens.space10),
                          child: Text(
                              Utils.getString(
                                  context, 'Where is your listing?'),
                              style: Theme.of(context).textTheme.bodyText2),
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.only(
                              top: PsDimens.space16,
                              left: PsDimens.space10,
                              right: PsDimens.space10),
                          child: Container(
                              height: 50.0,
                              width: width * 0.9,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: DropdownButton(
                                    hint: Text(
                                        Utils.getString(
                                            context, 'Choose Category'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                fontWeight: FontWeight.w600)),
                                    value: _selectedCategory,
                                    iconSize: 35.0,
                                    iconEnabledColor: Colors.grey,
                                    iconDisabledColor: Colors.grey,
                                    underline: Container(),
                                    isExpanded: true,
                                    icon: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 25,
                                      ),
                                    ),
                                    items: data.map((scan) {
                                      return DropdownMenuItem<String>(
                                        child: Text(
                                          scan,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(.7),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        value: scan,
                                      );
                                    }).toList(),
                                    onChanged: (String selectedValue) {
                                      _selectedCategory = selectedValue;
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
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ])),
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.only(
                              top: PsDimens.space16,
                              left: PsDimens.space10,
                              right: PsDimens.space10),
                          child: Text(Utils.getString(context, 'Information'),
                              style: Theme.of(context).textTheme.bodyText2),
                        ),
                        //
                        textField(
                            hint: 'Title *', controller: userInputListingTitle),
                        //
                        const SizedBox(
                          height: 3,
                        ),
                        textField(hint: 'Price *', controller: userInputPrice),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
        //
        InkWell(
          onTap: () async {
            // Navigation Caruzen

            await Navigator.pushNamed(context, RoutePaths.itemEntryView,
                arguments: Arguments(
                  animationController,
                  widget.flag,
                  widget.item,
                ));
            /*ItemEntryView(
              animationController: animationController,
              flag: widget.flag,
              item: widget.item,
            );*/
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
    );
  }
}
