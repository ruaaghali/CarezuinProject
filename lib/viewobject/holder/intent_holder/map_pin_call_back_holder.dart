import 'package:flutter/cupertino.dart';
import 'package:latlng/latlng.dart';
class MapPinCallBackHolder {
  const MapPinCallBackHolder({
    @required this.address,
    @required this.latLng,
  });
  final String address;
  final LatLng latLng;
}
