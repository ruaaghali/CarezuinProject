import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';

class AddMediaScreen extends StatefulWidget {
  @override
  _AddMediaScreenState createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  final TextEditingController userInputDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Utils.getBrightnessForAppBar(context),
        backgroundColor:
            Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
        title: Text(
          Utils.getString(context, 'Add Media'),
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
                    child: Text(
                      Utils.getString(context,
                          'Improve the performance of your listing by adding pictures of the item for FREE. The most engaging videos are between 15-20 seconds long.'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(height: 1.3, fontSize: 15.0),
                    ),
                  ),
                  //
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.add_a_photo_rounded,
                              size: 50,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Set Your Primary picture',
                              style: TextStyle(height: 1.5),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'People will see this image when your listing shows up in search results',
                              style: TextStyle(
                                  height: 1.3,
                                  color: Colors.grey.shade500,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              // Navigation Caruzen
              await Navigator.pushNamed(
                  context, RoutePaths.addAdvertisment_Final_Screen);
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
