// ignore_for_file: unused_import, must_be_immutable, avoid_print, prefer_final_fields, unused_field, deprecated_member_use, non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_myapp/modelos/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';

class Actulizar extends StatelessWidget {
  Actulizar(
      {Key? key,
      required this.nombre,
      required this.apellido,
      required this.genero,
      required this.correo,
      required this.Tok})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomControl = TextEditingController();
  late TextEditingController _apeControl = TextEditingController();
  late TextEditingController _genesex = TextEditingController();
  late TextEditingController _imeilfield = TextEditingController();
  late TextEditingController _idcorreo = TextEditingController();
  late TextEditingController _passfield = TextEditingController();
  late TextEditingController _repetPassfield = TextEditingController();
  late TextEditingController _resp = TextEditingController();
  late TextEditingController Tok = TextEditingController();

  bool _isValid = false;
  String nombre;
  String apellido;
  String genero;
  String correo;

  @override
  Widget build(BuildContext context) {
    _nomControl.text = nombre;
    _apeControl.text = apellido;
    _genesex.text = genero;
    _imeilfield.text = correo;
    _idcorreo.text = correo;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Actualizar datos'),
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
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_outline),
                      hintText: 'Genero',
                      labelText: 'Genero',
                    ),
                    controller: _genesex,
                    validator: (value) {
                      if (_genesex.text.isEmpty) {
                        return 'por favor ingrese su apellido';
                      }
                      return null;
                    },
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
                      _isValid = EmailValidator.validate(_imeilfield.text);

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
                          users();
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

  Future users() async {
    var resp = await http.put(
        Uri.parse(
            'https://aplicacionappflutter.herokuapp.com/actuali/${_idcorreo.text}'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${Tok.text}',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "nombre": _nomControl.text,
          "apellido": _apeControl.text,
          "sexo": _genesex.text,
          "correo": _imeilfield.text,
          "password": _passfield.text
        }),
        encoding: Encoding.getByName("utf-8"));
  }
}
