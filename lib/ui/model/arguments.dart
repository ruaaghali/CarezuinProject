import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutteradmotors/viewobject/product.dart';

class Arguments {
  final AnimationController animationController;
  final String flag;
  final Product item;
  Arguments(this.animationController, this.flag, this.item);
}
