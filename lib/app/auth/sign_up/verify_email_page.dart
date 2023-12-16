import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloppy/app/auth/sign_up/sign_up_viewmodel.dart';

import '../../../const/colors.dart';
import '../../../common_widgets/custom_elevated_button.dart';
import '../../../common_widgets/progress_hud.dart';
import '../../../utils/show_alert_dialog.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/routing/route_navigator.dart';
import '../auth_app_providers.dart';
import '../auth_button.dart';



class VerifyEmailPage extends ConsumerWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteNavigator navigator = RouteNavigator(
        context: context, ref: ref);
    SignUpViewModel viewModel = ref.watch(signUpViewModelProvider);
    viewModel.startWatchEmailVerified(() {
      navigator.removeUntil(removeUntil: ['/home']);
    });
    return ProgressHUD(
        inProgress: viewModel.isLoading,
        firstText: viewModel.loadingMessage,
        child: Scaffold(
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
                  padding: const EdgeInsets.all(23.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${viewModel.email} に確認メールを送信しました',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'sloppyを開始するには、メール文中のリンクを開いて、ユーザー登録を完了させてください',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ]),
                      const SizedBox(height: 32),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CancelButton(
                                onPressed: () async {
                                  viewModel.stopWatchEmailVerified();
                                  await viewModel
                                      .restoreAuthenticationInformation();
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
                                  SendVerifyEmailResultStatus resultStatus =
                                      await viewModel.sendEmailVerification();
                                  if (resultStatus !=
                                      SendVerifyEmailResultStatus.successful &&
                                      context.mounted) {
                                    showAlertDialog(
                                        context: context,
                                        navigator: navigator,
                                        title: 'メール送信失敗',
                                        content:
                                            viewModel.getSendEmailErrorMessage(
                                                resultStatus));
                                  }
                                },
                                borderRadius: 8.0,
                                child: const Text('メールを再送信',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ]),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () async {
                          viewModel.stopWatchEmailVerified();
                          await viewModel.restoreAuthenticationInformation();
                          await viewModel.clear();
                          navigator.pushReplacementNamed(
                              nextPagePath: '/sign_up/register_username');
                        },
                        child: const Text('メールアドレスの代わりにユーザー名を登録する'),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
