// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:frontend/locale_keys.dart';
import 'package:frontend/models/m_product.dart';
import 'package:frontend/router.dart';
import 'package:frontend/services/service_auth.dart';
import 'package:frontend/services/service_product.dart';
import 'package:go_router/go_router.dart';

import 'main_page_view.dart';

mixin MixinMainPage on State<MainPageView> {
  final key = GlobalKey<ScaffoldState>();

  List<MProduct>? products;

  @override
  void initState() {
    super.initState();
    context.afterBuild((p0) => _fetchProducts());
  }

  Future<void> _fetchProducts() async {
    final r = await ServiceProduct.fetchProducts();

    if (r.$1 != HttpStatus.ok) {
      return showSnackbar(LocaleKeys.unexpectedError, false);
    }

    setState(() {
      products = r.$2 ?? [];
    });
  }

  void closeDrawer() => key.currentState!.closeDrawer();

  Future<void> onBecomeSeller() async {
    closeDrawer();

    final r = await showCustomDialog(
        LocaleKeys.becomeSeller, LocaleKeys.wantBecomeSeller);

    if (!r) return;

    CustomProgressIndicator.showProgressIndicator(context);

    final sellerResult = await ServiceAuth.becomeSeller();

    context.pop();

    if (sellerResult.$1 != HttpStatus.ok) {
      showSnackbar(sellerResult.$2, false);
      return;
    }

    setState(() {});

    showSnackbar(LocaleKeys.youBecameSeller, true);
  }

  Future<void> onProductTap(int i) async {
    final p =
        await context.push<MProduct?>(PagePaths.product, extra: products![i]);

    if (p == null) return;

    setState(() {
      products![i] = p;
    });
  }

  ///[onProductsChange] will update [products] with new products
  ///if product doesn't exist then it will add
  void onProductsChange(List<MProduct> val) {
    for (var p in val) {
      int i = products!.indexWhere((e) => e.id == p.id);

      if (i != -1) {
        products![i] = p;
      } else {
        products!.add(p);
      }
    }

    setState(() {});
  }

  Future<bool> showCustomDialog(String title, String text);

  void showSnackbar(String text, bool isSuccess);
}
