class Product {
  int id, stock, departamento;
  String name, description, image;
  double price;
  String? departamentoNombre;

  // Create a constructor from properties
  Product({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.image = '',
    this.price = 0,
    this.stock = 0,
    this.departamento = 0,
    this.departamentoNombre = '',
  });

  static Product fromMap(Map<dynamic, dynamic> map) {
    return Product(
      id: map["id_producto"],
      name: map["nombre"],
      image: map["imagen"],
      description: map["descripcion"],
      stock: map["stock"],
      price: map["precio_venta"],
      departamentoNombre: map["departamento"],
    );
  }
}
