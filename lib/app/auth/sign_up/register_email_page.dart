import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloppy/app/app_bar/sloppy_app_bar.dart';

import '../../../common_widgets/custom_elevated_button.dart';
import '../../../common_widgets/custom_text_button.dart';
import '../../../common_widgets/custom_text_field_with_icon.dart';
import '../../../common_widgets/slide_container.dart';
import '../../../const/colors.dart';
import '../../../const/strings.dart';
import '../../../services/routing/route_navigator.dart';
import '../auth_app_providers.dart';
import '../auth_button.dart';
import 'sign_up_viewmodel.dart';


final sighUPEmailEditingControllerProvider =
    StateProvider.autoDispose((ref) => TextEditingController());

class RegisterEmailPage extends ConsumerWidget {
  const RegisterEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RouteNavigator navigator = RouteNavigator(context: context, ref: ref);
    final SignUpViewModel viewModel = ref.watch(signUpViewModelProvider);
    final TextEditingController editingController =
        ref.watch(sighUPEmailEditingControllerProvider);
    return Scaffold(
        appBar: const SloppyAppBar(),
        body: SlideContainer(
          onLeftSlideEndCallback: viewModel.emailIsValid ? () {
            navigator.pushNamed(nextPagePath: '/sign_up/register_password');
          } : null,
          onRightSlideEndCallback: () {
            navigator.goPrevious();
          },
          child: Center(
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
                          const Text(Strings.pleaseSetEmail,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
                              )),
                          const SizedBox(height: 6),
                          CustomTextFieldWithIcon(
                            key: const Key('email'),
                            editingController: editingController,
                            validator:
                                viewModel.userEmailEditingRegexValidator,
                            iconPrefix: Icons.email,
                            hintText: Strings.emailFormField,
                            errorText: viewModel.emailErrorText,
                            inputEnable: !viewModel.isLoading,
                            keyboardType: TextInputType.emailAddress,
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
                                      navigator.removeUntil(
                                          removeUntil: ['/sign_up']);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomElevatedButton(
                                    key: const Key('test1'),
                                    onPressed: () async {
                                      await viewModel
                                          .updateEmail(editingController.text);
                                      if (!viewModel.emailIsValid) {
                                        return;
                                      }
                                      navigator.pushNamed(
                                          nextPagePath:
                                              '/sign_up/register_password');
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
                                labelText: 'メールアドレスを持たない場合',
                                onPressed: () async {
                                  await viewModel.clear();
                                  navigator.pushNamedAndRemoveUntil(
                                      nextPagePath:
                                          '/sign_up/register_username',
                                      removeUntil: ['/sign_up']);
                                },
                              ),
                            ),
                          )
                        ])),
              );
            }),
          ),
        ));
  }
}
