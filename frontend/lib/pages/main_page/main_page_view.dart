import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';

import '../../locale_keys.dart';
import '../../widgets/avatar_widget.dart';
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
      drawer: const _Drawer(),
      body: Padding(
        padding: Values.paddingPage(context),
        child: const SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(LocaleKeys.appName),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer();

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
              "Ali Kaleş",
              style: context.textTheme.titleLarge!.toBold,
            ),
            const Divider(),
            const ListTile(
              title: Text(LocaleKeys.myStore),
              leading: Icon(Icons.storefront_outlined),
            ),
            const Spacer(),
            const Divider(),
            const ListTile(
              title: Text(LocaleKeys.logout),
              leading: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
