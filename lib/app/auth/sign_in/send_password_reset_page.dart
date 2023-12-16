import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloppy/app/app_bar/sloppy_app_bar.dart';

import '../../../common_widgets/custom_elevated_button.dart';
import '../../../common_widgets/custom_text_field_with_icon.dart';
import '../../../common_widgets/progress_hud.dart';
import '../../../const/strings.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/routing/route_navigator.dart';
import '../../../utils/show_alert_dialog.dart';
import '../auth_app_providers.dart';
import '../auth_button.dart';
import 'sign_in_viewmodel.dart';

class SendPasswordResetEmailPage extends ConsumerWidget {
  const SendPasswordResetEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteNavigator navigator = RouteNavigator(context: context, ref: ref);
    SignInViewModel viewModel = ref.watch(signInViewModelProvider);
    AsyncValue<List<dynamic>> signInPageArgumentsFuture =
        ref.watch(signInPageArgumentsProvider);
    return signInPageArgumentsFuture.when(
      data: (signInEditingControllers) {
        TextEditingController userNameOrEmailEditingController =
            signInEditingControllers.elementAt(0);
        return ProgressHUD(
            inProgress: viewModel.isLoading,
            firstText: viewModel.loadingMessage,
            child: Scaffold(
              appBar: const SloppyAppBar(),
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
                              const Text('登録済みのメールアドレスを入力してください',
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white70,
                                  )),
                              const SizedBox(height: 6),
                              CustomTextFieldWithIcon(
                                key: const Key('email'),
                                editingController:
                                    userNameOrEmailEditingController,
                                validator: viewModel.emailEditingRegexValidator,
                                iconPrefix: Icons.email,
                                hintText: Strings.emailFormField,
                                errorText: viewModel.emailErrorText,
                                inputEnable: !viewModel.isLoading,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 19),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: CancelButton(
                                        onPressed: () async {
                                          navigator.goPrevious();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CustomElevatedButton(
                                        key: const Key('test1'),
                                        onPressed: () async {
                                          viewModel.updateUserNameOrEmail(
                                              userNameOrEmailEditingController
                                                  .text);
                                          SendPasswordResetEmailResultStatus
                                              resultStatus = await viewModel
                                                  .sendPasswordResetEmail();
                                          if (resultStatus ==
                                              SendPasswordResetEmailResultStatus
                                                  .successful) {
                                            if (context.mounted) {
                                              await showAlertDialog(
                                                  title: Strings
                                                      .completedToSendEmail,
                                                  context: context,
                                                  navigator: navigator,
                                                  content: Strings
                                                      .pleaseOpenResetPasswordLink);
                                            }
                                            navigator.pushNamedAndRemoveUntil(
                                                nextPagePath: '/sign_in',
                                                removeUntil: ['/home']);
                                            return;
                                          }
                                          if (resultStatus ==
                                              SendPasswordResetEmailResultStatus
                                                  .invalidEmail) {
                                            // TODO:
                                            return;
                                          }
                                          if (!context.mounted) {
                                            return;
                                          }
                                          await showAlertDialog(
                                              context: context,
                                              navigator: navigator,
                                              content: Strings
                                                  .failedToSendPasswordResetEmail);
                                        },
                                        borderRadius: 8.0,
                                        child: const Text('送信',
                                            style: TextStyle(
                                              color: Colors.black,
                                            )),
                                      ),
                                    ),
                                  ]),
                              const SizedBox(height: 19),
                              const SizedBox(
                                height: 45,
                              )
                            ])),
                  );
                }),
              ),
            ));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Text('error'),
    );
  }
}
