// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/sp.dart';
import 'package:frontend/router.dart';
import 'package:frontend/services/service_auth.dart';
import 'package:go_router/go_router.dart';

import '../../locale_keys.dart';

class LoadingPageView extends StatefulWidget {
  const LoadingPageView({super.key});

  @override
  State<LoadingPageView> createState() => _LoadingPageViewState();
}

class _LoadingPageViewState extends State<LoadingPageView> {
  String _error = "";

  bool get _isError => _error.isNotEmptyAndNull;

  @override
  void initState() {
    super.initState();
    context.afterBuild((p0) => _afterBuild());
  }

  Future<void> _afterBuild() async {
    await SP.init();
    final authResult = await ServiceAuth.init();

    if (authResult == HttpStatus.unauthorized) {
      context.go(PagePaths.login);
      return;
    } else if (authResult != HttpStatus.ok) {
      _showError();
      return;
    }

    context.go(PagePaths.main);
  }

  void _showError() {
    setState(() {
      _error = LocaleKeys.unexpectedError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.appName),
        centerTitle: true,
      ),
      body: Padding(
        padding: Values.paddingPage(context),
        child: _isError ? _ErrorWidget(error: _error) : const _LoadingWidget(),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}

class _LoadingWidget extends StatefulWidget {
  const _LoadingWidget();

  @override
  State<_LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<_LoadingWidget>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: 1500.toDuration, vsync: this);
    animation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(-1.5, 0))
            .animate(controller)
          ..addListener(() {
            if (controller.isCompleted) {
              controller.repeat();
            }
          });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: animation,
          child: Image.asset(
            "assets/gifs/supermarket-mart.gif",
            width: 0.5.toDynamicWidth(context),
          ),
        ),
        const LinearProgressIndicator(
          minHeight: 15,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        const SizedBox(height: kToolbarHeight * 2),
      ],
    ).center;
  }
}
