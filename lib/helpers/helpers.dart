
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

AppBar appbar(String title){
  return AppBar(backgroundColor: blackColor,
      centerTitle: true,
        title:  Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.bold), ),
      );
}