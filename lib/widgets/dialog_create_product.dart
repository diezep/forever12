import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forever12/models/order.dart';
import 'package:forever12/models/product.dart';
import 'package:forever12/models/store.dart';

class CreateProductDialog extends StatefulWidget {
  CreateProductDialog({Key? key, required this.stores}) : super(key: key);

  Future<List<Store>> stores;

  @override
  State<CreateProductDialog> createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  var formKey = GlobalKey<FormState>();

  Product tmpProduct = Product();

  Store? tmpStore;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Agregar producto',
                    style: textTheme.headline5?.apply(fontWeightDelta: 2)),
                SizedBox(height: 24),
                FutureBuilder<List<Store>>(
                    future: widget.stores,
                    builder: (context, snapshot) {
                      List<Store> _stores = snapshot.data ?? [];
                      return DropdownButtonFormField<Store>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          value: tmpStore ?? null,
                          onChanged: (store) => setState(() {
                                tmpStore = store!;
                              }),
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
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        v?.isEmpty ?? true ? 'Campo requerido.' : null,
                    onChanged: (v) => tmpProduct.name = v,
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        label: Text('Nombre'),
                        hintText: 'Nombre',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        v?.isEmpty ?? true ? 'Campo requerido.' : null,
                    onChanged: (v) => tmpProduct.description = v,
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        label: Text('Descripción'),
                        hintText: 'Descripción',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        v?.isEmpty ?? true ? 'Campo requerido.' : null,
                    onChanged: (v) => tmpProduct.image = v,
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        label: Text('URL Imagen'),
                        hintText: 'URL Imagen',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Campo requerido.' : null,
                          onChanged: (v) => tmpProduct.stock = int.parse(v),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              focusColor: Colors.black,
                              label: Text('Stock'),
                              hintText: 'Stock',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Campo requerido.' : null,
                          onChanged: (v) => tmpProduct.price = double.parse(v),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              focusColor: Colors.black,
                              label: Text('Precio'),
                              hintText: 'Precio',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<int>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => v == null ? 'Campo requerido.' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 2)),
                    onChanged: (v) => tmpProduct.departamento = v!,
                    items: [
                      DropdownMenuItem<int>(
                        value: 3,
                        child: Text('Accesorios'),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Text('Caballeros'),
                      ),
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Damas'),
                      ),
                    ]),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          Navigator.pop(context, [tmpProduct, tmpStore]);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 22)),
                      child: Text('AGREGAR')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
