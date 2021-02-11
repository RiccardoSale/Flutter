import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:convert' show utf8;
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String defaultUserName = "";
String defaultip="Non connesso";

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  defaultUserName = currentUser.displayName.toString();
  assert(user.uid == currentUser.uid);
  return ('signInWithGoogle succeeded: $user');
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}

final CupertinoThemeData iOSTheme = CupertinoThemeData(
  primaryContrastingColor: CupertinoColors.black,
  primaryColor: CupertinoColors.black,
  scaffoldBackgroundColor: CupertinoColors.extraLightBackgroundGray,
);
Color utente = CupertinoColors.black;
Color serverr = CupertinoColors.destructiveRed;
Color altroutente = CupertinoColors.activeOrange;
Color change;
List<String> username = [];
bool servernonragg=false;
bool messaggerr=true;
//List<String> username = jsonDecode(_read().then((s){return s;}));
//List _messaggi=jsonDecode(_read2().then((s){return s;}));
void main() {
  runApp(PaginaLogin());
}

class Chat extends StatefulWidget {
  State createState() => FinestraChat();
}

class FinestraChat extends State<Chat> with TickerProviderStateMixin {
  int utentionline = 0;
  final List _messaggi = [];
  final TextEditingController _textController = TextEditingController();
  bool _stascrivendo = false;
  final List _gif = [
    "sad!",
    "happy!",
    "goodday!",
    "dude!",
    "minion!",
    "hi!",
    "happy!",
    "thankyou!"
  ];
  IconData disconnetti= IconData( 0xf2a9,fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);
  Widget build(BuildContext ctx) {
    return CupertinoPageScaffold(
        child: CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text("ChatRoom"),
          leading: Text("utenti on:$utentionline"),
          middle: (Text(defaultip)),
          trailing: CupertinoButton(child: Icon(disconnetti),onPressed: ()=>{ Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return PaginaLogin();
              },
            ),
          ),s.close()},),
          //middle: RaisedButton(child: Text("lista utenti"),onPressed: _utenticonnessi(),)
        ),
        SliverFillRemaining(
          child: Column(children: <Widget>[
            Flexible(
                child: ListView.builder(
              itemCount: username.length,
              itemBuilder: (_, indice) {
                if (indice < _messaggi.length) {
                  return _messaggi[indice];
                }
              },
              reverse: true,
              padding: EdgeInsets.all(6.0),
            )),
            Divider(height: 1.0),
            Container(
              child: _finestraPrincipale(),
              decoration: BoxDecoration(color: Theme.of(ctx).cardColor),
            ),
          ]),
        )
      ],
    ));
  }

  IconData arrow = const IconData(0xf366,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);
  IconData book= IconData( 0xf3e8,fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);
  IconData ip= IconData( 0xf2ac,fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);
  Widget _finestraPrincipale() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: CupertinoTextField(
                  controller: _textController,
                  onChanged: (String txt) {
                    setState(() {
                      _stascrivendo = txt.length > 0;
                    });
                  },
                  onSubmitted: _inviamessaggio,
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  child: CupertinoButton(
                      child: Icon(arrow),
                      onPressed: _stascrivendo
                          ? () => _inviamessaggio(_textController.text)
                          : null)),
                          Container(child: CupertinoButton(child: Icon(book),
                          onPressed: ()=>_utenticonnessi()),),
                          Container(child:CupertinoButton(child: Icon(ip),
                          onPressed: (){defaultip=_textController.text;_textController.text="";},)),
            ],
          ),
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: CupertinoColors.activeBlue)))),
    );
  }

  Future<Socket> wsFuture;
  Socket s;
  String data;
  String all;
  List<String> ricevuti = [];
  bool server = false;
  int contatore = 0;
  bool firstime = false;
  starts() async {
    //print("ascolto");
    data = null;
    s = null;
    wsFuture = await Socket.connect(defaultip, 3000)
        .timeout(Duration(seconds: 15))
        .then((istanza) {
      s = istanza;
      s.listen(
        (List<int> dati) {
          data = utf8.decode(dati);
          ricevuti.add(data);
          _ricevutomessaggio();
        },
      ); 
    },onError: (errore) {
      _errore("Il server non è raggiungibile riconnessione in corso ");
    },);
  }
   _errore(String t){
    
    username.insert(0, "Server");
    Messaggi msg = Messaggi(
          txt: t,
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 800)),
        );
      setState(() {
        _messaggi.insert(0, msg);
    msg.animationController.forward();
      });
      return null;
  }
  void _inviamessaggio(String txt) {
    if (s == null) {
      starts();
    } else {
      username.insert(0, defaultUserName);
      //_save(jsonEncode(username));
      if (_textController.text.isNotEmpty) {
        s.write("${_textController.text}"+"-"+"$defaultUserName");
        _textController.text = "";
      }
      _textController.clear();
      setState(() {
        _stascrivendo = false;
      });
      if (scorrilista(txt) != null) {
        String gif = scorrilista(txt);
        Image img1 = Image(
          image: AssetImage("assets/$gif.gif"),
          height: 150,
        );
        Img img = Img(
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 800)),
          txt: img1,
        );
        setState(() {
          _messaggi.insert(0, img);
        });
        img.animationController.forward();
      } else {
        Messaggi msg = Messaggi(
          txt: txt,
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 800)),
        );
        setState(() {
          _messaggi.insert(0, msg);
        });
        msg.animationController.forward();
      }
    }
  }
  _utenticonnessi(){
       var lista = username.toSet().toList();
       String text="";
      print(lista);
       for(int i=0;i<lista.length;i++){
         if(lista[i]!="Server"){
          text=text+"-"+lista[i];
         }
       }
        username.insert(0,"Server");
        Messaggi msg = Messaggi(
          txt: text,
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 800)),
        );
      setState(() {
        _messaggi.insert(0, msg);
        msg.animationController.forward();
      });
      
  }
  _ricevutomessaggio() {
    if (server == false) {
      server = true;
      String txt = ricevuti.last;
      List<String> ltxt = txt.split('-');
      utentionline = int.parse(ltxt[1])+1;
      username.insert(0, "Server");
      //_save(jsonEncode(username));
      Messaggi msg = Messaggi(
        txt: ltxt[0] + ltxt[1] + ltxt[2],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 800)),
      );
      setState(() {
        _messaggi.insert(0, msg);
        //_save2(jsonEncode(_messaggi));
      });
      msg.animationController.forward();
     } else {
      String txt = ricevuti.last;
      print(txt);
      List<String> ltxt = txt.split('-');
      txt = ltxt[0];
      username.insert(0, ltxt[1]);
      //_save(jsonEncode(username));
      utentionline = int.parse(ltxt[2]) + 1;
      String nome = scorrilista(txt);
      print(nome);
      if (nome != null) {
        Image img1 = Image(
          image: AssetImage("assets/$nome.gif"),
          height: 150,
        );
        Img img = Img(
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 800)),
          txt: img1,
        );
        setState(() {
          _messaggi.insert(0, img);
          //_save2(jsonEncode(_messaggi));
        });
        img.animationController.forward();
      } else {
        Messaggi msg = Messaggi(
          txt: txt,
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 800)),
        );
        setState(() {
          _messaggi.insert(0, msg);
          //_save2(jsonEncode(_messaggi));
        });
        msg.animationController.forward();
      }
    }
      
  }
/*
  _save(String s) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    final text = s;
    await file.writeAsString(text);
    print('saved');
  }

  _save2(String s) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file1.txt');
    final text = s;
    await file.writeAsString(text);
    print('saved');
  }*/

  String scorrilista(String s) {
    for (int i = 0; i < _gif.length; i++) {
      if (s == _gif[i]) {
        return s;
      }
    }
    return null;
  }
}
/*
_read2() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file1.txt');
    String text = await file.readAsString();
    return text;
  } catch (e) {
    print("Couldn't read file");
    //_messaggi=[];
  }
}

_read() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    String text = await file.readAsString();
    return text;
  } catch (e) {
    print("Couldn't read file");
    //username=[];
  }
}
*/
class PaginaLogin extends StatelessWidget {
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Pagina Login',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryContrastingColor: CupertinoColors.black,
        primaryColor: CupertinoColors.black,
        scaffoldBackgroundColor: CupertinoColors.white,
        //textTheme: CupertinoTextThemeData(brightness:Brightness.dark,primaryColor: CupertinoColors.activeBlue,   textStyle: TextStyle(fontStyle: FontStyle.normal))
      ),
      home:  WidgetPaginaLogin(),
    );
  }
}

class WidgetPaginaLogin extends StatefulWidget {
  Login createState() => Login();
}

class Login extends  State<WidgetPaginaLogin> {
  
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("assets/chat.png"), height: 400),
          SizedBox(height: 50),
          Container(
              child: Text("CHATROOM",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontFamily: 'Ewert',
                    fontSize: 25.0,
                  ))),
          bottoneLogin(),
        ],
      ),
    ));
  }

  Widget bottoneLogin() {
    return OutlineButton(
      splashColor: CupertinoColors.black,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Chat();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(
        color: CupertinoColors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 25,
                  color: CupertinoColors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Messaggi extends StatelessWidget {
  Messaggi({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;
  int isss = 0;
  Widget build(BuildContext ctx) {
    isss++;
    if (username[isss - 1] == "Server") {
      change = serverr;
    } else {
      if (username[isss - 1] == defaultUserName) {
        change = utente;
      } else {
        change = altroutente;
      }
    }
    return SizeTransition(
      sizeFactor:
           //Animator
          //TrainHoppingAnimation(_currentTrain, _nextTrain),
          CurvedAnimation(parent: animationController, curve: Curves.easeInOutCirc),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: CircleAvatar(
                child: Text(username[isss - 1][0]),
                backgroundColor: change,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(username[isss - 1],
                      style: Theme.of(ctx).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: Text(txt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Img extends StatelessWidget {
  Img({this.txt, this.animationController});
  final Image txt;
  final AnimationController animationController;
  int isss = 0;
  Widget build(BuildContext ctx) {
    isss++;
    if (username[isss - 1] == "Server") {
      change = serverr;
    } else {
      if (username[isss - 1] == defaultUserName) {
        change = utente;
      } else {
        change = altroutente;
      }
    }
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.linear),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: CircleAvatar(
                child: Text(username[isss - 1][0]),
                backgroundColor: change,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(username[isss - 1],
                      style: Theme.of(ctx).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 6.0),
                    child: txt,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}