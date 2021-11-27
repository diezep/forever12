import 'package:flutter/material.dart';
import 'package:forever12/models/product.dart';

class ProductCardClient extends StatelessWidget {
  const ProductCardClient({Key? key, required this.product, this.onBuy})
      : super(key: key);
  final Product product;
  final Function()? onBuy;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(product.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Expanded(
                  child:
                      Text(product.description, overflow: TextOverflow.fade)),
              SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onBuy,
                    child: Text('Comprar'),
                    style: ElevatedButton.styleFrom(elevation: 0),
                  ),
                  SizedBox(width: 10),
                  Text("\$ ${product.price} MXN"),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  toList() {}
}
