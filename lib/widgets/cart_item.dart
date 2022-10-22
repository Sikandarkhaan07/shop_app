import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.title,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final cartProduct = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 20,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        cartProduct.removeItem(productId);
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: FittedBox(
                child: Text(
                  '\$${price.toStringAsFixed(2)}',
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ${(price * quantity).toStringAsFixed(2)}'),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 15,
                    child: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        cartProduct.addRemoveItem(productId, '-');
                      },
                        padding: const EdgeInsets.all(0),
                    ),
                  ),
                  Text(
                    '${quantity}x',
                    style: const TextStyle(fontSize: 18),
                  ),
                  CircleAvatar(
                    radius: 15,
                    child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cartProduct.addRemoveItem(productId, '+');
                        },
                        padding: const EdgeInsets.all(0)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
