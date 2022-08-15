import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//PROVIDER
import '../providers/cart.dart';
import '../providers/orders.dart';
//WIDGET
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) {
                return CartItemWidget(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                );
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(15),
            elevation: 6,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  if (cart.items.length != 0)
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    )
                  else
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount}',
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(side: BorderSide()),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (cart.items.length == 0)
            OutlinedButton(
              onPressed: () {},
              child: Text('ORDER NOW'),
              style: OutlinedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            )
          else
            OrderButton(cart: cart),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading) ? null : () async {
        setState((){
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false)
            .addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
        setState((){
          _isLoading = false;
        });
        widget.cart.clearCart();
      },
      child: _isLoading ? Center(child: CircularProgressIndicator(),): Text('ORDER NOW'),
      style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor),
    );
  }
}
