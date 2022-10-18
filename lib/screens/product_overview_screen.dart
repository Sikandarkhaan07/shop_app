import 'package:flutter/material.dart';
import '../widgets/product_grid.dart';

enum filterOptions {
  favorite,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (filterOptions selectedValue) {
              setState(() {
                if (selectedValue == filterOptions.favorite) {
                  _showOnlyFavorite = true;
                } else {
                  _showOnlyFavorite = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: filterOptions.favorite,
                child: Text('only Favorite'),
              ),
              const PopupMenuItem(
                value: filterOptions.all,
                child: Text('Show All'),
              ),
            ],
          ),
        ],
      ),
      body: product_grid(_showOnlyFavorite),
    );
  }
}
