import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/products/components/product_list_tile.dart';
import 'package:loja_virtual/screens/products/components/search_dialog.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager, __) => productManager.search.isEmpty
              ? const Text('Produtos')
              : LayoutBuilder(
                  builder: (_, constraints) => GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                        context: context,
                        builder: (_) => SearchDialog(
                          initialText: productManager.search,
                        ),
                      );
                      if (search != null) productManager.search = search;
                    },
                    child: SizedBox(
                      width: constraints.biggest.width,
                      child: Text(
                        productManager.search,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
        ),
        centerTitle: true,
        actions: [
          Consumer<ProductManager>(
            builder: (_, productManager, __) => productManager.search.isEmpty
                ? IconButton(
                    onPressed: () async {
                      final search = await showDialog<String>(
                        context: context,
                        builder: (_) => SearchDialog(
                          initialText: productManager.search,
                        ),
                      );
                      if (search != null) productManager.search = search;
                    },
                    icon: const Icon(Icons.search),
                  )
                : IconButton(
                    onPressed: () {
                      productManager.search = '';
                    },
                    icon: const Icon(Icons.close),
                  ),
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __) => userManager.isAdmin
                ? IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      '/edit_product',
                    ),
                    icon: const Icon(
                      Icons.add,
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Consumer<ProductManager>(builder: (_, productManager, __) {
        final filteredProducts = productManager.filteredProducts;
        return ListView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (_, index) {
            return ProductListTile(
              product: filteredProducts[index],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).pushNamed('/cart'),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
