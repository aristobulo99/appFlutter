// ignore_for_file: unused_import, non_constant_identifier_names, camel_case_types, await_only_futures, prefer_typing_uninitialized_variables, unused_local_variable, avoid_print, avoid_unnecessary_containers, must_be_immutable, avoid_function_literals_in_foreach_calls, unrelated_type_equality_checks, unnecessary_null_comparison, unnecessary_brace_in_string_interps, deprecated_member_use, void_checks

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_myapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_myapp/modelos/usuario.dart';
import 'package:flutter_myapp/actualizar.dart';
import 'package:flutter_myapp/otrosUser.dart';
import 'package:http/http.dart' as http;

class Usuario {
  final String nombre;
  final String apellido;
  final String sexo;
  final String correo;

  const Usuario(
      {required this.nombre,
      required this.apellido,
      required this.sexo,
      required this.correo});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: json['nombre'],
      apellido: json['apellido'],
      sexo: json['sexo'],
      correo: json['correo'],
    );
  }
}

class Ingreso extends StatelessWidget {
  //user fetchPost()
  Ingreso({Key? key, required this.Token, required this.correoingre})
      : super(key: key);
  late TextEditingController Token = TextEditingController();
  late TextEditingController correoingre = TextEditingController();
  late TextEditingController nomuser = TextEditingController();

  Future<Usuario> prueba() async {
    var resp = await http.get(
        Uri.parse(
            'https://aplicacionappflutter.herokuapp.com/user/${correoingre.text}'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${Token.text}'
        });

    if (resp.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return Usuario.fromJson(json.decode(resp.body));
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<Usuario>(
          future: prueba(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                      'Bienvenido ${snapshot.data!.nombre} ${snapshot.data!.apellido}'),
                ),
                body: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: const Text(
                                    'Otros usuarios',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  color: const Color(0xFF961212),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80.0),
                                  onPressed: () async {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return OtrosUser(Tok: Token);
                                    }));
                                  }),
                              const SizedBox(
                                height: 15.0,
                              ),
                              FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: const Text(
                                    'Actualizar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  color: const Color(0xFF961212),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80.0),
                                  onPressed: () async {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return Actulizar(
                                        nombre: snapshot.data!.nombre,
                                        apellido: snapshot.data!.apellido,
                                        genero: snapshot.data!.sexo,
                                        correo: snapshot.data!.correo,
                                        Tok: Token,
                                      );
                                    }));
                                  }),
                              const SizedBox(
                                height: 15.0,
                              ),
                              FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: const Text(
                                    'Eliminar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  color: const Color(0xFF961212),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80.0),
                                  onPressed: () async {
                                    var resp = await http.delete(
                                        Uri.parse(
                                            'https://aplicacionappflutter.herokuapp.com/delite/${correoingre.text}'),
                                        headers: {
                                          'accept': '*/*',
                                          'Authorization':
                                              'Bearer ${Token.text}'
                                        });
                                    print(resp.statusCode);
                                    Navigator.pop(context);
                                  }),
                              const SizedBox(
                                height: 15.0,
                              ),
                            ])),
                  ),
                ),
              );
            } else {
              return Text("${snapshot.error}");
            }
          },
        ),
      ),
    );
  }

//esta es la forma de extraer los datos

}
