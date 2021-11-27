class Store {
  int? id;
  bool? ubication;
  String? name;

  Store({this.id, this.name, this.ubication = true});

  static Store fromMap(Map<dynamic, dynamic> map) {
    return Store(
      id: map["id_tienda"],
      name: map["nombre"],
      ubication: map["ubicacion"],
    );
  }
}
