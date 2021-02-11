
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progettogioco/game.dart';
import 'package:google_fonts/google_fonts.dart';
class Paginainiziale  extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>Homescreen();
}

class Homescreen extends  State<Paginainiziale> {
  @override

   Widget build(BuildContext context){

     return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/robot.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.only(left:110),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
  'ARCADE RETRO BOX',
  style: GoogleFonts.pressStart2P(
    textStyle: TextStyle(color: Colors.deepPurpleAccent, letterSpacing: .5,fontSize: 18),
  ),
),
            Container(
              width: 100,
              height: 100,
          padding: EdgeInsets.all(29),
          
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/snake.png"),     //carico immaggine del campo di gioco
              fit: BoxFit.fill,   
            ),
          ),
          child: GestureDetector(    //quando tocchi starta la partita (gesture )
            behavior: HitTestBehavior.opaque,
            onTapUp: (tapUpDetails) {
              tap1(tapUpDetails);
            },
          ),
        ),
        Container( width: 100,
              height: 100,
          padding: EdgeInsets.all(29),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/space.png"),     //carico immaggine del campo di gioco
              fit: BoxFit.fill,   
            ),
          ),
          child: GestureDetector(    //quando tocchi starta la partita (gesture )
            behavior: HitTestBehavior.opaque,
            onTapUp: (tapUpDetails) {
              //tap2(tapUpDetails);
            },
          ),
        ),
          ],
            

        )
      ),
    );
  }



void tap1(TapUpDetails tapUpDetails){
 Navigator.push(
    context,
    ScaleRotateRoute(page: Game()),
  );
}



        
}





class ScaleRotateRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRotateRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: RotationTransition(
                  turns: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.linear,
                    ),
                  ),
                  child: child,
                ),
              ),
        );
}