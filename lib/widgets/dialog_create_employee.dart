import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forever12/models/empleado.dart';
import 'package:forever12/models/order.dart';
import 'package:forever12/models/product.dart';
import 'package:forever12/models/store.dart';

class CreateEmployeeDialog extends StatefulWidget {
  CreateEmployeeDialog({Key? key, required this.stores}) : super(key: key);

  Future<List<Store>> stores;

  @override
  State<CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends State<CreateEmployeeDialog> {
  var formKey = GlobalKey<FormState>();

  Employee tmpEmployee = Employee();

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
                Text('Agregar cajero',
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
                                tmpEmployee.tienda = store.id;
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
                    onChanged: (v) => tmpEmployee.nombre = v,
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
                    onChanged: (v) => tmpEmployee.domicilio = v,
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        label: Text('Domicilio'),
                        hintText: 'Domicilio',
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
                    onChanged: (v) => tmpEmployee.email = v,
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        label: Text('Correo electrónico'),
                        hintText: 'Correo electrónico',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Campo requerido.' : null,
                          onChanged: (v) => tmpEmployee.telefono = v,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              focusColor: Colors.black,
                              label: Text('Telefono'),
                              hintText: 'Telefono',
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
                          onChanged: (v) =>
                              tmpEmployee.sueldo = double.parse(v),
                          decoration: InputDecoration(
                              focusColor: Colors.black,
                              label: Text('Sueldo'),
                              hintText: 'Sueldo',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          Navigator.pop(context, [tmpEmployee, tmpStore]);
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
