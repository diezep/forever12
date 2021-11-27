import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forever12/models/client.dart';
import 'package:forever12/models/order.dart';

class OrderInfoDialog extends StatefulWidget {
  OrderInfoDialog(
      {Key? key, required this.order, this.client, required this.onOrder})
      : super(key: key);

  Future<void> Function() onOrder;
  Order order;
  Client? client;

  @override
  State<OrderInfoDialog> createState() => _OrderInfoDialogState();
}

class _OrderInfoDialogState extends State<OrderInfoDialog> {
  var formKey = GlobalKey<FormState>();

  bool cargando = false, completado = false;

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
                Text('Estás a un paso!',
                    style: textTheme.headline4?.apply(
                      fontWeightDelta: 2,
                      color: Colors.black,
                    )),
                SizedBox(height: 8),
                Text(
                  widget.client?.id != null
                      ? "Confirma tu orden y los productos seleccionados."
                      : 'Completa los siguientes campos para realizar el seguimiento de tu orden.',
                  textAlign: TextAlign.center,
                ),
                if (widget.client?.id == null)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          onChanged: (v) => widget.client?.name = v,
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
                          onChanged: (v) => widget.client?.email = v,
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
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: TextFormField(
                                onChanged: (v) => widget.client?.domicilio = v,
                                decoration: InputDecoration(
                                    focusColor: Colors.black,
                                    label: Text('Domicilio'),
                                    hintText: 'Domicilio',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Flexible(
                            flex: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: TextFormField(
                                onChanged: (v) =>
                                    widget.client?.phoneNumber = v,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    focusColor: Colors.black,
                                    label: Text('Teléfono'),
                                    hintText: 'Teléfono',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Tus productos',
                      style: textTheme.subtitle1?.apply(fontWeightDelta: 2)),
                ),
                SizedBox(height: 8),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.order.products
                                  ?.map((e) => ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Image.network(e.image,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        title: Text(e.name),
                                        subtitle: Text(e.description),
                                        trailing: Text("x ${e.quantity}"),
                                      ))
                                  .toList() ??
                              []),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('SUBTOTAL',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    "\$ ${widget.order.subtotal.toStringAsFixed(2)} MXN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('I.V.A.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    "\$ ${widget.order.iva.toStringAsFixed(2)} MXN"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('TOTAL',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    "\$ ${widget.order.total.toStringAsFixed(2)} MXN"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() => cargando = true);
                              await widget.onOrder();
                              setState(() {
                                cargando = false;
                                completado = true;
                              });
                              await Future.delayed(Duration(seconds: 3));
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                primary:
                                    completado ? Colors.green : Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 22)),
                            child: cargando
                                ? CircularProgressIndicator.adaptive()
                                : completado
                                    ? Icon(Icons.done)
                                    : Text('PAGAR')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
