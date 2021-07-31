import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutteradmotors/constant/router.dart' as router;
import 'package:flutteradmotors/viewobject/common/language.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutteradmotors/config/ps_theme_data.dart';
import 'package:flutteradmotors/provider/common/ps_theme_provider.dart';
import 'package:flutteradmotors/provider/ps_provider_dependencies.dart';
import 'package:flutteradmotors/repository/ps_theme_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'config/ps_colors.dart';
import 'config/ps_config.dart';
import 'db/common/ps_shared_preferences.dart';

// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  // print('Handling a background message ${message.messageId}');
  // if
   var message=event.data;
    print('onBackgroundMessage: $message');
    final String notiMessage = _parseNotiMessage(message);

    // Utils.takeDataFromNoti(context, message, loginUserId);

   await PsSharedPreferences.instance.replaceNotiMessage(
      notiMessage,
    );
}
 String _parseNotiMessage(Map<String, dynamic> message) {
    final dynamic data = message['notification'] ?? message;
    String notiMessage = '';
    if (Platform.isAndroid) {
      notiMessage = message['data']['message'];
      notiMessage ??= '';
    } else if (Platform.isIOS) {
      notiMessage = data['body'];
      notiMessage ??= data['message'];
      notiMessage ??= '';
    }
    return notiMessage;
  }

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  MobileAds.instance.initialize();
  
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // if (prefs.getString('codeC') == '' || prefs.getString('codeC').isEmpty) {
  //   prefs.setString('codeC', '');
  //   prefs.setString('codeL', '');
  // }
  // Firebase.initializeApp();
// NativeAdmob(
//                 // Your ad unit id
//                 adUnitID: _adUnitID,
//                 numberAds: 3,
//                 controller: _nativeAdController,
//                 type: NativeAdmobType.full,
//               ),
  // // //check is apple signin is available
  await Utils.checkAppleSignInAvailable();

  // // // Inform the plugin that this app supports pending purchases on Android.
  // // // An error will occur on Android if you access the plugin `instance`
  // // // without this call.
  // // //
  // // // On iOS this is a no-op.
  InAppPurchaseConnection.enablePendingPurchases();

  try {
    // WidgetsFlutterBinding.ensureInitialized();
    Utils.cameras = await availableCameras();
  } on CameraException catch (e) {
    Utils.psPrint(e.toString());
  }

  runApp(EasyLocalization(
      path: 'assets/langs',
      startLocale: PsConfig.defaultLanguage.toLocale(),
      supportedLocales: getSupportedLanguages(),
      child: PSApp()));
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in PsConfig.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp> {
  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;


  @override
  void initState() {
getpermission();
    super.initState();
  }

  Future<ThemeData> getSharePerference(
      EasyLocalization provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');
      psSharedPreferences.futureShared.then((SharedPreferences sh) {
        psSharedPreferences.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();
        themeDataCompleter.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter.future;
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in PsConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

 final themeCollection = ThemeCollection(
    themes: {
      0: themeData(ThemeData.dark()),// ThemeData(primarySwatch: Colors.blue),
      1: themeData(ThemeData.light()),
    }
  );


getpermission() async {
   // Set the background messaging handler early on, as a named top-level function
    /// Create an Android Notification Channel.
  ///
  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  if (Platform.isIOS) {
    // _fcm.requestNotificationPermissions(const IosNotificationSettings());
    _fcm.requestPermission();

  }
}
  @override
  Widget build(BuildContext context) {
    // init Color
    PsColors.loadColor(context);
    print("i love u");
    print('*** ${Utils.convertColorToString(PsColors.mainColor)}');
    return MultiProvider(
        providers: <SingleChildWidget>[
          ...providers,
        ],
        child: DynamicTheme(
          themeCollection: themeCollection,
          defaultThemeId: 1,
            // defaultBrightness: Brightness.light,
            // data: (Brightness brightness) {
            //   if (brightness == Brightness.light) {
            //     return themeData(ThemeData.light());
            //   } else {
            //     return themeData(ThemeData.dark());
            //   }
            // },
            builder: (BuildContext context, ThemeData theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Panacea-Soft',
                theme: theme,
                initialRoute: '/',
                onGenerateRoute: router.generateRoute,
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  EasyLocalization.of(context).delegate,
                  DefaultCupertinoLocalizations.delegate
                ],
                supportedLocales: EasyLocalization.of(context).supportedLocales,
                locale: EasyLocalization.of(context).locale,
              );
            }));
  }
}
