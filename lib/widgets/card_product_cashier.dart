import 'package:flutter/material.dart';
import 'package:forever12/models/product.dart';

class ProductCardCashier extends StatelessWidget {
  const ProductCardCashier({Key? key, required this.product, this.onBuy})
      : super(key: key);
  final Product product;
  final Function()? onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: InkWell(
        onTap: onBuy,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(product.description,
                      overflow: TextOverflow.ellipsis, maxLines: 2),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text("PRECIO: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text(" \$ ${product.price} MXN"),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text("INVENTARIO: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text("${product.stock}"),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
