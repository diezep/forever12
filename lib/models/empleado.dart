class Employee {
  String? email, nombre, domicilio, puesto, telefono;
  int? id, tienda;
  double? sueldo;

  Employee(
      {this.id = -1,
      this.email,
      this.nombre,
      this.domicilio,
      this.telefono,
      this.sueldo,
      this.puesto,
      this.tienda});

  static Employee fromMap(Map<dynamic, dynamic> map) {
    return Employee(
      id: map["id_empleado"],
      email: map["correo_e"],
      nombre: map["nombre"],
      domicilio: map["domicilio"],
      telefono: map["telefono"],
      sueldo: map["sueldo"],
      puesto: map["puesto"],
      tienda: map["tienda"],
    );
  }
}
