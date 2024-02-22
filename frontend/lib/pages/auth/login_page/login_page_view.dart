import 'package:caroby/caroby.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/locale_keys.dart';
import 'package:frontend/widgets/buttons.dart';

import '../../../widgets/c_text_field.dart';
import 'login_page_mixin.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> with LoginPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: Values.paddingPage(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              LocaleKeys.welcomeBack,
              style: context.textTheme.displaySmall!.toBold,
            ),
            _textFields(),
            _buttons(),
            //we add sized box with AppBar height to center our widgets
            const SizedBox(height: kBottomNavigationBarHeight * 2),
          ],
        ),
      ),
    );
  }

  Column _buttons() {
    return Column(
      children: [
        Buttons(LocaleKeys.login, login).filled(),
        const SizedBox(height: 25),
        _SignUpButton(onTap: signup),
      ],
    );
  }

  Widget _textFields() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CTextField(
            controller: tECUsername,
            label: LocaleKeys.username,
            prefixIcon: const Icon(Icons.person),
            filled: true,
            validator: (p0) {
              if (p0.isEmptyOrNull) return LocaleKeys.cantBeEmpty;
              return null;
            },
          ),
          CTextField(
            controller: tECPassword,
            label: LocaleKeys.password,
            prefixIcon: const Icon(Icons.key),
            obscureText: true,
            filled: true,
            validator: (p0) {
              if (p0.isEmptyOrNull) return LocaleKeys.cantBeEmpty;
              if (p0!.length < 6) return LocaleKeys.passwordMin;
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  void showError(String text) {
    CustomSnackbar.showSuccessSnackBar(context, text: text, isSuccess: false);
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        recognizer: TapGestureRecognizer()..onTap = onTap,
        text: LocaleKeys.dontHaveAccount,
        style: context.textTheme.titleMedium!.toBold,
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onTap,
            text: " ${LocaleKeys.signup}",
            style: context.textTheme.titleMedium!.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
