part of '../seller_page_view.dart';

class _FAB extends FloatingActionButton {
  const _FAB.extended(VoidCallback onTap)
      : super.extended(
          onPressed: onTap,
          label: const Text(LocaleKeys.newProduct),
          icon: const Icon(Icons.add),
        );
}
