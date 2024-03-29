import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    return AnimatedBuilder(
      animation: widget.animationController,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _SettingPrivacyWidget(),
            const SizedBox(height: PsDimens.space8),
            _SettingNotificationWidget(),
            const SizedBox(height: PsDimens.space8),
            _CameraSettingWidget(),
            const SizedBox(height: PsDimens.space8),
            _SettingDarkAndWhiteModeWidget(
                animationController: widget.animationController),
            const SizedBox(height: PsDimens.space8),
            _SettingAppInfoWidget(),
            const SizedBox(height: PsDimens.space8),
            _SettingAppVersionWidget(),
            const PsAdMobBannerWidget(admobSize: AdSize.mediumRectangle
            ),
          ],
        ),
      ),
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: child),
        );
      },
    );
  }
}

class _SettingAppInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('App Info');
        Navigator.pushNamed(context, RoutePaths.appinfo, arguments: 1);
      },
      child: Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__app_info'),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__app_info'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.mainColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingPrivacyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('App Info');
        Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 1);
      },
      child: Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__privacy_policy'),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__policy_statement'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.mainColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingNotificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Notification Setting');
        Navigator.pushNamed(context, RoutePaths.notiSetting);
      },
      child: Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__notification_setting'),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__control_setting'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.mainColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Camera Setting');
        Navigator.pushNamed(context, RoutePaths.cameraSetting);
      },
      child: Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__camera_setting'),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__camera_control_setting'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.mainColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingDarkAndWhiteModeWidget extends StatefulWidget {
  const _SettingDarkAndWhiteModeWidget({Key key, this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  __SettingDarkAndWhiteModeWidgetState createState() =>
      __SettingDarkAndWhiteModeWidgetState();
}

class __SettingDarkAndWhiteModeWidgetState
    extends State<_SettingDarkAndWhiteModeWidget> {
  bool checkClick = false;
  bool isDarkOrWhite = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.only(
            left: PsDimens.space16,
            bottom: PsDimens.space12,
            right: PsDimens.space12,
            top: PsDimens.space12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                Utils.getString(context, 'setting__change_mode'),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            if (checkClick)
              Switch(
                value: isDarkOrWhite,
                onChanged: (bool value) {
                  if (mounted) {
                    setState(() {
                      PsColors.loadColor2(value);
                      isDarkOrWhite = value;
                      changeBrightness(context);
                    });
                  }
                },
                activeTrackColor: PsColors.mainColor,
                activeColor: PsColors.mainColor,
              )
            else
              Switch(
                value: isDarkOrWhite,
                onChanged: (bool value) {
                  if (mounted) {
                    setState(() {
                      PsColors.loadColor2(value);
                      isDarkOrWhite = value;
                      changeBrightness(context);
                    });
                  }
                },
                activeTrackColor: PsColors.mainColor,
                activeColor: PsColors.mainColor,
              ),
          ],
        ));
  }
}

void changeBrightness(BuildContext context) {
  DynamicTheme.of(context).setTheme(Utils.isLightMode(context) ? 1 : 0);
  // .setBrightness(
  //     Utils.isLightMode(context) ? Brightness.dark : Brightness.light);
}

class _SettingAppVersionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('App Info');
      },
      child: Container(
        width: double.infinity,
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Utils.getString(context, 'setting__app_version'),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(
                height: PsDimens.space10,
              ),
              Text(
                PsConfig.app_version,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
