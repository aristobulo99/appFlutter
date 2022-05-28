// ignore_for_file: deprecated_member_use, camel_case_types, unused_field, avoid_print, unused_import, duplicate_ignore, prefer_final_fields, unused_local_variable, unnecessary_null_comparison, non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_myapp/registro.dart';
import 'package:flutter_myapp/ingreso.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xFF961212))),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _email = TextEditingController();
  late TextEditingController _pass = TextEditingController();
  late TextEditingController token = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    //var navigator = Navigator;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Inicio')),
        body: Center(
            child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Image(
                    image: AssetImage('images/escudo.png'), height: 250),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'ejemplo@correo.com',
                    labelText: 'Correo Electronico',
                  ),
                  controller: _email,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Password',
                    labelText: 'Password',
                  ),
                  controller: _pass,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                        child: const Text(
                          'Iniciar sesion',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        color: const Color(0xFF961212),
                        onPressed: () async {
                          var resp = await http.post(
                              Uri.parse(
                                  'https://aplicacionappflutter.herokuapp.com/token'),
                              headers: {
                                'accept': 'application/json',
                                'Content-Type':
                                    'application/x-www-form-urlencoded'
                              },
                              body: {
                                "username": _email.text,
                                "password": _pass.text
                              });
                          var resdata = json.decode(resp.body);
                          var tok = resdata['access_token'];
                          if (tok != null) {
                            token.text = tok;
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Ingreso(Token: token, correoingre: _email);
                            }));
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'El correo o constraseña ingresada no es valida',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                fontSize: 16.0);
                          }
                        }),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                        child: const Text('Registrar'),
                        textColor: const Color.fromARGB(255, 231, 14, 14),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const Navegacion_prue();
                          })).then((name) {
                            setState(() {});
                          });
                        }),
                    /*GoogleBtn1(onPressed: () async {
                      /* final user2 = await _googleSignIn.signIn();
                      print('-------------------');
                      print(user2);

                      if (user2 != null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const HorizontalCategoriesView();
                        }));
                      } */
                      await _googleSignIn.signIn().whenComplete(() => {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const HorizontalCategoriesView();
                            }))
                          });
                    })*/
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class GoogleBtn1 extends StatelessWidget {
  final Function() onPressed;
  const GoogleBtn1({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 54,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/crypto%2Fsearch%20(2).png?alt=media&token=24a918f7-3564-4290-b7e4-08ff54b3c94c",
                width: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Registrar con Google",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ],
          ),
          onPressed: onPressed,
        ));
  }
}
