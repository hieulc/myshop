import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_provider.dart';

class ProductsGridview extends StatelessWidget {
  final bool showOnlyFavorite;


  ProductsGridview(this.showOnlyFavorite);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = showOnlyFavorite ? productsProvider.favoriteItems : productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
          // id: products[index].id,
          // title: products[index].title,
          // imageUrl: products[index].imageUrl,
        ),
      ),
      itemCount: products.length,
    );
  }
}
