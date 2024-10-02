import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
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
                              context,
                              isOldPrice: false),
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

  Widget buildSearchItem(model, context, {bool isOldPrice = true}) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(model.image),
                    width: 120,
                    height: 120,
                  ),
                  if (model.discount != 0 && isOldPrice)
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
                        if (model.discount != 0 && isOldPrice)
                          Text(
                            model.oldPrice.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              ShopCubit.get(context).changeFavorites(model.id!);
                            });
                          },
                          icon: CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                (ShopCubit.get(context).favorites![model.id] !=
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
      );
}
