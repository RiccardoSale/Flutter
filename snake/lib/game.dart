import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'oggettidigioco.dart';

AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
AudioPlayer principale =  AudioPlayer(mode: PlayerMode.LOW_LATENCY);

enum Suono { ATTIVO,DISATTIVO } 
enum Direzione { LEFT, RIGHT, UP, DOWN }     
enum Statogioco{ START, ATTIVO, GAMEOVER }

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game> {
  var posizioneserpente;    //posizione delle parti del serpente ( diventa un array)
  Point posmela;   //posizione mele
  Timer timer;   // timer che indica ogni quanto il serpente si muove
  Direzione direzione = Direzione.UP;
  Suono suono= Suono.ATTIVO;   // direzione iniziale del serpente
  var gameState = Statogioco.START;        // "stato" iniziale del gioc
  int score = 0;    //score del gioco

  String musica="assets/volumeoff.png";
    
    Future caricamusica() async {
    if(suono==Suono.ATTIVO)
      principale  = await AudioCache().loop("basemusic.mp3");
    } 
  Future morso()async{
    if(suono==Suono.ATTIVO)
      audioPlayer =await AudioCache().play("morso.mp3");
  }
  Future suonogameover()async{
    if(suono==Suono.ATTIVO)
      audioPlayer =await AudioCache().play("gameover.mp3");
  }
  musicaoff(){
  if(suono==Suono.ATTIVO){
     principale.pause();
     suono=Suono.DISATTIVO;
     musica="assets/volumeon.png";
     print(suono);
     print("suonodisattivo");
     }
     else{
  if(suono==Suono.DISATTIVO){
     principale.resume();
     musica="assets/volumeoff.png";
     suono=Suono.ATTIVO;
     print(suono);
     print("suonoattivo");
      }
     }
  }
  initState() {
    super.initState();
    caricamusica();
  }


  @override
  Widget build(BuildContext context) {
  
  return Material(
        type: MaterialType.transparency,
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        
        Container(
          width: 400,
          height: 400,
          padding: EdgeInsets.all(29),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/campo.png"),     //carico immaggine del campo di gioco
              fit: BoxFit.fill,   
            ),
          ),
          child: GestureDetector(    //quando tocchi starta la partita (gesture )
            behavior: HitTestBehavior.opaque,
            onTapUp: (tapUpDetails) {
              tap(tapUpDetails);
            },
            child: inizio(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Color.fromRGBO(255, 0, 0, 99)),
                ),
                child: Text(
                  "Punti\n$score",
                  textAlign: TextAlign.center,
                  style:
                  GoogleFonts.pressStart2P(
    textStyle: TextStyle(color: Colors.red, )
                  ),
                ),
              ),
              Container( 
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Color.fromRGBO(255, 0, 0, 99)),
                ),
                child: IconButton(icon:new Image.asset(musica),onPressed: () {
                          setState(() {
                            musicaoff();
                          });
                        },),
                          
              ),
            
              
              Column(
                children: <Widget>[          //imposto le freccie quando premuto cambio il valore della variabile direzione   (freccie create con 4 sprite!!!)
                 Padding(
                        padding: EdgeInsets.only(right: 0),child:
                     IconButton(icon: new Image.asset("assets/su.png"),onPressed: () {
                          setState(() {
                            direzione = Direzione.UP;
                          });
                        },),
                  ) ,
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 0),
                        child:
                      IconButton(icon: new Image.asset("assets/sinistra.png"),onPressed: () {
                          setState(() {
                            direzione = Direzione.LEFT;
                          });
                        },),),
                     Padding(
                    padding: EdgeInsets.only(left:40),child:
                          IconButton(icon: new Image.asset("assets/destra.png"),onPressed: () {
                          setState(() {
                            direzione = Direzione.RIGHT;
                          });
                        },),
                     ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right:0),
                    child: IconButton(icon: new Image.asset("assets/giu.png"),onPressed: () {
                          setState(() {
                            direzione = Direzione.DOWN;
                          });
                        },),
                  ),
                ],
              ),
            ],
          ),
          
        ),
        Container(alignment: Alignment.bottomCenter,
        child: RaisedButton(
        onPressed: () {
          principale.stop();
          audioPlayer.stop();
          Navigator.pop(context);},
        child:           Text(
  'EXIT GAME HERE',
  style: GoogleFonts.pressStart2P(
    textStyle: TextStyle(color: Colors.red, letterSpacing: .5,fontSize: 18),
  ),
),
        color: Colors.black,
        textColor: Colors.white,
        elevation: 5,
      ),),
      ],
      
    ),
    
    );
    
  }

  void tap(TapUpDetails tapUpDetails) {
    switch (gameState) {
      case Statogioco.START:    // fa partire il metodo che fa partire il gioco
        start();
        break;
      case Statogioco.ATTIVO:    //SE gioco attivo non fare nulla
        break;
      case Statogioco.GAMEOVER: 
        suonogameover();   
              // se gioco in game over e schiaccio fallo ripartire 
        settastato(Statogioco.START);
        break;
    }
  }

  void start() {
    creazionesnake();     // crea il serpente formato da inizialmente 3 pezzi 3 cubetti 
    generamela();        //genera in una posizione random la mela
    direzione = Direzione.UP;
    settastato(Statogioco.ATTIVO);
    timer = new Timer.periodic(new Duration(milliseconds: 150), tick);    //ogni 500milissecondi chiama tick
  }
  
  void creazionesnake() { // creazione del punto in cui viene creato il serpente di grandezza 3(3 posizioni)  dispo
    setState(() {
      final midPoint = (400 / 20 /2);
      posizioneserpente = [
        Point(midPoint, midPoint - 1), 
        Point(midPoint, midPoint),
        Point(midPoint, midPoint + 1),
      ];
     print(posizioneserpente[1].x);
    });
  }

  void generamela() {     //generazione della mela random
    setState(() {
      Random rng = Random();
      var min = 0;
      var max = 320 ~/ 20;
      var nextX = min + rng.nextInt(max - min);
      var nextY = min + rng.nextInt(max - min);

      var nuovopunto = Point(nextX.toDouble(), nextY.toDouble());

      if (posizioneserpente.contains(nuovopunto)) { // se il serpente è nella posizione della mela cerca un altro posto per creare la meal
        generamela();
      } else {
        posmela = nuovopunto;
      }
    });
  }

  void settastato(Statogioco _gameState) {
    setState(() {
      gameState = _gameState;
    });
  }

  Widget inizio() {
    var child;
    switch (gameState) {
      case Statogioco.START:    //punteggio a 0
        setState(() {
          score = 0;
        });
        child = messaggiostart;    //messaggio di inizio
        break;

      case Statogioco.ATTIVO:
        List<Positioned> puntioggetti = List();
        posizioneserpente.forEach(
          (i) {
            puntioggetti.add(
              Positioned(        //aggiungo il widget serpente
                child: serpente,
                left: i.x * 15.5,
                top: i.y * 15.5,
              ),
            );
          },
        );
        final puntomela = Positioned(         //aggiungo il widget mela    
          child: mela,
          left: posmela.x * 15.5,
          top: posmela.y * 15.5,
        );
        puntioggetti.add(puntomela);
        child = Stack(children: puntioggetti);
        break;

      case Statogioco.GAMEOVER:
        timer.cancel();    //stoppo il timer
        child = Container(
          width: 320,
          height: 320,
          padding: const EdgeInsets.all(32),
          child: Center(                       //messaggio di fine gioco
            child: Text(
              "Hai fatto : $score\n punti!",
              textAlign: TextAlign.center,
              style: GoogleFonts.pressStart2P(
    textStyle: TextStyle(color: Colors.red, ))
            ),
          ),
        );
        break;
    }
    return child;
  }

  void tick(Timer timer) {      //ogni tick  esegui   ogni 400ms timer
    setState(() {
      posizioneserpente.insert(0, cambiodirezione()); //aggiunge un pezzo di serpente in base alla direzione
      posizioneserpente.removeLast();                 //rimuove la parte finale di serpente   ((((effetto movimento fatto qui ))))
    });

    var posizioneattuale = posizioneserpente.first;   // posizione attuale = alla posizione della testa del serpente
    //print(posizioneattuale.x);
    //print(posizioneattuale.y);
    if (posizioneattuale.x < 0 ||      //controllo se la posizione attuale è in uno dei bordi dei muri se è cosi GAMEOVER
        posizioneattuale.y < 0||
        posizioneattuale.x > 21  ||
        posizioneattuale.y > 21) {
      suonogameover();
      settastato(Statogioco.GAMEOVER);    
      return;
    }

    if (posizioneserpente.first.x == posmela.x &&     //controllo se la poszione del serpente è uguale a quella della mela se è così allora genera una nuova 
        posizioneserpente.first.y == posmela.y) {     //mela e aggiungi punteggio
      generamela();
      setState(() {
        morso();
        score=score+1;     //aumento score di 1 
        posizioneserpente.insert(0, cambiodirezione());  //aggiungo un pezzo di serpente
      });
    }

    for(int i=1;i<posizioneserpente.length;i++){
            if(posizioneserpente.first.x==posizioneserpente[i].x && posizioneserpente.first.y==posizioneserpente[i].y)
               settastato(Statogioco.GAMEOVER) ;
          }
  }

  Point cambiodirezione() {
    var testa;      //nuova posizione testa
    switch (direzione) {         //direzione in base all'ultima freccia che è stata premuta    

      case Direzione.LEFT:
        var posizioneattuale = posizioneserpente.first;
        testa = Point(posizioneattuale.x - 1, posizioneattuale.y);  // coordinata x -1
        break;

      case Direzione.RIGHT:
        var posizioneattuale = posizioneserpente.first;
        testa = Point(posizioneattuale.x + 1, posizioneattuale.y); // coordinate y+1
        break;

      case Direzione.UP:
        var posizioneattuale = posizioneserpente.first;
        testa = Point(posizioneattuale.x, posizioneattuale.y - 1); // cordinate y -1
        break;

      case Direzione.DOWN:
        var posizioneattuale = posizioneserpente.first;
        testa = Point(posizioneattuale.x, posizioneattuale.y + 1);  //coordinate y +1  
        break;
    }

    return testa;
  }
}