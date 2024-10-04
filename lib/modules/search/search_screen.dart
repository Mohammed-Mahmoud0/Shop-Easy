import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_easy/modules/product/product_search_screen.dart';

import '../../layout/cubit/cubit.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var formKey = GlobalKey<FormState>();

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocBuilder<SearchCubit, SearchStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      onSubmit: (text) {
                        SearchCubit.get(context).search(text);
                      },
                      onChange: (value) {},
                      validate: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please Enter a product to search for it';
                        }
                        return null;
                      },
                      label: 'Search',
                      prefix: Icons.search,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => buildSearchItem(
                              SearchCubit.get(context).model!.data!.data[index],
                              context),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount:
                              SearchCubit.get(context).model!.data!.data.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchItem(model, context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductSearchScreen(
                product: model,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 120,
            child: Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    CachedNetworkImage(
                      imageUrl: model.image,
                      height: 120.0,
                      width: 120.0,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child:
                              CircularProgressIndicator()), // Shows while loading
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error), // Shows if there is an error
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
                        model.name!,
                        maxLines: 3,
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
                            model.price.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: defaultColor,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                ShopCubit.get(context)
                                    .changeFavorites(model.id!);
                              });
                            },
                            icon: CircleAvatar(
                              radius: 15,
                              backgroundColor: (ShopCubit.get(context)
                                              .favorites![model.id] !=
                                          null &&
                                      ShopCubit.get(context)
                                          .favorites![model.id]!)
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
        ),
      );
}
