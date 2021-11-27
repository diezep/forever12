import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forever12/models/client.dart';
import 'package:forever12/models/order.dart';
import 'package:forever12/models/product.dart';
import 'package:forever12/models/store.dart';
import 'package:forever12/services/Database.dart';
import 'package:forever12/widgets/card_product_client.dart';
import 'package:forever12/widgets/dialog_order_info.dart';
import 'package:forever12/widgets/dialog_update_profile.dart';
import 'package:localstorage/localstorage.dart';
import 'package:postgresql2/postgresql.dart' as ps;

class HomeClientScreen extends StatefulWidget {
  HomeClientScreen({Key? key}) : super(key: key);

  @override
  State<HomeClientScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends State<HomeClientScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalStorage storage = new LocalStorage('forever12');

  Database database = Database();
  Order order = Order();
  Client client = Client();

  Future<List<Product>> futureProducts = Future.value([]);

  initializeDB() async {
    await database.initialize();
    setState(() {
      futureProducts = database.getProducts(1);
    });
  }

  Future<void> onAddOrder() async {
    if (client.id == null) {
      int? id = await database.addClient(client);
      client.id = id;
    }
    bool executed = await database.addOrder(order, Store(id: 1), client);
    if (executed) {
      setState(() {
        order = Order();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Ha ocorrido un error al realizar tu orden. Intentalo de nuevo')));
    }
  }

  Future<void> onUpdateClient() async {
    bool executed = await database.updateClient(client);
    if (!executed) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Ha ocorrido un error al realizar tu perfil. Intentalo de nuevo.')));
    }
  }

  Future<Client?> onGetClient(String email) async {
    Client? tmpClient = await database.getClient(email);
    await Future.delayed(Duration(seconds: 1));
    if (tmpClient != null) {
      setState(() => client = tmpClient);
      return tmpClient;
    } else {
      return null;
    }
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
                    text: 'Cliente',
                    style: TextStyle(fontWeight: FontWeight.normal))
              ])),
          centerTitle: false,
          actions: [
            IconButton(
                color: Colors.black,
                onPressed: () => {
                      showDialog(
                        context: context,
                        builder: (_) => UpdateProfileDialog(
                            client: client,
                            onUpdate: onUpdateClient,
                            onGetClient: onGetClient),
                      )
                    },
                icon: Icon(Icons.person_outline)),
            IconButton(
                color: Colors.black,
                onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
                icon: Icon(Icons.shopping_bag_outlined)),
            if (client.id != null)
              IconButton(
                  color: Colors.black,
                  onPressed: () => setState(() => client = Client()),
                  icon: Icon(Icons.logout)),
            SizedBox(width: 12),
            IconButton(
                color: Colors.black,
                onPressed: onRestart,
                icon: Icon(Icons.refresh)),
          ],
        ),
        endDrawer: Drawer(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Carrito de compras',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 20, color: Colors.grey),
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
                                              child: Image.network(e.image,
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.name,
                                                  style: textTheme.subtitle1,
                                                ),
                                                Text(e.description,
                                                    style: textTheme.caption),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: e.quantity == e.stock
                                                    ? null
                                                    : () => setState(
                                                        () => e.quantity++),
                                                icon: Icon(Icons.add, size: 14),
                                              ),
                                              Text("${e.quantity}"),
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  e.quantity--;
                                                  if (e.quantity == 0)
                                                    order.removeProduct(e);
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SUBTOTAL',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("\$ ${order.subtotal.toStringAsFixed(2)} MXN"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('I.V.A.',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("\$ ${order.iva.toStringAsFixed(2)} MXN"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("\$ ${order.total.toStringAsFixed(2)} MXN"),
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
                              : () async {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (context) => OrderInfoDialog(
                                          order: order,
                                          client: client,
                                          onOrder: onAddOrder));
                                },
                          child: Text("REALIZAR PEDIDO")),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: ListView(
              children: [
                SizedBox(height: 32),
                Text(
                  'Productos',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: 18),
                FutureBuilder<List<Product>>(
                  future: futureProducts,
                  builder: (context, snapshot) {
                    List<Product> products = snapshot.data ?? [];

                    return GridView.count(
                      shrinkWrap: true,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      crossAxisCount: constraints.maxWidth ~/ 200,
                      childAspectRatio: 0.8,
                      children: products
                          .map((e) => ProductCardClient(
                              product: e,
                              onBuy: (order.products
                                              ?.any((p) => p.id == e.id) ??
                                          false) ||
                                      e.stock == 0
                                  ? null
                                  : () => setState(() => order.addProduct(e))))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          );
        }));
  }

  void onRestart() async {
    database.databaseConnection?.close();
    await database.initialize();
    setState(() => futureProducts = database.getProducts(1));
  }
}
