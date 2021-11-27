import 'package:flutter/material.dart';
import 'package:forever12/models/empleado.dart';
import 'package:forever12/models/product.dart';

class EmployeeCardManager extends StatefulWidget {
  EmployeeCardManager(
      {Key? key,
      required this.employee,
      required this.onUpdate,
      required this.onRemove})
      : super(key: key);
  final Employee employee;
  Future<void> Function(Employee) onUpdate, onRemove;

  @override
  State<EmployeeCardManager> createState() => _EmployeeCardManagerState();
}

class _EmployeeCardManagerState extends State<EmployeeCardManager> {
  bool loading = false, completed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              enabled: !loading,
              initialValue: widget.employee.nombre,
              onChanged: (v) => setState(() => widget.employee.nombre = v),
              decoration: InputDecoration(
                  focusColor: Colors.black,
                  label: Text('Nombre'),
                  hintText: 'Nombre',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              enabled: !loading,
              initialValue: widget.employee.domicilio,
              onChanged: (v) => setState(() => widget.employee.domicilio = v),
              decoration: InputDecoration(
                  focusColor: Colors.black,
                  label: Text('Domicilio'),
                  hintText: 'Domicilio',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              enabled: !loading,
              initialValue: widget.employee.telefono,
              onChanged: (v) => setState(() => widget.employee.telefono = v),
              decoration: InputDecoration(
                  focusColor: Colors.black,
                  label: Text('Telefono'),
                  hintText: 'Telefono',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              enabled: !loading,
              initialValue: widget.employee.email,
              onChanged: (v) => setState(() => widget.employee.email = v),
              decoration: InputDecoration(
                  focusColor: Colors.black,
                  label: Text('Correo electronico'),
                  hintText: 'Correo electronico',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              enabled: !loading,
              initialValue: "${widget.employee.sueldo}",
              onChanged: (v) => setState(() => widget.employee.email = v),
              decoration: InputDecoration(
                  focusColor: Colors.black,
                  label: Text('Salario'),
                  hintText: 'Salario',
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: completed ? Colors.green : Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: loading
                    ? null
                    : () async {
                        setState(() => completed = false);
                        setState(() => loading = true);
                        try {
                          await widget.onUpdate(widget.employee);
                          setState(() => completed = true);
                          setState(() => loading = false);
                          await Future.delayed(Duration(seconds: 2));
                          setState(() => completed = false);
                        } finally {
                          setState(() => loading = false);
                        }
                      },
                child: completed ? Icon(Icons.done) : Text('Actualizar')),
          ),
          SizedBox(height: 6),
          Container(
            width: double.infinity,
            child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: loading
                    ? null
                    : () async {
                        setState(() => completed = false);
                        setState(() => loading = true);
                        try {
                          await widget.onRemove(widget.employee);
                          setState(() => completed = true);
                          setState(() => loading = false);
                          await Future.delayed(Duration(seconds: 2));
                          setState(() => completed = false);
                        } finally {
                          setState(() => loading = false);
                        }
                      },
                child: Text('Eliminar')),
          )
        ],
      ),
    );
  }
}
