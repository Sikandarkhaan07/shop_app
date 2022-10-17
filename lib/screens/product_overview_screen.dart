import 'package:flutter/material.dart';

import '../models/products.dart';
import '../widgets/product_grid.dart';

class ProductOverviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
      ),
      body: product_grid(),
    );
  }
}
