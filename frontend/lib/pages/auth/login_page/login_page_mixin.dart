// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:caroby/caroby.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/router.dart';
import 'package:frontend/services/service_auth.dart';
import 'package:go_router/go_router.dart';

import '../../../locale_keys.dart';
import 'login_page_view.dart';

mixin LoginPageMixin on State<LoginPageView> {
  final formKey = GlobalKey<FormState>();
  final tECUsername = TextEditingController();
  final tECPassword = TextEditingController();

  @override
  void dispose() {
    tECUsername.dispose();
    tECPassword.dispose();
    super.dispose();
  }

  void showError(String text);

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    CustomProgressIndicator.showProgressIndicatorMessage(context,
        text: LocaleKeys.loggingIn);

    final r = await ServiceAuth.login(tECUsername.text, tECPassword.text);

    context.pop();

    if (r.$1 != HttpStatus.ok) return showError(r.$2);

    context.go(PagePaths.main);
  }

  void signup() => context.go(PagePaths.signup);
}
