import 'package:covid_19/coloristile.dart';
import 'package:covid_19/widgets/contatori.dart';
import 'package:covid_19/widgets/immagineprincipale.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

var client = http.Client();
String strbandiera = "";
String strcasi = "0";
String strmorti = "0";
String strmortioggi = "0";
String strcasioggi = "0";
String strricoverati = "0";
String statocopia = "Italy";

var recasi = RegExp(r'(?<=cases:)(.*)(?=todayCases)');
var remorti = RegExp(r'(?<=deaths:)(.*)(?=todayDeaths)');
var recasioggi = RegExp(r'(?<=todayCases:)(.*)(?=deaths:)');
var remortioggi = RegExp(r'(?<=todayDeaths:)(.*)(?=recovered:)');
var rericoverati = RegExp(r'(?<=recovered:)(.*)(?=todayRecovered)');
var rebandiera = RegExp(r'(?<=flag:)(.*)(?=cases:)');

String stato = 'ITA';
String sstato = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Principale(),
    );
  }
}

class Principale extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Homescreen();
}

class Homescreen extends State<Principale> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ottienidati() async {
    try {
      var response =
          await client.get('https://corona.lmao.ninja/v2/countries/$stato');
      final parsed = json.decode(response.body);
      print(parsed);
      var casi = recasi.firstMatch(parsed.toString());
      if (casi != null) strcasi = (casi.group(0));
      setState(() {
        strcasi = (strcasi.substring(0, strcasi.length - 2));
      });
      var morti = remorti.firstMatch(parsed.toString());
      if (casi != null) strmorti = (morti.group(0));
      setState(() {
        strmorti = (strmorti.substring(0, strmorti.length - 2));
      });

      var mortioggi = remortioggi.firstMatch(parsed.toString());
      if (casi != null) strmortioggi = (mortioggi.group(0));
      setState(() {
        strmortioggi = (strmortioggi.substring(0, strmortioggi.length - 2));
      });

      var casioggi = recasioggi.firstMatch(parsed.toString());
      if (casi != null) strcasioggi = (casioggi.group(0));
      setState(() {
        strcasioggi = (strcasioggi.substring(0, strcasioggi.length - 2));
      });

      var ricoverati = rericoverati.firstMatch(parsed.toString());
      if (casi != null) strricoverati = (ricoverati.group(0));
      setState(() {
        strricoverati = (strricoverati.substring(0, strricoverati.length - 2));
      });

      var bandieraa = rebandiera.firstMatch(parsed.toString());
      if (casi != null) strbandiera = (bandieraa.group(0));
      setState(() {
        strbandiera = (strbandiera.substring(1, strbandiera.length - 3));
      });
    } finally {}
  }

  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    ottienidati();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Stiamo a casa ",
              textBottom: "Uniti ma distanti.",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: morticolore,
                          number: int.parse(strmorti),
                          title: "Morti",
                        ),
                        Counter(
                          color: ricoveraticolore,
                          number: int.parse(strricoverati),
                          title: "Guariti",
                        ),
                        Counter(
                          color: morticolore,
                          number: int.parse(strmortioggi),
                          title: "Morti Oggi",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 10,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Counter(
                          color: infetticolore,
                          number: int.parse(strcasi),
                          title: "Infettati totali",
                        ),
                        Counter(
                          color: infetticolore,
                          number: int.parse(strcasioggi),
                          title: "Infettati Oggi",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CachedNetworkImage(
                    width: 250,
                    height: 150,
                    imageUrl: strbandiera,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                  Container(
                      child: RaisedButton(
                    child: Text('Seleziona Stato'),
                    onPressed: () {
                      Picker picker = Picker(
                          height: 250,
                          looping: true,
                          adapter: PickerDataAdapter<String>(
                              isArray: true,
                              pickerdata: JsonDecoder().convert(PickerData)),
                          changeToFirst: false,
                          textAlign: TextAlign.left,
                          textStyle: const TextStyle(color: Colors.blue),
                          selectedTextStyle: TextStyle(color: Colors.red),
                          columnPadding: const EdgeInsets.all(5),
                          onConfirm: (Picker picker, List value) {
                            stato = picker.getSelectedValues().toString();
                            statocopia = stato;
                            stato = stato.substring(
                                stato.length - 4, stato.length - 1);
                            statocopia = (statocopia.substring(
                                1, statocopia.length - 5));
                            setState(() {
                              ottienidati();
                            });
                          });
                      picker.show(scaffoldKey.currentState);
                    },
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
