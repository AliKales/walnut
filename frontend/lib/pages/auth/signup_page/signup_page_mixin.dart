// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:frontend/locale_keys.dart';
import 'package:frontend/pages/auth/signup_page/signup_page_view.dart';
import 'package:frontend/router.dart';
import 'package:frontend/services/service_auth.dart';
import 'package:go_router/go_router.dart';

mixin SignupPageMixin on State<SignupPageView> {
  final formKey = GlobalKey<FormState>();

  final tECUsername = TextEditingController();
  final tECEmail = TextEditingController();
  final tECPassword = TextEditingController();
  final tECPassword2 = TextEditingController();

  RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );

  @override
  void dispose() {
    tECUsername.dispose();
    tECEmail.dispose();
    tECPassword.dispose();
    tECPassword2.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;

    CustomProgressIndicator.showProgressIndicatorMessage(context,
        text: LocaleKeys.signingUp);

    final r = await ServiceAuth.signup(
        tECEmail.text, tECUsername.text, tECPassword.text);

    context.pop();

    if (r.$1 != HttpStatus.ok) return showError(r.$2);

    context.go(PagePaths.main);
  }

  void alreadyHaveAccount() => context.go(PagePaths.login);

  void showError(String text);
}
