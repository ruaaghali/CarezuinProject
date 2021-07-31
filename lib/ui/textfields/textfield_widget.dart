import 'package:flutter/material.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';

Widget textField({String hint, TextEditingController controller}) {
  return Padding(
    padding: const EdgeInsets.only(
        top: PsDimens.space16, left: PsDimens.space10, right: PsDimens.space10),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
          ),
        ),
      ),
    ),
  );
}
