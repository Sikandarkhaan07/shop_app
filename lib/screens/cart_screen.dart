import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(10),
                    elevation: 10,
                    labelStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    textColor: Theme.of(context).primaryColor,
                    child: const Text('ORDER NOW'),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItem.length,
              itemBuilder: (ctx, i) => ci.CartItem(
                productId: cart.cartItem.keys.toList()[i],
                id: cart.cartItem.values.toList()[i].id,
                title: cart.cartItem.values.toList()[i].title,
                quantity: cart.cartItem.values.toList()[i].quantity,
                price: cart.cartItem.values.toList()[i].price,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
