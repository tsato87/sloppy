import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloppy/app/app_bar/sloppy_app_bar.dart';

import '../../../common_widgets/custom_text_button.dart';
import '../../../common_widgets/custom_text_field_with_icon.dart';
import '../../../common_widgets/progress_hud.dart';
import '../../../const/colors.dart';
import '../../../const/strings.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/routing/route_navigator.dart';
import '../../../utils/show_alert_dialog.dart';
import '../auth_app_providers.dart';
import '../auth_button.dart';
import 'sign_in_button.dart';
import 'sign_in_viewmodel.dart';


class SignInPage extends ConsumerWidget{
  static const Key googleButtonKey = Key('google');
  static const Key facebookButtonKey = Key('facebook');
  static const Key emailPasswordButtonKey = Key('email-password');

  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RouteNavigator navigator = RouteNavigator(
        context: context, ref: ref);
    SignInViewModel signInViewModel = ref.watch(signInViewModelProvider);
    AsyncValue<List<dynamic>> signInPageArgumentsFuture =
        ref.watch(signInPageArgumentsProvider);

    return signInPageArgumentsFuture.when(
      data: (signInPageArguments) {
        TextEditingController userNameOrEmailEditingController =
            signInPageArguments.elementAt(0);
        TextEditingController passwordEditingController =
            signInPageArguments.elementAt(1);
        bool askSavePassword = signInPageArguments.elementAt(2);
        return ProgressHUD(
          inProgress: signInViewModel.isLoading,
          firstText: signInViewModel.loadingMessage,
          child: Scaffold(
            appBar: const SloppyAppBar(),
            body: Center(
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Container(
                    width: min(constraints.maxWidth, 600),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextFieldWithIcon(
                            editingController: userNameOrEmailEditingController,
                            validator: signInViewModel
                                .userNameOrEmailEditingRegexValidator,
                            iconPrefix: Icons.account_box_rounded,
                            errorText: signInViewModel.userNameOrEmailErrorText,
                            hintText: Strings.userNameOrEmailFormField,
                          ),
                          const SizedBox(height: 11),
                          CustomPasswordFieldWithIcon(
                            editingController: passwordEditingController,
                            errorText: signInViewModel.passwordErrorText,
                            hintText: Strings.passwordFormField,
                          ),
                          if (askSavePassword)
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Switch(
                                      onChanged: (bool savePassword) {
                                        signInViewModel
                                            .updateSavePassword(savePassword);
                                      },
                                      value: signInViewModel.savePassword),
                                  const Text('パスワードを端末に記憶する',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ))
                                ]),
                          const SizedBox(height: 16),
                          SignButton(
                            key: emailPasswordButtonKey,
                            text: Strings.signInWithEmailPassword,
                            onPressed: () async {
                              signInViewModel.updateUserNameOrEmail(
                                  userNameOrEmailEditingController.text);
                              signInViewModel.updatePassword(
                                  passwordEditingController.text);
                              SignInWithEmailAndPasswordResultStatus
                                  resultStatus = await signInViewModel
                                      .signInWithUserNameOrEmailAndPassword();
                              bool isUserNameOrEmailChanged =
                                  await signInViewModel
                                      .getAuthenticationInformationIsChanged();
                              if (resultStatus ==
                                  SignInWithEmailAndPasswordResultStatus
                                      .successful) {
                                if (isUserNameOrEmailChanged &&
                                    askSavePassword &&
                                    context.mounted) {
                                  bool? savePassword = await showAlertDialog(
                                    context: context,
                                    navigator: navigator,
                                    content: 'ログイン情報が更新されました。パスワードを端末に記憶しますか？',
                                    defaultActionText: '記憶する',
                                    cancelActionText: '記憶しない',
                                  );
                                  signInViewModel.updateSavePassword(
                                      savePassword ?? false);
                                }
                                if (signInViewModel.savePassword) {
                                  await signInViewModel
                                      .saveAuthenticationInformation();
                                } else if (isUserNameOrEmailChanged) {
                                  await signInViewModel
                                      .saveAuthenticationInformation(
                                          savePassword: false);
                                }
                                navigator.pushReplacementNamed(
                                    nextPagePath: '/');
                                return;
                              } else if (resultStatus ==
                                  SignInWithEmailAndPasswordResultStatus
                                      .needEmailVerified) {
                                navigator.pushNamedAndRemoveUntil(
                                    nextPagePath: '/sign_up/verify_email',
                                    removeUntil: ['/home']);
                                return;
                              } else if (resultStatus ==
                                      SignInWithEmailAndPasswordResultStatus
                                          .tooManyRequests ||
                                  resultStatus ==
                                      SignInWithEmailAndPasswordResultStatus
                                          .undefined) {
                                if (!context.mounted) {
                                  return;
                                }
                                showAlertDialog(
                                    context: context,
                                    navigator: navigator,
                                    title: 'サインイン失敗',
                                    content: signInViewModel
                                        .getSighInErrorMessage(resultStatus));
                                return;
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          CustomTextButton(
                              labelText: Strings.forgetPassword,
                              onPressed: () {
                                navigator.pushNamed(
                                    nextPagePath: '/sign_in/send_email_link');
                              }),
                          CustomTextButton(
                              labelText: Strings.cancel,
                              onPressed: () {
                                navigator.removeUntil(removeUntil: ['/home']);
                              }),
                          const SizedBox(height: 1),
                          Row(children: [
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 9.0, right: 13.0),
                                  child: const Divider(
                                    color: Colors.white70,
                                    thickness: 0.7,
                                    height: 40,
                                  )),
                            ),
                            const Text(
                              Strings.or,
                              style: TextStyle(color: Colors.white70),
                            ),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 13.0, right: 9.0),
                                  child: const Divider(
                                    color: Colors.white70,
                                    thickness: 0.7,
                                    height: 40,
                                  )),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SocialIconButton(
                                key: const Key('line'),
                                color: SloppyColors.lineTheme,
                                assetName: 'assets/l_logo.png',
                                onPressed: () {},
                              ),
                              SocialIconButton(
                                key: const Key('yahoo'),
                                color: SloppyColors.yahooTheme,
                                assetName: 'assets/y_logo.png',
                                onPressed: () {},
                              ),
                              SocialIconButton(
                                key: const Key('twitter'),
                                color: SloppyColors.twitterTheme,
                                assetName: 'assets/t_logo.png',
                                onPressed: () {},
                              ),
                              SocialIconButton(
                                key: const Key('google'),
                                assetName: 'assets/g_logo.png',
                                onPressed: () {},
                                color: SloppyColors.googleTheme,
                              ),
                              SocialIconButton(
                                key: const Key('facebook'),
                                assetName: 'assets/f_logo.png',
                                onPressed: () {},
                                color: SloppyColors.facebookTheme,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomTextButton(
                            labelText: Strings.createNewAccount,
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                navigator.pushNamed(
                                    nextPagePath: '/sign_up');
                              });
                            },
                          )
                        ]),
                  ),
                );
              }),
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => const Text('error'),
    );
  }
}
