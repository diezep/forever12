import 'package:forever12/constants.dart';
import 'package:forever12/models/client.dart';
import 'package:forever12/models/empleado.dart';
import 'package:forever12/models/order.dart';
import 'package:forever12/models/product.dart';
import 'package:forever12/models/store.dart';
import 'package:postgresql2/postgresql.dart';

class Database {
  Connection? databaseConnection;
  List<Product> products = [];

  Future initialize() async {
    databaseConnection = await connect(URL_DATABASE);
  }

  Future<int?> addClient(Client client) async {
    try {
      String query =
          "INSERT INTO cliente(nombre, domicilio, telefono, correo_e) VALUES (@name, @domicilio, @phoneNumber, @email) RETURNING cliente.id_cliente;";
      var args = {
        "name": client.name,
        "email": client.email,
        "domicilio": client.domicilio,
        "phoneNumber": client.phoneNumber,
      };

      var rows = await databaseConnection!.query(query, args).toList();
      return rows.first.toList().first;
    } catch (e) {
      return -1;
    }
  }

  Future<bool> addOrder(Order order, Store store, [Client? client]) async {
    try {
      String query =
          "INSERT INTO venta(cliente, tienda, estatus) VALUES (@clientId, @storeId, false) RETURNING venta.id_venta;";
      var args = {"clientId": client?.id, "storeId": store.id};

      var rows = await databaseConnection!.query(query, args).toList();
      int orderId = rows.first.toList().first;

      String queryAddProducts =
          "INSERT INTO venta_producto (venta, producto, cantidad) VALUES "
          "${order.products?.map((e) => "($orderId, ${e.id}, ${e.quantity})").join(', ')};";

      await databaseConnection!.execute(queryAddProducts);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Product>> getProducts(int storeId) async {
    List<Product> _products = [];
    var rows = await databaseConnection!
        .query("SELECT * FROM pro_tie_dep WHERE id_tienda = $storeId;")
        .toList();
    for (var row in rows) {
      Map<dynamic, dynamic> map = row.toMap();

      _products.add(Product.fromMap(map));
    }
    products = _products;
    return _products;
  }

  Future<Client?> getClient(String email) async {
    String query = "SELECT * FROM cliente WHERE correo_e = @email;";
    var args = {"email": email};
    ;
    try {
      var rows = await databaseConnection!.query(query, args).toList();
      Client client = Client.fromMap(rows.first.toMap());
      return client;
    } catch (e) {
      return null;
    }
  }

  Future<List<Store>> getStores() async {
    List<Store> stores = [];
    var rows =
        await databaseConnection!.query("SELECT * FROM tienda;").toList();
    for (var row in rows) {
      Map<dynamic, dynamic> map = row.toMap();
      Store tmp = Store.fromMap(map);
      stores.add(tmp);
    }

    return stores;
  }

  Future<bool> updateClient(Client client) async {
    String query =
        "UPDATE cliente SET nombre = @name, correo_e = @email, telefono = @phoneNumber, domicilio = @domicilio WHERE id_cliente = @id;";
    Map<String, dynamic> args = {
      "id": client.id,
      "name": client.name,
      "email": client.email,
      "domicilio": client.domicilio,
      "phoneNumber": client.phoneNumber,
    };

    var res = await databaseConnection!.execute(query, args);

    return res != 0;
  }

  Future<bool> removeProduct(int id) async {
    String query1 = "DELETE FROM producto WHERE id_producto = @idProducto;";
    int res = await databaseConnection!.execute(query1, {"idProducto": id});

    return res != 0;
  }

  Future<bool> updateProduct(Product product) async {
    String query =
        "UPDATE producto SET nombre = @name, descripcion = @descripcion, imagen = @imagen, stock = @stock, precio_venta = @price WHERE id_producto = @id;";
    Map<String, dynamic> args = {
      "id": product.id,
      "name": product.name,
      "descripcion": product.description,
      "imagen": product.image,
      "stock": product.stock,
      "price": product.price,
    };

    var res = await databaseConnection!.execute(query, args);

    return res != 0;
  }

  Future<bool> addProduct(Product product, Store store) async {
    String query =
        "INSERT INTO producto(nombre, descripcion, imagen, stock, precio_venta) VALUES (@name, @descripcion, @imagen, @stock, @price) RETURNING producto.id_producto;";
    Map<String, dynamic> args = {
      "name": product.name,
      "descripcion": product.description,
      "imagen": product.image,
      "stock": product.stock,
      "price": product.price,
    };

    var res = await databaseConnection!.query(query, args).toList();
    product.id = res[0].toMap()["id_producto"];

    query =
        "INSERT INTO producto_departamento (producto, departamento) VALUES (@idProduct, @idDepartamento);";
    args = {
      "idProduct": product.id,
      "idDepartamento": product.departamento,
    };

    await databaseConnection!.execute(query, args);

    query =
        "INSERT INTO tienda_producto (producto, tienda) VALUES (@idProduct, @idStore);";
    args = {
      "idProduct": product.id,
      "idStore": store.id,
    };

    int lastRes = await databaseConnection!.execute(query, args);

    return lastRes != 0;
  }

  Future<List<Employee>> getEmployees(int storeId) async {
    List<Employee> employees = [];
    var rows = await databaseConnection!
        .query("SELECT * FROM empleado WHERE tienda = $storeId;")
        .toList();
    for (var row in rows) {
      Map<dynamic, dynamic> map = row.toMap();
      Employee tmp = Employee.fromMap(map);
      employees.add(tmp);
    }

    return employees;
  }

  Future<bool> removeEmployee(int id) async {
    String query1 = "DELETE FROM empleado WHERE id_empleado = $id;";
    int res = await databaseConnection!.execute(query1);

    return res != 0;
  }

  Future<bool> updateEmployee(Employee employee) async {
    String query =
        "UPDATE empleado SET nombre = @name, correo_e = @email, domicilio = @domicilio, telefono = @telefono, sueldo = @sueldo WHERE id_empleado = @id;";
    Map<String, dynamic> args = {
      "id": employee.id,
      "name": employee.nombre,
      "email": employee.email,
      "domicilio": employee.domicilio,
      "telefono": employee.telefono,
      "sueldo": employee.sueldo,
    };

    var res = await databaseConnection!.execute(query, args);

    return res != 0;
  }

  Future<bool> addEmployee(Employee employee) async {
    String query =
        "INSERT INTO empleado(nombre, correo_e, domicilio, telefono, sueldo, tienda, puesto) VALUES (@name,  @email, @domicilio, @telefono, @salary, @storeId, 'Cajero')";
    Map<String, dynamic> args = {
      "name": employee.nombre,
      "email": employee.email,
      "domicilio": employee.domicilio,
      "telefono": employee.telefono,
      "salary": employee.sueldo,
      "storeId": employee.tienda,
    };

    var res = await databaseConnection!.execute(query, args);

    return res != 0;
  }

  Future<bool> addStore(Store store) async {
    String query =
        "INSERT INTO tienda(nombre, ubicacion) VALUES (@name,  @ubicacion);";
    Map<String, dynamic> args = {
      "name": store.name,
      "ubicacion": store.ubication,
    };

    var res = await databaseConnection!.execute(query, args);

    return res != 0;
  }

  Future<int> getEmployeesCount(int storeId) async {
    String query =
        "SELECT COUNT(id_empleado) FROM empleado WHERE tienda = $storeId;";
    return (await databaseConnection!.query(query).toList())
        .first
        .toList()
        .first;
  }

  Future<int> getProductsCount(int storeId) async {
    String query =
        "SELECT COUNT(producto) FROM tienda_producto WHERE tienda = $storeId;";
    return (await databaseConnection!.query(query).toList())
        .first
        .toList()
        .first;
  }
}
