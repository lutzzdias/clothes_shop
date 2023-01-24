import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/components/images_form.dart';
import 'package:loja_virtual/screens/edit_product/components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  final Product product;
  final bool editing;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EditProductScreen({Key? key, product})
      : product = product?.clone() ?? Product.empty(),
        editing = product != null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(editing ? 'Editar produto' : 'Criar produto'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ImagesForm(product: product),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: product.name,
                    decoration: const InputDecoration(
                      hintText: 'Título',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (name) {
                      if (name == null || name.length < 6)
                        return 'Título muito curto';
                      else
                        return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: 8,
                    ),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: product.description,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Descrição',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    validator: (desc) {
                      if (desc == null || desc.length < 10)
                        return 'Descrição muito curta';
                      else
                        return null;
                    },
                  ),
                  SizesForm(product: product),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        disabledBackgroundColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                      ),
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) print('válido');
                      },
                      child: const Text(
                        'Salvar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
