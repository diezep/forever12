import 'package:flutter/material.dart';
import 'package:forever12/models/product.dart';

class ProductCardSmall extends StatelessWidget {
  const ProductCardSmall({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [Container(height: 200, width: 200)]));
  }
}
