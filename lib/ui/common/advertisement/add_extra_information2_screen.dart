import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/textfields/textfield_widget.dart';
import 'package:flutteradmotors/constant/route_paths.dart';

class AddExtraInformationScreen2 extends StatefulWidget {
  @override
  _AddExtraInformationScreen2State createState() =>
      _AddExtraInformationScreen2State();
}

class _AddExtraInformationScreen2State
    extends State<AddExtraInformationScreen2> {
  final TextEditingController userInputDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                        left: PsDimens.space10,
                        right: PsDimens.space10),
                    child: Text(Utils.getString(context, 'Description'),
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  //
                  textField(
                      hint: 'Describe your listing here *',
                      controller: userInputDescription),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                        left: PsDimens.space10,
                        right: PsDimens.space10),
                    child: Text(Utils.getString(context, 'Listing Settings'),
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  //
                  textField(
                      hint: 'Add Additional Number',
                      controller: userInputDescription),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                        left: PsDimens.space10,
                        right: PsDimens.space10),
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade400, width: 0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text(
                            'Hide my Registered Number',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          subtitle: const Text(
                            'This feature enables you to hide your registered number and users can reach you via our messaging system or the additional number(s) above.',
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.grey),
                          ),
                          selected: true,
                          onTap: () {
                            setState(() {});
                          }),
                    ),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.only(
                        top: PsDimens.space16,
                        left: PsDimens.space10,
                        right: PsDimens.space10),
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade400, width: 0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text(
                            'Do Not Distrub Hours',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          subtitle: const Text(
                            'Set Do Not Disturb times when users cannot contact you. For example: 10PM - 8AM.',
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.grey),
                          ),
                          selected: true,
                          onTap: () {
                            setState(() {});
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              // Navigation Caruzen
              await Navigator.pushNamed(context, RoutePaths.add_media);
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
}
