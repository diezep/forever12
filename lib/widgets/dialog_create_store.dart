import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forever12/models/store.dart';

class CreateStoreDialog extends StatefulWidget {
  CreateStoreDialog({Key? key}) : super(key: key);

  @override
  State<CreateStoreDialog> createState() => _CreateStoreDialogState();
}

class _CreateStoreDialogState extends State<CreateStoreDialog> {
  var formKey = GlobalKey<FormState>();

  Store tmpStore = Store();

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
                Text('Agregar tienda',
                    style: textTheme.headline5?.apply(fontWeightDelta: 2)),
                SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) =>
                        v?.isEmpty ?? true ? 'Campo requerido.' : null,
                    onChanged: (v) => tmpStore.name = v,
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        label: Text('Nombre'),
                        hintText: 'Nombre',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 12),
                CheckboxListTile(
                    value: tmpStore.ubication ?? true,
                    title: Text('Ubicación física'),
                    onChanged: (v) => setState(() => tmpStore.ubication = v)),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          Navigator.pop(context, tmpStore);
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
