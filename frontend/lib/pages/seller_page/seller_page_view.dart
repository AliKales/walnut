import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:frontend/locale_keys.dart';
import 'package:frontend/pages/seller_page/seller_page_mixin.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/product_widget.dart';

part 'widgets/fab.dart';

class SellerPageView extends StatefulWidget {
  const SellerPageView({super.key});

  @override
  State<SellerPageView> createState() => _SellerPageViewState();
}

class _SellerPageViewState extends State<SellerPageView> with SellerPageMixin {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.pop(productsChanged);
      },
      child: Scaffold(
        floatingActionButton: _FAB.extended(onAdd),
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    if (isError) return Buttons(LocaleKeys.tryAgain, () {}).filled().center;
    if (products == null) {
      return const CircularProgressIndicator.adaptive().center;
    }

    return Padding(
      padding: Values.paddingPage(context),
      child: ListView.separated(
        itemCount: products!.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          //here we set padding for bottom of last widget
          //because there is a Floating Action Button
          double padding = index == products!.count ? 50 : 0;
          return Padding(
            padding: EdgeInsets.only(bottom: padding),
            child: ProductWidget(
              product: products![index],
              onTap: () => onProductTap(index),
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.yourProducts),
    );
  }
}
