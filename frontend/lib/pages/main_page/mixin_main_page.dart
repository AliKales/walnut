import 'package:flutter/material.dart';

import 'main_page_view.dart';

mixin MixinMainPage on State<MainPageView> {
  final key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void closeDrawer() => key.currentState!.closeDrawer();
}
