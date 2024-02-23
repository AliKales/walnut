import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/m_product.dart';
import 'package:frontend/widgets/product_image.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    required this.product,
    required this.onTap,
  });

  final MProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(image: product.image ?? ""),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: [
                  Text(
                    product.name ?? "-",
                    style: context.textTheme.titleLarge!.toBold,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ).expanded,
                  //Padding
                  const SizedBox(width: 15),
                  Text(
                    "\$${product.price ?? 00.00}",
                    style: context.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                product.description ?? "",
                style: context.textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
