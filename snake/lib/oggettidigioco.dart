import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Widget messaggiostart = Container(
  width: 320,
  height: 320,
  child: Center(
    child: Text(
      "Schiaccia per cominciare a giocare.Attento ai muri!!!!!!!",
      textAlign: TextAlign.center,
      style:GoogleFonts.pressStart2P(
    textStyle: TextStyle(color: Colors.red, ),
    )),
  ),
);

final Widget serpente = Container(    //oggetto serpente
  width: 15.5,
  height: 15.5,
  decoration: new BoxDecoration(
    color: const Color(0xFFFF0000),
    shape: BoxShape.rectangle ,gradient:LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.red, Colors.greenAccent]))
  );

final Widget mela = Container(     // ogetto mela 
  width: 20,
  height: 20,
  child:  Image.asset("assets/mela.png")
);

//parti del serpente che vengono salvate tramite la x e la y
class Point { 
  double x;
  double y;

  Point(double x, double y) {
    this.x = x;
    this.y = y;
  }

  getx(){
    return x;
  }

  gety(){
    return y;
  }
}
