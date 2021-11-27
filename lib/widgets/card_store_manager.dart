import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forever12/models/store.dart';

class CardStoreManager extends StatelessWidget {
  CardStoreManager({
    Key? key,
    required this.store,
    required this.futureCountEmployees,
    required this.futureCountProducts,
  }) : super(key: key);
  Store store;
  Future<int> futureCountEmployees, futureCountProducts;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre', style: textTheme.caption),
                    SizedBox(height: 6),
                    Text("${store.name}",
                        style: textTheme.headline5!.apply(fontWeightDelta: 2)),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo', style: textTheme.caption),
                  SizedBox(height: 6),
                  Text("${store.ubication! ? 'FISICA' : 'EN LINEA'}",
                      style: textTheme.headline6),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Empleados', style: textTheme.caption),
                  SizedBox(height: 6),
                  FutureBuilder<int>(
                      future: futureCountEmployees,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return Icon(Icons.error);
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return CircularProgressIndicator.adaptive();
                        return Text("${snapshot.data}",
                            style: textTheme.headline6);
                      }),
                ],
              ),
              SizedBox(width: 24),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Productos', style: textTheme.caption),
                  SizedBox(height: 6),
                  FutureBuilder<int>(
                      future: futureCountProducts,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return Icon(Icons.error);
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return CircularProgressIndicator.adaptive();
                        return Text("${snapshot.data}",
                            style: textTheme.headline6);
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
