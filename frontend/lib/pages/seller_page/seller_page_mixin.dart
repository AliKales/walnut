// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:frontend/locale_keys.dart';
import 'package:frontend/models/m_product.dart';
import 'package:frontend/pages/seller_page/seller_page_view.dart';
import 'package:frontend/router.dart';
import 'package:frontend/services/service_product.dart';
import 'package:go_router/go_router.dart';

mixin SellerPageMixin on State<SellerPageView> {
  List<MProduct>? products;
  List<MProduct> productsChanged = [];
  bool isError = false;

  @override
  void initState() {
    super.initState();
    context.afterBuild((p0) => _fetchMyProducts());
  }

  Future<void> _fetchMyProducts() async {
    //here we send 0 as id of product
    //but it will return user's all products
    final r = await ServiceProduct.fetchProducts(0);

    if (r.$1 != HttpStatus.ok) {
      setState(() {
        isError = true;
      });
      return;
    }

    setState(() {
      products = r.$2 ?? [];
    });
  }

  Future<void> onAdd() async {
    final p = await context.push<MProduct?>(PagePaths.product);

    if (p == null) return;

    setState(() {
      products!.insert(0, p);
    });
    productsChanged.add(p);
  }

  Future<void> onProductTap(int i) async {
    //p will be either MProduct or int
    //int means that product has been deleted
    final p = await context.push(PagePaths.product, extra: products![i]);

    if (p == null) return;

    if (p is MProduct) {
      setState(() {
        products![i] = p;
      });
      productsChanged.add(p);
    }

    if (p is int) {
      setState(() {
        products!.removeWhere((element) => element.id == p);
      });
    }
  }

  Future<void> downloadCSV() async {
    CustomProgressIndicator.showProgressIndicator(context);
    await ServiceProduct.downloadCSV();
    context.pop();

    CustomSnackbar.showSnackBar(context: context, text: LocaleKeys.downloaded);
  }
}
