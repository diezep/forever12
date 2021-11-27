class Client {
  String? name, email, domicilio, phoneNumber;
  int? id;

  Client({this.name, this.id, this.email, this.domicilio, this.phoneNumber});

  static Client fromMap(Map<dynamic, dynamic> map) {
    return Client(
      id: map["id_cliente"],
      email: map["correo_e"],
      name: map["nombre"],
      domicilio: map["domicilio"],
      phoneNumber: map["telefono"],
    );
  }
}
