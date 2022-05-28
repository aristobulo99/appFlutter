// ignore_for_file: unused_import, file_names, non_constant_identifier_names, must_be_immutable, avoid_unnecessary_containers, avoid_print, unused_local_variable, unnecessary_new, empty_statements
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_myapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_myapp/modelos/usuario.dart';
import 'package:flutter_myapp/actualizar.dart';
import 'package:http/http.dart' as http;

class OtrosUser extends StatelessWidget {
  OtrosUser({Key? key, required this.Tok}) : super(key: key);
  late TextEditingController Tok = TextEditingController();

  Future<List<dynamic>> prueba() async {
    var resp = await http.get(
        Uri.parse('https://aplicacionappflutter.herokuapp.com/users'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${Tok.text}'
        });
    if (resp.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      return json.decode(resp.body);
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    var lista = prueba();
    return Scaffold(
        appBar: AppBar(title: const Text("Todos los Datos")),
        body: Container(
            child: FutureBuilder<List<dynamic>>(
                future: lista,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.map),
                          title: Text(snapshot.data![index]['nombre'] +
                              ' ' +
                              snapshot.data![index]['apellido'] +
                              ' ' +
                              snapshot.data![index]['sexo']),
                          subtitle: Text(snapshot.data![index]['correo']),
                          onTap: () {},
                        );
                      },
                      separatorBuilder: (contex, index) =>
                          const Divider(height: 1.0, color: Colors.black),
                    );
                  } else {
                    return Text("${snapshot.error}");
                  }
                })));
  }
}
