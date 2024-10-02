import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../models/shop_app/favorites_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopStates>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesState,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildFavItem(
                ShopCubit.get(context).favoritesModel!.data!.data[index],
                context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: ShopCubit.get(context).favoritesModel!.data!.data.length,
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildFavItem(FavoritesData model, context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  CachedNetworkImage(
                    imageUrl: model.product!.image!,
                    height: 120.0,
                    width: 120.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                        child:
                            CircularProgressIndicator()), // Shows while loading
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error), // Shows if there is an error
                  ),
                  if (model.product!.discount != 0)
                    Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: const Text(
                        'Discount',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.product!.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          model.product!.price.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: defaultColor,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (model.product!.discount != 0)
                          Text(
                            model.product!.oldPrice.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            ShopCubit.get(context)
                                .changeFavorites(model.product!.id!);
                          },
                          icon: CircleAvatar(
                            radius: 15,
                            backgroundColor: (ShopCubit.get(context)
                                    .favorites![model.product!.id])!
                                ? defaultColor
                                : Colors.grey,
                            child: const Icon(
                              Icons.favorite_border,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
