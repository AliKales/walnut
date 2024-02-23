import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/locale_keys.dart';
import 'package:frontend/models/m_product.dart';
import 'package:frontend/pages/product_page/product_page_mixin.dart';
import 'package:frontend/widgets/buttons.dart';
import 'package:frontend/widgets/c_text_field.dart';

import '../../widgets/product_image.dart';

class ProductPageView extends StatefulWidget {
  const ProductPageView({super.key, this.product});

  final MProduct? product;

  @override
  State<ProductPageView> createState() => _ProductPageViewState();
}

class _ProductPageViewState extends State<ProductPageView>
    with ProductPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: Values.paddingPage(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProductImage(
                onNewImage: isMyProduct ? pickImage : null,
                image: imagePath,
              ),
              const SizedBox(height: 10),
              const Divider(),
              _textFields(),
              const SizedBox(height: 30),
              if (isMyProduct)
                Buttons(
                  isNewProduct ? LocaleKeys.add : LocaleKeys.update,
                  isNewProduct ? add : update,
                ).filled(),
              const SizedBox(height: 90),
            ],
          ),
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
            controller: tECName,
            label: LocaleKeys.name,
            readOnly: !isMyProduct,
            filled: true,
            validator: (p0) {
              if (p0.isEmptyOrNull) return LocaleKeys.cantBeEmpty;
              return null;
            },
          ),
          CTextField(
            controller: tECPrice,
            label: LocaleKeys.price,
            readOnly: !isMyProduct,
            filled: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
              CMoneyFormatter(),
            ],
            validator: (p0) {
              if (p0.isEmptyOrNull) return LocaleKeys.cantBeEmpty;
              return null;
            },
          ),
          CTextField(
            controller: tECDescription,
            label: LocaleKeys.description,
            readOnly: !isMyProduct,
            filled: true,
            validator: (p0) {
              if (p0.isEmptyOrNull) return LocaleKeys.cantBeEmpty;
              return null;
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.product),
      actions: [
        if (!isNewProduct && isMyProduct)
          IconButton(
            onPressed: deleteProduct,
            icon: const Icon(Icons.delete_forever),
            color: context.colorScheme.error,
          ),
      ],
    );
  }

  @override
  void showSnackbar(String text, bool isSuccess) {
    CustomSnackbar.showSuccessSnackBar(context,
        text: text, isSuccess: isSuccess);
  }

  @override
  MProduct? get product => widget.product;
}
