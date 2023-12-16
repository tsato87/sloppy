import 'app/auth/landing_page.dart';
import 'app/home/home_page.dart';
import 'app/auth/sign_in/send_password_reset_page.dart';
import 'app/auth/sign_in/sign_in_page.dart';
import 'app/auth/sign_up/register_email_page.dart';
import 'app/auth/sign_up/register_username_page.dart';
import 'app/auth/sign_up/sign_up_page.dart';
import 'app/auth/sign_up/verify_email_page.dart';
import 'app/auth/sign_up/register_password_page.dart';
import 'const/paths.dart';
import 'services/routing/routing_service.dart';

String initialPagePath = Paths.root;

List<String> persistentPagePaths = [
  Paths.home,
];

Map<String, PageBuilder> pageRoutes = {
  Paths.root: (context) => const LandingPage(),
  Paths.home: (context) => const HomePage(),
  Paths.signIn: (context) => const SignInPage(),
  Paths.signInSendEmailLink: (context) => const SendPasswordResetEmailPage(),
  Paths.signUp: (context) => const SignUpPage(),
  Paths.signUpRegisterEmail: (context) => const RegisterEmailPage(),
  Paths.signUpRegisterUsername: (context) => const RegisterUsernamePage(),
  Paths.signUpRegisterPassword: (context) => const RegisterPasswordPage(),
  Paths.signUpVerifyEmail: (context) => const VerifyEmailPage(),
};
