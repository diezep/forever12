import 'package:flutter/material.dart';
import 'package:forever12/models/product.dart';

class ProductCardManager extends StatefulWidget {
  const ProductCardManager(
      {Key? key, required this.product, this.onUpdate, this.onRemove})
      : super(key: key);
  final Product product;
  final Function()? onUpdate, onRemove;

  @override
  State<ProductCardManager> createState() => _ProductCardManagerState();
}

class _ProductCardManagerState extends State<ProductCardManager> {
  var departamentos = {
    "Dama": 1,
    "Caballero": 2,
    "Accesorios": 3,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget.product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Flexible(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    initialValue: widget.product.name,
                    onChanged: (v) => setState(() => widget.product.name = v),
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
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    initialValue: widget.product.image,
                    onChanged: (v) => setState(() => widget.product.image = v),
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        label: Text('Imagen'),
                        hintText: 'Imagen',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    initialValue: widget.product.description,
                    onChanged: (v) =>
                        setState(() => widget.product.description = v),
                    maxLines: 2,
                    decoration: InputDecoration(
                        focusColor: Colors.black,
                        label: Text('Descripción'),
                        hintText: 'Descripción',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<int>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    value: departamentos[widget.product.departamentoNombre],
                    validator: (v) => v == null ? 'Campo requerido.' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                            gapPadding: 2)),
                    onChanged: (v) =>
                        setState(() => widget.product.departamento = v!),
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
              ],
            ),
          ),
          SizedBox(width: 16),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => setState(() => widget.product.stock++),
                  icon: Icon(Icons.add, size: 14),
                ),
                Text("${widget.product.stock}"),
                IconButton(
                  onPressed: () => setState(() {
                    widget.product.stock--;
                  }),
                  icon: Icon(Icons.remove, size: 14),
                ),
                SizedBox(width: 16),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      initialValue: "${widget.product.price}",
                      onChanged: (v) => setState(() =>
                          widget.product.price = double?.tryParse(v) ?? 0),
                      decoration: InputDecoration(
                          focusColor: Colors.black,
                          label: Text('Precio'),
                          hintText: 'Precio',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Center(
                  child: ElevatedButton(
                    onPressed: widget.onUpdate,
                    child: Icon(Icons.update),
                    style: ElevatedButton.styleFrom(
                        elevation: 0, primary: Colors.black),
                  ),
                ),
                SizedBox(height: 4),
                Center(
                  child: ElevatedButton(
                    onPressed: widget.onRemove,
                    child: Icon(Icons.remove),
                    style: ElevatedButton.styleFrom(
                        elevation: 0, primary: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
