class Usuario {
  final String nombre;
  final String apellido;
  final String correo;
  final String password;

  const Usuario(
      {required this.nombre,
      required this.apellido,
      required this.correo,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'password': password
    };
  }

  Usuario.fronMap(Map<String, dynamic> nap)
      : nombre = nap['nombre'],
        apellido = nap['apellido'],
        correo = nap['correo'],
        password = nap['password'];
}
