import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_easy/layout/cubit/cubit.dart';
import 'package:shop_easy/layout/cubit/states.dart';
import 'package:shop_easy/shared/components/components.dart';
import 'package:shop_easy/shared/components/constants.dart';

class ChangePasswordScreen extends StatelessWidget {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Current Password"),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "New Password"),
            ),
            const SizedBox(
              height: 24,
            ),
            BlocConsumer<ShopCubit, ShopStates>(listener: (context, state) {
              if (state is ShopChangePasswordSuccessState) {
                showToast(
                    text: 'Password Changed Successfully',
                    state: ToastStates.success);
                Navigator.pop(context);
              }
            }, builder: (context, state) {
              return ConditionalBuilder(
                condition: state is! ShopChangePasswordLoadingState,
                builder: (context) => defaultButton(
                    background: const Color(0xFF1976D2),
                    text: "Confirm",
                    function: () {
                      ShopCubit.get(context).changePassword(
                          userCurrentPassword: currentPassword,
                          newPassword: newPasswordController.text.trim());
                    }),
                fallback: (context) => Container(
                  width: double.infinity,
                  height: 50,
                  color: const Color(0xFF1976D2),
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  )),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
