import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forever12/models/empleado.dart';
import 'package:forever12/models/order.dart';
import 'package:forever12/models/product.dart';
import 'package:forever12/models/store.dart';
import 'package:forever12/services/Database.dart';
import 'package:forever12/widgets/card_product_cashier.dart';

class HomeCashierScreen extends StatefulWidget {
  HomeCashierScreen({Key? key}) : super(key: key);

  @override
  State<HomeCashierScreen> createState() => _HomeCashierScreenState();
}

class _HomeCashierScreenState extends State<HomeCashierScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Database database = Database();
  Order order = Order();
  Store? currentStore;
  Employee employee = Employee();

  Future<List<Store>> futureStores = Future.value([]);
  Future<List<Product>> futureProducts = Future.value([]);

  initializeDB() async {
    await database.initialize();
    setState(() {
      futureStores = database.getStores();
    });
  }

  Future<void> onAddOrder() async {
    bool executed = await database.addOrder(order, currentStore!);
    if (executed) {
      setState(() {
        order = Order();
        futureProducts = database.getProducts(currentStore!.id!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Ha ocorrido un error al realizar la orden. Intentalo de nuevo')));
    }
  }

  Future<void> onUpdateClient() async {
    // bool executed = await database.updateClient(employee);
    // if (!executed) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(
    //           'Ha ocorrido un error al realizar tu perfil. Intentalo de nuevo.')));
    // }
  }

  @override
  void initState() {
    initializeDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text.rich(TextSpan(
              text: 'Forever12: ',
              style: textTheme.headline5
                  ?.apply(fontWeightDelta: 2, color: Colors.black),
              children: [
                TextSpan(
                    text: 'Cajero',
                    style: TextStyle(fontWeight: FontWeight.normal))
              ])),
          centerTitle: false,
          actions: [
            Container(
              width: 300,
              margin: EdgeInsets.symmetric(vertical: 3),
              child: FutureBuilder<List<Store>>(
                  future: futureStores,
                  builder: (context, snapshot) {
                    List<Store> _stores = (snapshot.data ?? [])
                        .where((e) => e.ubication!)
                        .toList();

                    return DropdownButtonFormField<Store>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (store) => setState(() {
                              currentStore = store!;
                              futureProducts = database.getProducts(store.id!);
                            }),
                        decoration: InputDecoration(
                            hintText: 'Selecciona la tienda',
                            enabled: snapshot.hasData,
                            prefixIcon: Icon(Icons.store_outlined),
                            suffixIcon: snapshot.hasError
                                ? Icon(Icons.error_outline)
                                : null,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black),
                                gapPadding: 2)),
                        items: _stores
                            .map((e) => DropdownMenuItem<Store>(
                                  value: e,
                                  child: Text(
                                      "${e.name ?? 'SIN NOMBRE'}: ${e.ubication! ? 'FISICA' : 'VIRTUAL'}"),
                                ))
                            .toList());
                  }),
            ),
            SizedBox(width: 12),
            IconButton(
                color: Colors.black,
                onPressed: onRestart,
                icon: Icon(Icons.refresh)),
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Row(
            children: [
              Flexible(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      Text(
                        'Productos',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(height: 18),
                      Expanded(
                        child: FutureBuilder<List<Product>>(
                          future: futureProducts,
                          builder: (context, snapshot) {
                            List<Product> products = snapshot.data ?? [];

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Icon(Icons.error),
                              );
                            }

                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                (snapshot.data?.isEmpty ?? true) &&
                                currentStore != null)
                              return Center(
                                child: SizedBox(
                                  width: 300,
                                  child: Text(
                                    'No se ha encontrado productos registrado en esta tienda.',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );

                            return GridView.count(
                              shrinkWrap: true,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                              crossAxisCount: constraints.maxWidth ~/ 400,
                              childAspectRatio: 2 / 1,
                              children: products
                                  .map((e) => ProductCardCashier(
                                      product: e,
                                      onBuy: (order.products?.any(
                                                      (p) => p.id == e.id) ??
                                                  false) ||
                                              e.stock == 0
                                          ? null
                                          : () => setState(
                                              () => order.addProduct(e))))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.grey.shade300,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Carrito de compras',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 12),
                      Expanded(
                        child: order.products?.isEmpty ?? true
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Text(
                                  'Aún has agregado productos a tu carrito.',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ))
                            : ListView(
                                shrinkWrap: true,
                                children: order.products
                                        ?.map((e) => Container(
                                              margin: EdgeInsets.only(left: 16),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 64,
                                                    height: 64,
                                                    child: ClipRRect(
                                                      child: Image.network(
                                                          e.image,
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          e.name,
                                                          style: textTheme
                                                              .subtitle1,
                                                        ),
                                                        Text(e.description,
                                                            style: textTheme
                                                                .caption),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Column(
                                                    children: [
                                                      IconButton(
                                                        onPressed: e.quantity ==
                                                                e.stock
                                                            ? null
                                                            : () => setState(
                                                                () => e
                                                                    .quantity++),
                                                        icon: Icon(Icons.add,
                                                            size: 14),
                                                      ),
                                                      Text("${e.quantity}"),
                                                      IconButton(
                                                        onPressed: () =>
                                                            setState(() {
                                                          e.quantity--;
                                                          if (e.quantity == 0)
                                                            order.removeProduct(
                                                                e);
                                                        }),
                                                        icon: Icon(Icons.remove,
                                                            size: 14),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 8),
                                                ],
                                              ),
                                            ))
                                        .toList() ??
                                    []),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('SUBTOTAL',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    "\$ ${order.subtotal.toStringAsFixed(2)} MXN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('I.V.A.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("\$ ${order.iva.toStringAsFixed(2)} MXN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('TOTAL',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    "\$ ${order.total.toStringAsFixed(2)} MXN"),
                              ],
                            ),
                            SizedBox(height: 18),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    padding: EdgeInsets.symmetric(vertical: 22),
                                  ),
                                  onPressed: order.products?.isEmpty ?? true
                                      ? null
                                      : onAddOrder,
                                  child: Text("REALIZAR PAGO")),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }));
  }

  void onRestart() async {
    database.databaseConnection?.close();
    await database.initialize();

    setState(() {
      order = Order();
    });
  }
}
