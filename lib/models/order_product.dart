import 'package:forever12/models/product.dart';

class OrderProduct extends Product {
  int quantity;

  OrderProduct(Product product, [this.quantity = 1])
      : super(
            id: product.id,
            name: product.name,
            price: product.price,
            image: product.image,
            description: product.description,
            stock: product.stock,
            departamento: product.departamento,
            departamentoNombre: product.departamentoNombre);
}
