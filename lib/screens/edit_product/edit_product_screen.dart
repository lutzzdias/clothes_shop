import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screens/edit_product/components/images_form.dart';
import 'package:loja_virtual/screens/edit_product/components/sizes_form.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(editing ? 'Editar produto' : 'Criar produto'),
          centerTitle: true,
          actions: [
            if (editing)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<ProductManager>().delete(product);
                  Navigator.of(context).pop();
                },
              )
          ],
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
                      onSaved: (name) => product.name = name!,
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
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
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
                      onSaved: (description) =>
                          product.description = description!,
                    ),
                    SizesForm(product: product),
                    const SizedBox(height: 20),
                    Consumer<Product>(
                      builder: (_, product, __) => SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            disabledBackgroundColor:
                                Theme.of(context).primaryColor.withAlpha(100),
                          ),
                          onPressed: product.loading
                              ? null
                              : () {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate())
                                    _formKey.currentState!.save();
                                  product.save().then((_) {
                                    context
                                        .read<ProductManager>()
                                        .update(product);
                                    Navigator.of(context).pop();
                                  });
                                },
                          child: product.loading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Salvar',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
