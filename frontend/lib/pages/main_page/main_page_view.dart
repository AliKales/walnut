import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/sp.dart';
import 'package:frontend/models/m_product.dart';
import 'package:frontend/router.dart';
import 'package:frontend/services/service_auth.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:go_router/go_router.dart';

import '../../locale_keys.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/product_widget.dart';
import 'mixin_main_page.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> with MixinMainPage {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: _appBar(),
      drawer: _Drawer(
        onBecomeSeller: onBecomeSeller,
        onProductsChange: onProductsChange,
      ),
      body: _body(),
    );
  }

  Widget _body() {
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
      centerTitle: true,
      title: const Text(LocaleKeys.appName),
    );
  }

  @override
  Future<bool> showCustomDialog(String title, String text) async {
    return await CustomDialog.showCustomDialog<bool>(
          context,
          title: title,
          text: text,
          actions: [
            Buttons("NO", () => context.pop(false)).textB(),
            Buttons("YES", () => context.pop(true)).textB(),
          ],
        ) ??
        false;
  }

  @override
  void showSnackbar(String text, bool isSuccess) {
    CustomSnackbar.showSuccessSnackBar(context,
        text: text, isSuccess: isSuccess);
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({required this.onBecomeSeller, required this.onProductsChange});

  final VoidCallback onBecomeSeller;
  final ValueChanged<List<MProduct>> onProductsChange;

  void _logout(BuildContext context) {
    SP.delete("jwt");
    context.go(PagePaths.login);
  }

  Future<void> _goMyProducts(BuildContext context) async {
    final result = await context.push<List<MProduct>?>(PagePaths.seller);

    if (result.isNotEmptyAndNull) onProductsChange.call(result!);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: kToolbarHeight * 0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarWidget(
              size: 0.23.toDynamicWidth(context),
              url:
                  "https://images.pexels.com/photos/634021/pexels-photo-634021.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
            ),
            Text(
              ServiceAuth.me?.username ?? "",
              style: context.textTheme.titleLarge!.toBold,
            ),
            const Divider(),
            _storeTile(context),
            const Spacer(),
            const Divider(),
            ListTile(
              title: const Text(LocaleKeys.logout),
              leading: const Icon(Icons.logout),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storeTile(BuildContext context) {
    if (!ServiceAuth.isSeller) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Buttons(LocaleKeys.becomeSeller, onBecomeSeller).filled(),
      );
    }
    return ListTile(
      title: const Text(LocaleKeys.myProducts),
      leading: const Icon(Icons.storefront_outlined),
      onTap: () => _goMyProducts(context),
    );
  }
}
