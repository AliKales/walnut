import 'dart:io';

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.onNewImage,
    required this.image,
  });

  final String image;
  final VoidCallback? onNewImage;

  ///we use [ProductImage] on many pages
  ///therefore we check if we can change the image
  ///if yes then we place a [IconButton]
  bool get _canChangeImage => onNewImage != null;

  @override
  Widget build(BuildContext context) {
    if (_canChangeImage) {
      return Stack(
        children: [
          _container(context),
          _iconButton(),
        ],
      );
    }
    return _container(context);
  }

  Align _iconButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton.filled(
          iconSize: 35,
          onPressed: onNewImage,
          icon: const Icon(
            Icons.photo,
          ),
        ),
      ),
    );
  }

  Container _container(BuildContext context) {
    return Container(
      width: context.width,
      height: context.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: context.colorScheme.primary.withOpacity(0.4),
        image: _decorationImage(),
      ),
    );
  }

  DecorationImage? _decorationImage() {
    if (image.isEmptyOrNull) return null;

    ImageProvider i;

    if (image.contains("http")) {
      i = NetworkImage(image);
    } else {
      i = FileImage(File(image));
    }

    return DecorationImage(image: i, fit: BoxFit.cover);
  }
}
