import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_easy/modules/shop_app/search/search_screen.dart';
import 'package:shop_easy/shared/components/components.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, index) {},
      builder: (context, index) {
        var cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Shop Easy',
            ),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context, const SearchScreen());
                },
                icon: const Icon(
                  Icons.search,
                ),
              )
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              cubit.changeBottom(index);
            },
            currentIndex: cubit.currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.question_answer,
                ),
                label: 'Faqs',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
