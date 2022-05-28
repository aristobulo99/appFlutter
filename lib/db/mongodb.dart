// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, null_argument_to_non_null_type, non_constant_identifier_names

/*import "package:mongo_dart/mongo_dart.dart";
import 'package:flutter_myapp/modelos/usuario.dart';
import 'package:flutter_myapp/utilidades/constante.dart';

class MongoDB {
  static var db, coleccionUsuarios;

  static conectar() async {
    db = await Db.create(CONEXION);
    await db.open();
    coleccionUsuarios = db.collection(COLECCION);
  }

  static Future<List<Map<String, dynamic>>> getUsuarios() async {
    try {
      final Usuarios = await coleccionUsuarios.find().toList();
      return Usuarios;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static insertar(Usuario usuario) async {
    await coleccionUsuarios.insertAll([usuario.toMap()]);
  }

  static actualizar(Usuario usuario) async {
    var j = await coleccionUsuarios.findOne({"_id": usuario.id});
    j["nombre"] = usuario.nombre;
    j["apellido"] = usuario.apellido;
    j["correo"] = usuario.correo;
    j["password"] = usuario.password;
  }

  static eliminar(Usuario usuario) async {
    await coleccionUsuarios.remove(where.id(usuario.id));
  }
}*/
