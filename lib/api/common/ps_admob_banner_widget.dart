import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PsAdMobBannerWidget extends StatefulWidget {
  final admobSize;
  const PsAdMobBannerWidget({this.admobSize = AdSize.fullBanner});

  @override
  _PsAdMobBannerWidgetState createState() => _PsAdMobBannerWidgetState();
}

class _PsAdMobBannerWidgetState extends State<PsAdMobBannerWidget> {
  
  bool isShouldLoadAdMobBanner = true;
  bool isConnectedToInternet = false;
  int currentRetry = 0;
  int retryLimit = 1;
  int maxFailedLoadAttempts=4;
  // ignore: always_specify_types
  StreamSubscription _subscription;
  double _height = 0;

  @override
  void initState() {
    myBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
     myBanner?.dispose();
    super.dispose();
  }
  // final AdSize adSize = AdSize(width:200, height:80);


final BannerAd myBanner = BannerAd(
  adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
  size: AdSize.fullBanner,
  request: AdRequest(),
  listener: BannerAdListener(),
);

final BannerAdListener listener = BannerAdListener(
 // Called when an ad is successfully received.
 onAdLoaded: (Ad ad) => print('Ad loaded.'),
 // Called when an ad request failed.
 onAdFailedToLoad: (Ad ad, LoadAdError error) {
   print('Ad failed to load: $error');
 },
 // Called when an ad opens an overlay that covers the screen.
 onAdOpened: (Ad ad) => print('Ad opened.'),
 // Called when an ad removes an overlay that covers the screen.
 onAdClosed: (Ad ad) => print('Ad closed.'),
 // Called when an ad is in the process of leaving the application.
//  onApplicationExit: (Ad ad) => print('Left application.'),
);

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

 

  @override
  Widget build(BuildContext context) {

    return Container(
        // height: _height,
        padding: const EdgeInsets.all(PsDimens.space16),
        child:  AdWidget(ad: myBanner),
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
        
        // NativeAdmob(
        //   adUnitID: Utils.getBannerAdUnitId(),
        //   loading: Container(),
        //   error: Container(child:Text("i love y77676766")),
        //   // numberAds: 3,
        //   controller: _controller,
        //   type:widget.admobSize,
        //   options: const NativeAdmobOptions(
        //   ratingColor: Colors.red,
        //   ),
        // )
        );
  }
}
