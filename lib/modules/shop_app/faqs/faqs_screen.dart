import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_easy/models/shop_app/faqs_model.dart';

import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopStates>(
      builder: (context, state) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildFaqItem(
              ShopCubit.get(context).faqsModel!.data!.data![index]),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: ShopCubit.get(context).faqsModel!.data!.data!.length,
        );
      },
    );
  }

  Widget buildFaqItem(DataModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.question_answer,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    model.question!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              model.answer!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      );
}
