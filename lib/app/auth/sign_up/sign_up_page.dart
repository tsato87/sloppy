import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloppy/app/app_bar/sloppy_app_bar.dart';

import '../../../common_widgets/custom_text_button.dart';
import '../../../const/colors.dart';
import '../../../const/strings.dart';
import '../../../services/routing/route_navigator.dart';
import '../auth_app_providers.dart';
import '../auth_button.dart';
import '../sign_in/sign_in_button.dart';
import 'sign_up_viewmodel.dart';


class SignUpPage extends ConsumerWidget {
  static const Key googleButtonKey = Key('google');
  static const Key facebookButtonKey = Key('facebook');
  static const Key emailPasswordButtonKey = Key('email-password');

  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteNavigator navigator = RouteNavigator( context: context, ref: ref);
    final SignUpViewModel viewModel = ref.watch(signUpViewModelProvider);
    return Scaffold(
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
                    SizedBox(
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: SloppyColors.sloppyTheme),
                        ),
                        child: const Center(
                            child: Text(
                          'Sloppy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 38.0,
                            color: SloppyColors.sloppyTheme,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SignButton(
                      key: emailPasswordButtonKey,
                      text: Strings.register,
                      onPressed: () async {
                        await viewModel.clear();
                        navigator.pushNamed(
                            nextPagePath: '/sign_up/register_email');
                      },
                    ),
                    const SizedBox(height: 11),
                    CustomTextButton(
                      labelText: Strings.goToHomePage,
                      onPressed: () {
                        navigator.removeUntil(removeUntil: ['/home']);
                      },
                    ),
                    const SizedBox(height: 1),
                    Row(children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 9.0, right: 13.0),
                            child: const Divider(
                              color: Colors.white70,
                              thickness: 0.7,
                              height: 40,
                            )),
                      ),
                      const Text(
                        Strings.orSignInWithSNSAccount,
                        style: TextStyle(color: Colors.white70),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 13.0, right: 9.0),
                            child: const Divider(
                              color: Colors.white70,
                              thickness: 0.7,
                              height: 40,
                            )),
                      ),
                    ]),
                    const SizedBox(height: 14),
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
                          color: SloppyColors.googleTheme,
                          assetName: 'assets/g_logo.png',
                          onPressed: () {},
                        ),
                        SocialIconButton(
                          key: const Key('facebook'),
                          color: SloppyColors.facebookTheme,
                          assetName: 'assets/f_logo.png',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ]),
            ),
          );
        }),
      ),
    );
  }
}
