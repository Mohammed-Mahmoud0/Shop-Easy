import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopStates>(
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is ShopLoadingUpdateUserDataState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (value) {
                      if (value?.isEmpty == true) {
                        return 'name must not be empty';
                      }
                      return null;
                    },
                    label: 'Name',
                    prefix: Icons.person,
                    onSubmit: (String value) {},
                    onChange: (String value) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    readOnly: true,
                    validate: (value) {
                      if (value?.isEmpty == true) {
                        return 'email must not be empty';
                      }
                      return null;
                    },
                    label: 'Email Address',
                    prefix: Icons.email,
                    onSubmit: (String value) {},
                    onChange: (String value) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    validate: (value) {
                      if (value?.isEmpty == true) {
                        return 'phone must not be empty';
                      }
                      return null;
                    },
                    label: 'Phone',
                    prefix: Icons.phone,
                    onSubmit: (String value) {},
                    onChange: (String value) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                    background: const Color(0xFF1976D2),
                    function: () {
                      if (formKey.currentState!.validate() == true) {
                        ShopCubit.get(context).updateUserData(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                        );
                      }
                    },
                    text: 'Update',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                    background: const Color(0xFF1976D2),
                    function: () {
                      signOut(context);
                    },
                    text: 'Logout',
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
