import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forever12/models/client.dart';
import 'package:postgresql2/constants.dart';

class UpdateProfileDialog extends StatefulWidget {
  UpdateProfileDialog({
    Key? key,
    required this.client,
    required this.onUpdate,
    required this.onGetClient,
  }) : super(key: key);

  Client client;
  final Function onUpdate;
  Future<Client?> Function(String) onGetClient;

  @override
  State<UpdateProfileDialog> createState() => _UpdateProfileDialogState();
}

class _UpdateProfileDialogState extends State<UpdateProfileDialog> {
  bool updating = false, completed = false, notFound = false;
  String tmpEmail = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SimpleDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        title: Text("Perfil"),
        children: [
          if (widget.client.id != null) ...[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                initialValue: "${widget.client.name}",
                onSaved: (v) => widget.client.name = v,
                decoration: InputDecoration(
                    enabled: !updating,
                    focusColor: Colors.black,
                    label: const Text('Nombre'),
                    hintText: 'Nombre',
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                initialValue: "${widget.client.email}",
                onSaved: (v) => widget.client.email = v,
                decoration: InputDecoration(
                    enabled: !updating,
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
                      initialValue: "${widget.client.domicilio}",
                      onSaved: (v) => widget.client.domicilio = v,
                      decoration: InputDecoration(
                          enabled: !updating,
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
                      initialValue: widget.client.phoneNumber,
                      onSaved: (v) => widget.client.phoneNumber = v,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          enabled: !updating,
                          focusColor: Colors.black,
                          label: Text('Teléfono'),
                          hintText: 'Teléfono',
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ButtonBar(
              children: [
                TextButton(
                  child: Text('Descartar'),
                  style: TextButton.styleFrom(primary: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: completed ? Colors.green : Colors.black,
                      padding: EdgeInsets.all(18)),
                  child: updating
                      ? const CircularProgressIndicator.adaptive()
                      : completed
                          ? const Icon(Icons.done)
                          : const Text('Actualizar'),
                  onPressed: updating
                      ? null
                      : () async {
                          setState(() => updating = true);
                          formKey.currentState!.save();
                          await widget.onUpdate();
                          setState(() => updating = false);
                          setState(() => completed = true);
                          await Future.delayed(const Duration(seconds: 2));
                          Navigator.pop(context);
                        },
                )
              ],
            )
          ] else ...[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                initialValue: tmpEmail,
                onChanged: (v) {
                  tmpEmail = v;
                  setState(() => notFound = false);
                },
                onSaved: (v) => widget.client.email = v,
                decoration: InputDecoration(
                    enabled: !updating,
                    focusColor: Colors.black,
                    label: const Text('Correo electrónico'),
                    hintText: 'Correo electrónico',
                    border: InputBorder.none),
              ),
            ),
            if (notFound) ...[
              const SizedBox(height: 6),
              const SizedBox(
                  width: 100,
                  child: Text("No se ha encontrado un cliente con ese correo"))
            ],
            const SizedBox(height: 16),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text('Descartar'),
                  style: TextButton.styleFrom(primary: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: completed ? Colors.green : Colors.black,
                      padding: const EdgeInsets.all(18)),
                  child: updating
                      ? const CircularProgressIndicator.adaptive()
                      : completed
                          ? const Icon(Icons.done)
                          : const Text('Obtener'),
                  onPressed: updating
                      ? null
                      : () async {
                          setState(() => completed = false);
                          setState(() => updating = true);
                          setState(() => notFound = false);
                          Client? client = await widget.onGetClient(tmpEmail);
                          setState(() => updating = false);
                          if (client != null) {
                            setState(() => completed = true);
                            setState(() => widget.client = client);
                            await Future.delayed(const Duration(seconds: 3));
                            Navigator.pop(context);
                          } else {
                            setState(() => notFound = true);
                          }
                        },
                )
              ],
            )
          ]
        ],
      ),
    );
  }
}
