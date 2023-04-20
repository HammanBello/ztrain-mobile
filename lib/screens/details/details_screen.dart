import 'package:flutter/material.dart';
import 'package:shop_app/models/app_page.dart';

import '../../models/Product.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static MaterialPage page(Product product, int quantity) {
    return MaterialPage(
        name: AppPage.detailsScreen,
        key: ValueKey(AppPage.detailsScreen),
        child: DetailsScreen(
          product: product,
          quantity: quantity,
        ));
  }

  final Product product;
  final int quantity;

  DetailsScreen({this.product, this.quantity});

  @override
  Widget build(BuildContext context) {
    // final ProductDetailsArguments agrs =
    //     ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(rating: product.rating),
      body: Body(
        product: product,
        quantity: quantity,
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;
  final int quantity;

  ProductDetailsArguments({@required this.product, this.quantity});
}
