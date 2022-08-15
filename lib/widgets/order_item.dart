import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart';

class OrderItem extends StatefulWidget {
  final OrderDetail orderDetail;
  const OrderItem({Key? key, required this.orderDetail}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expandable = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderDetail.amount}'),
            subtitle: Text(DateFormat('E, dd/MM/yyyy - h:mm a')
                .format(widget.orderDetail.dateTime)),
            trailing: IconButton(
              icon: Icon(_expandable ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expandable = !_expandable;
                });
              },
            ),
          ),
          if (_expandable)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(
                  widget.orderDetail.orderedProducts.length * 20.0 + 10.0,
                  100.0),
              child: ListView(
                children: widget.orderDetail.orderedProducts
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${product.quantity} x \$${product.price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
