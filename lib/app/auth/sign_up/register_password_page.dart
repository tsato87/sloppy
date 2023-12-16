import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/custom_elevated_button.dart';
import '../../../common_widgets/custom_text_field_with_icon.dart';
import '../../../common_widgets/progress_hud.dart';
import '../../../common_widgets/switch_title.dart';
import '../../../const/colors.dart';
import '../../../const/strings.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/routing/route_navigator.dart';
import '../../../utils/show_alert_dialog.dart';
import '../auth_app_providers.dart';
import '../auth_button.dart';
import 'sign_up_viewmodel.dart';


final shouldSavePasswordProvider = StateProvider<bool>((ref) => false);
final sighUpPasswordEditingControllerProvider =
    StateProvider.autoDispose((ref) => TextEditingController());

class RegisterPasswordPage extends ConsumerWidget{
  const RegisterPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RouteNavigator navigator = RouteNavigator(
        context: context, ref: ref);
    final SignUpViewModel viewModel = ref.watch(signUpViewModelProvider);
    final TextEditingController editingController =
        ref.watch(sighUpPasswordEditingControllerProvider);
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
                padding: const EdgeInsets.all(18.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchTile(
                          message: 'パスワードを端末に保存する',
                          isChecked: viewModel.savePassword,
                          onChanged: (savePassword) {
                            viewModel.updateSavePassword(savePassword);
                          }),
                      const SizedBox(height: 6),
                      CustomPasswordFieldWithIcon(
                        key: const Key('password'),
                        editingController: editingController,
                        hintText: Strings.passwordFormField,
                        errorText: viewModel.passwordErrorText,
                        inputEnable: !viewModel.isLoading,
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
                                  viewModel
                                      .updatePassword(editingController.text);
                                  if (!viewModel.passwordIsValid) {
                                    return;
                                  }
                                  SignUpResultStatus resultStatus;
                                  resultStatus = await viewModel.submit();
                                  if (resultStatus !=
                                          SignUpResultStatus.successful &&
                                      context.mounted) {
                                    showAlertDialog(
                                        context: context,
                                        navigator: navigator,
                                        title: '登録失敗',
                                        content:
                                            viewModel.getSighUpErrorMessage(
                                                resultStatus));
                                    return;
                                  }
                                  if (viewModel.useEmail) {
                                    await viewModel.sendEmailVerification();
                                    navigator.pushNamedAndRemoveUntil(
                                        nextPagePath: '/sign_up/verify_email',
                                        removeUntil: ['/home']);
                                    return;
                                  }
                                  navigator.removeUntil(removeUntil: ['/home']);
                                },
                                borderRadius: 8.0,
                                child: const Text(Strings.register,
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ]),
                      const SizedBox(height: 19 + 45),
                    ]),
              ),
            );
          }),
        ),
      ),
    );
  }
}
