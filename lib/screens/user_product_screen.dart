import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_product_screen';
  Future<void> _refreshProduct(BuildContext context) async{
    await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts();
  }
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your product'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (ctx, index) => Column(children: [
              UserProductItem(
                  id: productsProvider.items[index].id,
                  title: productsProvider.items[index].title,
                  imgUrl: productsProvider.items[index].imageUrl),
              Divider(),
            ]),
            itemCount: productsProvider.items.length,
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
