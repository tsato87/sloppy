import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/custom_elevated_button.dart';
import '../../../common_widgets/custom_text_button.dart';
import '../../../common_widgets/custom_text_field_with_icon.dart';
import '../../../const/colors.dart';
import '../../../const/strings.dart';
import '../../../services/routing/route_navigator.dart';
import '../auth_app_providers.dart';
import '../auth_button.dart';
import 'sign_up_viewmodel.dart';


final sighUpUsernameEditingControllerProvider =
    StateProvider.autoDispose((ref) => TextEditingController());

class RegisterUsernamePage extends ConsumerWidget {
  const RegisterUsernamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RouteNavigator navigator = RouteNavigator(context: context, ref: ref);
    SignUpViewModel viewModel = ref.watch(signUpViewModelProvider);
    TextEditingController editingController =
        ref.watch(sighUpUsernameEditingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'sloppy',
          style: TextStyle(
            color: SloppyColors.sloppyTheme,
          ),
        ),
      ),
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              width: min(constraints.maxWidth, 500),
              padding: const EdgeInsets.all(18.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(Strings.pleaseSetUserName,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                        )),
                    const SizedBox(height: 6),
                    CustomTextFieldWithIcon(
                      key: const Key('username'),
                      editingController: editingController,
                      validator:
                          viewModel.userNameEditingRegexValidator,
                      iconPrefix: Icons.account_box_rounded,
                      hintText: Strings.userNameFormField,
                      errorText: viewModel.userNameErrorText,
                      inputEnable: !viewModel.isLoading,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 19),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CancelButton(
                              onPressed: () async {
                                await viewModel.clear();
                                navigator.removeUntil(removeUntil: ['/home']);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomElevatedButton(
                              key: const Key('test1'),
                              onPressed: () async {
                                await viewModel
                                    .updateUserName(editingController.text);
                                if (!viewModel.userNameIsValid) {
                                  return;
                                }
                                navigator.pushNamed(
                                    nextPagePath: '/sign_up/register_password');
                              },
                              borderRadius: 8.0,
                              child: const Text(Strings.next,
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ]),
                    const SizedBox(height: 19),
                    SizedBox(
                      height: 45,
                      child: Center(
                        child: CustomTextButton(
                          labelText: 'メールアドレスを設定する',
                          onPressed: () async {
                            await viewModel.clear();
                            navigator.pushNamed(
                                nextPagePath: '/sign_up/register_email');
                          },
                        ),
                      ),
                    )
                  ]),
            ),
          );
        }),
      ),
    );
  }
}
