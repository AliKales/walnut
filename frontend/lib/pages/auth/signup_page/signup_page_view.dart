import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/signup_page/signup_page_mixin.dart';
import 'package:frontend/widgets/buttons.dart';

import '../../../locale_keys.dart';
import '../../../widgets/c_text_field.dart';

class SignupPageView extends StatefulWidget {
  const SignupPageView({super.key});

  @override
  State<SignupPageView> createState() => _SignupPageViewState();
}

class _SignupPageViewState extends State<SignupPageView> with SignupPageMixin {
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
              LocaleKeys.createAccount,
              style: context.textTheme.displaySmall!.toBold,
            ),
            _textFields(),
            Buttons(LocaleKeys.signup, signup).filled(),
            Buttons(
              LocaleKeys.alreadyHaveAnAccount,
              alreadyHaveAccount,
            ).textB(),
            const SizedBox(height: kBottomNavigationBarHeight * 2),
          ],
        ),
      ),
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
            controller: tECEmail,
            label: LocaleKeys.email,
            prefixIcon: const Icon(Icons.person),
            filled: true,
            validator: (p0) {
              if (p0.isEmptyOrNull) return LocaleKeys.cantBeEmpty;

              if (!emailRegex.hasMatch(p0!)) return LocaleKeys.mustBeEmail;

              return null;
            },
          ),
          CTextField(
            obscureText: true,
            controller: tECPassword,
            label: LocaleKeys.password,
            prefixIcon: const Icon(Icons.person),
            filled: true,
            validator: (p0) {
              if (p0.isEmptyOrNull) return LocaleKeys.cantBeEmpty;
              return null;
            },
          ),
          CTextField(
            obscureText: true,
            controller: tECPassword2,
            label: LocaleKeys.password,
            prefixIcon: const Icon(Icons.person),
            filled: true,
            validator: (p0) {
              if (p0.isEmptyOrNull) return LocaleKeys.cantBeEmpty;

              if (p0! != tECPassword.text) return LocaleKeys.passwordsMatch;
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
