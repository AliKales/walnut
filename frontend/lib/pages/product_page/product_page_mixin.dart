// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:caroby/caroby.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/locale_keys.dart';
import 'package:frontend/models/m_product.dart';
import 'package:frontend/pages/product_page/product_page_view.dart';
import 'package:frontend/services/service_auth.dart';
import 'package:frontend/services/service_product.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

mixin ProductPageMixin on State<ProductPageView> {
  final formKey = GlobalKey<FormState>();
  final tECName = TextEditingController();
  final tECPrice = TextEditingController();
  final tECDescription = TextEditingController();

  String imagePath = "";

  ///[isNewProduct] checks if a product is sent
  bool get isNewProduct => product == null;
  bool get isMyProduct => product?.userId == ServiceAuth.me?.id || isNewProduct;

  @override
  void initState() {
    super.initState();
    if (!isNewProduct) _initValues(product!);
  }

  @override
  void dispose() {
    tECName.dispose();
    tECPrice.dispose();
    tECDescription.dispose();
    super.dispose();
  }

  void _initValues(MProduct p) {
    tECName.text = p.name ?? "";
    tECPrice.text = p.price.toString();
    tECDescription.text = p.description ?? "";
    imagePath = p.image ?? "";
  }

  Future<void> add() async {
    if (!formKey.currentState!.validate()) return;
    if (imagePath.isEmptyOrNull) {
      return showSnackbar(LocaleKeys.pleasePickImage, false);
    }

    CustomProgressIndicator.showProgressIndicator(context);

    final r = await ServiceProduct.addProduct(
      tECName.text,
      double.parse(tECPrice.text),
      tECDescription.text,
    );

    context.pop();

    if (r.$1 != HttpStatus.ok) {
      return showSnackbar(LocaleKeys.unexpectedError, false);
    }

    _uploadImage(r.$2!);
  }

  Future<void> update() async {
    if (!formKey.currentState!.validate()) return;
    if (imagePath.isEmptyOrNull) {
      return showSnackbar(LocaleKeys.pleasePickImage, false);
    }

    CustomProgressIndicator.showProgressIndicator(context);

    final r = await ServiceProduct.addProduct(
      tECName.text,
      double.parse(tECPrice.text),
      tECDescription.text,
      productId: product?.id,
    );

    context.pop();

    if (r.$1 != HttpStatus.ok) {
      return showSnackbar(LocaleKeys.unexpectedError, false);
    }

    //if photo has not changed then we pop
    if (product!.image == imagePath) {
      //here we set last imagePath because database doesn't return image
      r.$2!.image = imagePath;
      context.pop(r.$2);
      return;
    }

    _uploadImage(r.$2!);
  }

  Future<void> deleteProduct() async {
    final r = await ServiceProduct.deleteProduct(product!.id!);

    if (r != HttpStatus.ok) {
      showSnackbar(LocaleKeys.unexpectedError, false);
      return;
    }

    context.pop(product!.id!);
  }

  Future<void> _uploadImage(MProduct product) async {
    CustomProgressIndicator.showProgressIndicator(context);

    final r = await ServiceProduct.uploadImage(imagePath, product.id!);

    context.pop();

    if (r.$1 != HttpStatus.ok) {
      return;
    }

    product.image = r.$2;

    context.pop(product);
  }

  Future<void> pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (file == null) return;

    setState(() {
      imagePath = file.path;
    });
  }

  void showSnackbar(String text, bool isSuccess);

  MProduct? get product;
}
