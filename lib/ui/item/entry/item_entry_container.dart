import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/ui/item/entry/item_entry_view.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/viewobject/product.dart';

class ItemEntryContainerView extends StatefulWidget {
  const ItemEntryContainerView({
    @required this.flag,
    @required this.item,
  });
  final String flag;
  final Product item;
  @override
  ItemEntryContainerViewState createState() => ItemEntryContainerViewState();
}

class ItemEntryContainerViewState extends State<ItemEntryContainerView>
    with SingleTickerProviderStateMixin { 
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      //here salama
      onWillPop: _requestPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: true,
        /*   bottomNavigationBar: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: PsColors.mainColor,
            ),
            child: Center(
                child: Text(
              'Next Step',
              style: TextStyle(color: Colors.white),
            )),
          ),*/
        /*  appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
          title: Text(
            Utils.getString(context, 'Post Your Listing'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: PsColors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),*/
        body:
            /* AdvertisementScreen(
            animationController: animationController,
            flag: widget.flag,
            item: widget.item,
          ) */
            ItemEntryView(
          animationController: animationController,
          flag: widget.flag,
          item: widget.item,
        ),
      ),
    );
  }
}
