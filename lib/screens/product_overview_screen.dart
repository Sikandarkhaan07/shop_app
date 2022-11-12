import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';

enum filterOptions {
  favorite,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorite = false;
  var _isLoading = false;
  //another approach for the below initstate method
  var _isInit = true;
  @override
  void didChangeDependencies() {
    if(_isInit){
      setState((){
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context,listen: false).fetchAndSetProducts().then((_){
        setState((){
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<ProductsProvider>(context).fetchAndSetProducts();
  //   });
  //   super.initState();
  // }

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
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              value: cartData.itemCount.toString(),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(
                  Icons.shopping_cart,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : product_grid(_showOnlyFavorite),
    );
  }
}
