import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_easy/layout/cubit/cubit.dart';
import 'package:shop_easy/layout/cubit/states.dart';
import 'package:shop_easy/models/product_model.dart';
import 'package:shop_easy/shared/components/components.dart';
import 'package:shop_easy/shared/styles/colors.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel product;

  const ProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopStates>(builder: (context, state) {
      var cubit = ShopCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cached Network Image
                Center(
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                        child:
                            CircularProgressIndicator()), // Shows while loading
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error), // Shows if there is an error
                  ),
                ),
                const SizedBox(height: 20.0),
                // Product Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),

// Product Description
                Text(
                  product.description, // Add the description field here
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Product Price and Discount
                Row(
                  children: [
                    Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    if (product.discount > 0)
                      Text(
                        '\$${product.oldPrice}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(width: 10.0),
                    if (product.discount > 0)
                      Text(
                        '${product.discount}% OFF',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.orange,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Favorite and Cart Status
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFavorites(product.id);
                      },
                      icon: CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            (ShopCubit.get(context).favorites![product.id])!
                                ? defaultColor
                                : Colors.grey,
                        child: const Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          product.inCart ? Colors.green : Colors.grey,
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                state is! ShopAddOrRemoveProductLoadingState
                    ? defaultButton(
                        text:
                            product.inCart ? 'Remove from cart' : 'Add to cart',
                        function: () {
                          cubit.addOrRemoveProductFromCart(id: product.id);
                          product.inCart = !product.inCart;
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: 50,
                        color: defaultColor,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
