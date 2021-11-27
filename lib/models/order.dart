import 'package:forever12/models/order_product.dart';
import 'package:forever12/models/product.dart';

class Order {
  String? id, clientId, status;

  List<OrderProduct>? products;

  Order({this.id, this.clientId, this.status});

  void addProduct(Product product) {
    products ??= [];
    products?.add(OrderProduct(product));
  }

  void removeProduct(OrderProduct product) {
    products?.remove(product);
  }

  double get subtotal => products?.isEmpty ?? true
      ? 0
      : products
              ?.map((e) => e.price * e.quantity)
              .cast<double>()
              .reduce((v1, v2) => v1 + v2) ??
          10;
  double get iva => subtotal * .16;
  double get total => subtotal + iva;
}
