// ignore_for_file: unused_import, deprecated_member_use, avoid_print, prefer_is_empty, unrelated_type_equality_checks, unused_field, prefer_final_fields, library_prefixes, unnecessary_null_comparison, unused_local_variable, unused_element, dead_code

//import 'dart:ffi';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_myapp/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_myapp/modelos/usuario.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Navegacion_prue extends StatefulWidget {
  const Navegacion_prue({Key? key}) : super(key: key);

  @override
  _Navegacion_prue_PageState createState() => _Navegacion_prue_PageState();
}

// ignore: camel_case_types
class _Navegacion_prue_PageState extends State<Navegacion_prue> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomControl = TextEditingController();
  late TextEditingController _apeControl = TextEditingController();
  late TextEditingController _imeilfield = TextEditingController();
  late TextEditingController _passfield = TextEditingController();
  late TextEditingController _repetPassfield = TextEditingController();
  late TextEditingController _resp = TextEditingController();

  bool _isValid = false;

  @override
  void dispose() {
    _nomControl.dispose();
    _apeControl.dispose();
    _imeilfield.dispose();
    _passfield.dispose();
    _repetPassfield.dispose();
    _resp.dispose();
    super.dispose();
  }

  String sex = 'hombre';
  late List<String> pru;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrar'),
        ),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_outline),
                      hintText: 'Nombre',
                      labelText: 'Nombre',
                    ),
                    controller: _nomControl,
                    validator: (value) {
                      if (_nomControl.text.isEmpty) {
                        return 'por favor ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_outline),
                      hintText: 'Apellido',
                      labelText: 'Apellido',
                    ),
                    controller: _apeControl,
                    validator: (value) {
                      if (_apeControl.text.isEmpty) {
                        return 'por favor ingrese su apellido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Column(
                    children: [
                      const Text('Genero'),
                      RadioListTile(
                          title: const Text('Hombre'),
                          value: 'hombre',
                          groupValue: sex,
                          onChanged: (value) {
                            setState(() {
                              sex = 'hombre';
                            });
                          }),
                      RadioListTile(
                          title: const Text('Mujer'),
                          value: 'mujer',
                          groupValue: sex,
                          onChanged: (value) {
                            setState(() {
                              sex = 'mujer';
                            });
                          })
                    ],
                  ),
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
                    controller: _imeilfield,
                    validator: (value) {
                      setState(() {
                        _isValid = EmailValidator.validate(_imeilfield.text);
                      });
                      if (!_isValid) {
                        return 'Correo no valido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: 'Password',
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    controller: _passfield,
                    validator: (value) {
                      if (_passfield.text.isEmpty) {
                        return 'por favor ingrese una contraseña';
                      }
                      if (_passfield.text.length < 5) {
                        return 'La contraseña es muy corta';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: 'Password',
                      labelText: 'Repetir Password',
                    ),
                    obscureText: true,
                    controller: _repetPassfield,
                    validator: (value) {
                      if (_repetPassfield.text != _passfield.text) {
                        return 'Las contraseñas no coinciden';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: const Text(
                        'Registrar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                      color: const Color(0xFF961212),
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Fluttertoast.showToast(
                              msg: 'Procesando datos',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0);
                          users(sex);
                          Navigator.pop(context);
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future users(sex) async {
    var resp = await http.post(
        Uri.parse('https://aplicacionappflutter.herokuapp.com/add'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "nombre": _nomControl.text,
          "apellido": _apeControl.text,
          "sexo": sex,
          "correo": _imeilfield.text,
          "password": _passfield.text
        }),
        encoding: Encoding.getByName("utf-8"));
    print('-----------------------');
    print(resp.body);
  }
}
