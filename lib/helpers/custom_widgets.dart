
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

Text customText(String string, {Color? color, double? fontsize,FontWeight? fontWeight}) {
  return Text(
    string,
    style: TextStyle(
        color: color ?? whiteColor.withOpacity(.5), fontSize: fontsize ?? 14,fontWeight:fontWeight?? FontWeight.normal),
  );
}

Container button(String name, {double? width, double? fontsize}) {
  return Container(
    height: 60,
    width: width ?? 100,
    decoration: BoxDecoration(
      border: Border.all(color: whiteColor),
      color: whiteColor.withOpacity(.2),
    ),
    child: Center(
        child: Text(
      name,
      style: GoogleFonts.poppins(
          color: whiteColor,
          fontSize: fontsize ?? 20,
          fontWeight: FontWeight.w500),
    )),
  );
}
