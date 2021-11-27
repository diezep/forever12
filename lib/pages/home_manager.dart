import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forever12/models/empleado.dart';
import 'package:forever12/models/order.dart';
import 'package:forever12/models/product.dart';
import 'package:forever12/models/store.dart';
import 'package:forever12/services/Database.dart';
import 'package:forever12/widgets/card_employee_manager.dart';
import 'package:forever12/widgets/card_product_manager.dart';
import 'package:forever12/widgets/card_store_manager.dart';
import 'package:forever12/widgets/dialog_create_employee.dart';
import 'package:forever12/widgets/dialog_create_product.dart';
import 'package:forever12/widgets/dialog_create_store.dart';

class HomeManagerScreen extends StatefulWidget {
  HomeManagerScreen({Key? key}) : super(key: key);

  @override
  State<HomeManagerScreen> createState() => _HomeManagerScreenState();
}

class _HomeManagerScreenState extends State<HomeManagerScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController controller;

  Database database = Database();

  Store? currentStore;
  Future<List<Product>> futureProducts = Future.value([]);
  Future<List<Employee>> futureEmployees = Future.value([]);
  Future<List<Store>> futureStores = Future.value([]);

  List<Product> products = [];

  initializeDB() async {
    database.databaseConnection?.close();
    await database.initialize();
    setState(() {
      futureStores = database.getStores();
      currentStore = null;
    });
  }

  onChangeStore(Store? store) {
    setState(() {
      currentStore = store;
      futureProducts = database.getProducts(store!.id!);
      futureEmployees = database.getEmployees(store.id!);
    });
  }

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      if (controller.index % 1 == 0) setState(() {});
    });
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
          backgroundColor: Colors.black,
          title: Text.rich(TextSpan(
              text: 'Forever12: ',
              style: textTheme.headline5
                  ?.apply(fontWeightDelta: 2, color: Colors.white),
              children: [
                TextSpan(
                    text: 'Administrador',
                    style: TextStyle(fontWeight: FontWeight.normal))
              ])),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () => initializeDB(), icon: Icon(Icons.refresh))
          ],
          bottom: TabBar(
              controller: controller,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('Productos')),
                Tab(child: Text('Cajeros')),
                Tab(child: Text('Tiendas')),
              ]),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: controller.index == 0
              ? () async {
                  List? res = await showDialog(
                      context: context,
                      builder: (_) => CreateProductDialog(
                            stores: futureStores,
                          ));
                  if (res != null) {
                    Product newProduct = res[0];
                    Store store = res[1];
                    await database.addProduct(newProduct, store);
                  }
                  // TDODO: IMPLEMENT
                }
              : controller.index == 1
                  ? () async {
                      Employee? newEmployee = await showDialog(
                          context: context,
                          builder: (_) =>
                              CreateEmployeeDialog(stores: futureStores));
                      if (newEmployee != null) {
                        await database.addEmployee(newEmployee);
                        setState(() {
                          futureEmployees =
                              database.getEmployees(currentStore!.id!);
                        });
                      }
                    }
                  : () async {
                      Store? newStore = await showDialog(
                          context: context,
                          builder: (_) => CreateStoreDialog());
                      if (newStore != null) {
                        await database.addStore(newStore);
                        setState(() {
                          futureStores = database.getStores();
                        });
                      }
                    },
          child: Text(controller.index == 0
              ? 'AGREGAR PRODUCTO'
              : controller.index == 1
                  ? 'AGREGAR CAJERO'
                  : 'AGREGAR TIENDA'),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(18), primary: Colors.black),
        ),
        body: LayoutBuilder(
            builder: (context, constraints) => TabBarView(
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 32, right: 32, top: 12),
                      width: constraints.maxWidth,
                      height: double.infinity,
                      child: Column(
                        children: [
                          FutureBuilder<List<Store>>(
                              future: futureStores,
                              builder: (context, snapshot) {
                                List<Store> _stores = snapshot.data ?? [];

                                return DropdownButtonFormField<Store>(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    value: currentStore ?? null,
                                    onChanged: onChangeStore,
                                    validator: (v) =>
                                        v == null ? 'Campo requerido.' : null,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                            gapPadding: 2)),
                                    items: _stores
                                        .map((e) => DropdownMenuItem<Store>(
                                              value: e,
                                              child: Text(
                                                  "${e.name ?? 'SIN NOMBRE'}: ${e.ubication! ? 'FISICA' : 'VIRTUAL'}"),
                                            ))
                                        .toList());
                              }),
                          SizedBox(height: 12),
                          Expanded(
                            child: FutureBuilder<List<Product>>(
                              future: futureProducts,
                              builder: (context, snapshot) {
                                List<Product> _products = snapshot.data ?? [];

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

                                return ListView.builder(
                                    itemCount: _products.length,
                                    itemBuilder: (_, i) => Container(
                                          height: 270,
                                          margin: EdgeInsets.only(bottom: 12),
                                          child: ProductCardManager(
                                              product: _products[i],
                                              onRemove: () async {
                                                bool res = await database
                                                    .removeProduct(
                                                        _products[i].id);
                                                if (res)
                                                  setState(() => _products
                                                      .remove(_products[i]));
                                              },
                                              onUpdate: () async {
                                                bool executed = await database
                                                    .updateProduct(
                                                        _products[i]);
                                                if (executed) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Producto actualizado.')));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Ha ocorrido un error al realizar tu orden. Intentalo de nuevo')));
                                                }
                                              }),
                                        ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 32, right: 32, top: 12),
                        width: double.infinity,
                        child: Column(
                          children: [
                            FutureBuilder<List<Store>>(
                                future: futureStores,
                                builder: (context, snapshot) {
                                  List<Store> _stores = snapshot.data ?? [];

                                  return DropdownButtonFormField<Store>(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      value: currentStore ?? null,
                                      onChanged: onChangeStore,
                                      validator: (v) =>
                                          v == null ? 'Campo requerido.' : null,
                                      decoration: InputDecoration(
                                          hintText: 'Selecciona la tienda',
                                          enabled: snapshot.hasData,
                                          prefixIcon:
                                              Icon(Icons.store_outlined),
                                          suffixIcon: snapshot.hasError
                                              ? Icon(Icons.error_outline)
                                              : null,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 12),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                              gapPadding: 2)),
                                      items: _stores
                                          .map((e) => DropdownMenuItem<Store>(
                                                value: e,
                                                child: Text(
                                                    "${e.name ?? 'SIN NOMBRE'}: ${e.ubication! ? 'FISICA' : 'VIRTUAL'}"),
                                              ))
                                          .toList());
                                }),
                            SizedBox(height: 12),
                            Expanded(
                              child: FutureBuilder<List<Employee>>(
                                future: futureEmployees,
                                builder: (context, snapshot) {
                                  List<Employee> _employees =
                                      snapshot.data ?? [];
                                  if (snapshot.hasError)
                                    return Center(child: Icon(Icons.error));
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return CircularProgressIndicator.adaptive();

                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      (snapshot.data?.isEmpty ?? true) &&
                                      currentStore != null)
                                    return Center(
                                      child: SizedBox(
                                        width: 300,
                                        child: Text(
                                          'No se ha encontrado empleados registrado en esta tienda.',
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  return GridView.count(
                                      crossAxisCount:
                                          constraints.maxWidth ~/ 250,
                                      childAspectRatio: .55,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      children: _employees
                                          .map((e) => EmployeeCardManager(
                                              employee: e,
                                              onRemove: (e) async {
                                                bool res = await database
                                                    .removeEmployee(e.id ?? -1);
                                                if (res)
                                                  setState(() =>
                                                      _employees.remove(e));
                                              },
                                              onUpdate: (e) async {
                                                bool executed = await database
                                                    .updateEmployee(e);
                                                if (!executed) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Ha ocorrido un error al realizar la actualización. Intentalo de nuevo')));
                                                }
                                              }))
                                          .toList());
                                },
                              ),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 32, right: 32, top: 12),
                        width: constraints.maxWidth,
                        height: double.infinity,
                        child: FutureBuilder<List<Store>>(
                          future: futureStores,
                          builder: (context, snapshot) {
                            List<Store> _stores = snapshot.data ?? [];

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

                            return Container(
                              child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: constraints.maxWidth ~/ 400,
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  children: _stores
                                      .map((e) => CardStoreManager(
                                            store: e,
                                            futureCountEmployees: database
                                                .getEmployeesCount(e.id!),
                                            futureCountProducts: database
                                                .getProductsCount(e.id!),
                                          ))
                                      .toList()),
                            );
                          },
                        )),
                  ],
                )));
  }
}
