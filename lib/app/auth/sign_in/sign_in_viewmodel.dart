import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../const/strings.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/auth/string_validator.dart';
import '../../../services/local_storage/parameter_handler.dart';
import '../../../utils/observer.dart';
import '../../../utils/string_validator.dart';
import '../sign_up/sign_up_viewmodel.dart';


enum SignInViewModelLoadingStatus {
  noLoading,
  trySignIn,
  sendingResetEmail,
}

enum LastSignInMethodStatus {
  userEmailAndPassword,
  userNameAndPassword,
  google,
  facebook,
  twitter,
  yahoo,
  line,
  noCached,
}

class SignInViewModel extends ChangeNotifier {
  final AuthService authService;
  final SignUpViewModel signUpViewModel;
  final ParameterHandler parameterHandler;
  final Observer _dispose = Observer();
  String userNameOrEmail;
  String password;
  SignInViewModelLoadingStatus loadingStatus;
  bool submittedEmail;
  bool submitted;
  bool useEmail;
  bool userNotExists;
  bool wrongPassword;
  bool savePassword;

  @override
  void dispose() {
    List<dynamic> emptyArgs = [];
    _dispose.emit(emptyArgs);
    super.dispose();
  }

  final NonEmptyStringValidator nonEmptyStringValidator =
      NonEmptyStringValidator();

  final NonEmailValidator nonEmailValidator = NonEmailValidator();

  final UsernameLetterValidator userNameLetterValidator =
      UsernameLetterValidator();
  final MaxLengthStringValidator userNameMaxLengthStringValidator =
      MaxLengthStringValidator(20);
  final EmailSubmitValidator emailSubmitRegexValidator = EmailSubmitValidator();

  final NoSpaceRegexValidator userNameOrEmailEditingRegexValidator =
      NoSpaceRegexValidator();
  final SloppyEmailRegexValidator sloppyEmailRegexValidator =
      SloppyEmailRegexValidator();

  final NoSpaceRegexValidator emailEditingRegexValidator =
      NoSpaceRegexValidator();
  final LessThenOneNumberValidator lessThenOneNumberValidator =
      LessThenOneNumberValidator();

  final LessThenOneLowerCaseValidator lessThenOneLowerCaseValidator =
      LessThenOneLowerCaseValidator();
  final LessThenOneUpperCaseValidator lessThenOneUpperCaseValidator =
      LessThenOneUpperCaseValidator();
  final MinLengthStringValidator passwordMinLengthStringValidator =
      MinLengthStringValidator(8);
  final MaxLengthStringValidator passwordMaxLengthStringValidator =
      MaxLengthStringValidator(24);

  SignInViewModel(
    this.authService,
    this.signUpViewModel,
    this.parameterHandler, {
    this.userNameOrEmail = '',
    this.password = '',
    this.loadingStatus = SignInViewModelLoadingStatus.noLoading,
    this.submittedEmail = false,
    this.submitted = false,
    this.useEmail = true,
    this.userNotExists = false,
    this.wrongPassword = false,
    this.savePassword = false,
  });

  Future<void> initialize() async {
    await _loadAuthenticationInformation();
  }

  void _updateWith({
    String? userNameOrEmail,
    String? password,
    SignInViewModelLoadingStatus? loadingStatus,
    bool? submitted,
    bool? submittedEmail,
    bool? savePassword,
    bool? wrongPassword,
    bool? userNotExists,
  }) {
    this.userNameOrEmail = userNameOrEmail ?? this.userNameOrEmail;
    this.password = password ?? this.password;
    this.loadingStatus = loadingStatus ?? this.loadingStatus;
    this.submitted = submitted ?? this.submitted;
    this.submittedEmail = submittedEmail ?? this.submittedEmail;
    this.userNotExists = userNotExists ?? this.userNotExists;
    this.wrongPassword = wrongPassword ?? this.wrongPassword;
    this.savePassword = savePassword ?? this.savePassword;
    notifyListeners();
  }

  Stream<SloppyUser?> authStateChanges() {
    return authService.authStateChanges;
  }

  bool get canSubmit {
    return (_userNameOrEmailIsValid && _isPasswordValid && !isLoading);
  }

  String? get emailErrorText {
    if (!submittedEmail) {
      return null;
    }
    if (!nonEmptyStringValidator.isValid(userNameOrEmail)) {
      return Strings.emailIsEmpty;
    }
    if (!emailSubmitRegexValidator.isValid(userNameOrEmail)) {
      return Strings.emailIsInvalid;
    }
    if (sloppyEmailRegexValidator.isValid(userNameOrEmail)) {
      return Strings.emailCannotUse;
    }
    return null;
  }

  bool get isEmail {
    return emailSubmitRegexValidator.isValid(userNameOrEmail);
  }

  bool get isLoading {
    return loadingStatus != SignInViewModelLoadingStatus.noLoading;
  }

  String get loadingMessage {
    return <SignInViewModelLoadingStatus, String>{
          SignInViewModelLoadingStatus.trySignIn: 'サーバー問い合わせ中',
          SignInViewModelLoadingStatus.sendingResetEmail: 'メール送信中',
        }[loadingStatus] ??
        '';
  }

  String? get passwordErrorText {
    if (!submitted) {
      return null;
    }
    if (!nonEmptyStringValidator.isValid(password)) {
      return Strings.passwordIsEmpty;
    }
    if (!lessThenOneNumberValidator.isValid(password) ||
        !lessThenOneLowerCaseValidator.isValid(password) ||
        !lessThenOneUpperCaseValidator.isValid(password)) {
      return Strings.passwordLessThanOneLetter;
    }
    if (!passwordMinLengthStringValidator.isValid(password)) {
      return Strings.passwordTooShort;
    }
    if (!passwordMaxLengthStringValidator.isValid(password)) {
      return Strings.passwordTooLong;
    }
    if (wrongPassword) {
      return Strings.passwordNotMatch;
    }
    return null;
  }

  String? get userNameOrEmailErrorText {
    if (!submitted) {
      return null;
    }
    if (!nonEmptyStringValidator.isValid(userNameOrEmail)) {
      return Strings.userNameOrEmailIsEmpty;
    }
    if (emailSubmitRegexValidator.isValid(userNameOrEmail)) {
      if (userNotExists) {
        return Strings.userNotExists;
      }
      return null;
    }
    assert(nonEmailValidator.isValid(userNameOrEmail));
    if (!userNameLetterValidator.isValid(userNameOrEmail)) {
      return Strings.userNameBadLetter;
    }
    if (!userNameMaxLengthStringValidator.isValid(userNameOrEmail)) {
      return Strings.asUserNameTooLong;
    }
    if (userNotExists) {
      return Strings.userNotExists;
    }
    return null;
  }

  bool get _isEmailValid {
    return (nonEmptyStringValidator.isValid(userNameOrEmail) &&
        emailSubmitRegexValidator.isValid(userNameOrEmail) &&
        !sloppyEmailRegexValidator.isValid(userNameOrEmail));
  }

  bool get _isPasswordValid {
    return (nonEmptyStringValidator.isValid(password) &&
        lessThenOneNumberValidator.isValid(password) &&
        lessThenOneLowerCaseValidator.isValid(password) &&
        lessThenOneUpperCaseValidator.isValid(password) &&
        passwordMinLengthStringValidator.isValid(password) &&
        passwordMaxLengthStringValidator.isValid(password));
  }

  bool get _isUserNameValid {
    return (nonEmptyStringValidator.isValid(userNameOrEmail) &&
        nonEmailValidator.isValid(userNameOrEmail) &&
        userNameLetterValidator.isValid(userNameOrEmail) &&
        userNameMaxLengthStringValidator.isValid(userNameOrEmail));
  }

  bool get _userNameOrEmailIsValid {
    // ^はXORの論理記号
    return (_isUserNameValid ^ _isEmailValid);
  }

  Future<bool> getAuthenticationInformationIsChanged() async {
    List<String?> previousUserNameOrEmailAndPassword =
        await authService.loadUserNameOrEmailAndPassword();
    String? previousUserNameOrEmail =
        previousUserNameOrEmailAndPassword.elementAt(0);
    String? previousPassword = previousUserNameOrEmailAndPassword.elementAt(1);
    bool isUserNameOrEmailChanged =
        ((userNameOrEmail != previousUserNameOrEmail) || (
            previousPassword != null &&
            password != previousPassword ));
    return isUserNameOrEmailChanged;
  }

  String getSighInErrorMessage(SignInWithEmailAndPasswordResultStatus status) {
    return <SignInWithEmailAndPasswordResultStatus, String>{
          SignInWithEmailAndPasswordResultStatus.tooManyRequests:
              'リクエスト回数が多すぎます。しばらく時間を置いて、もう一度試してみてください',
          SignInWithEmailAndPasswordResultStatus.undefined: '予期しないエラーが発生しました',
        }[status] ??
        '予期しないエラーが発生しました';
  }

  void updatePassword(String password) => _updateWith(password: password);

  void updateSavePassword(bool savePassword) =>
      _updateWith(savePassword: savePassword);

  void updateUserNameOrEmail(String userNameOrEmail) =>
      _updateWith(userNameOrEmail: userNameOrEmail);

  Future<void> _loadAuthenticationInformation() async {
    List<String?> userNameOrEmailAndPassword =
        await authService.loadUserNameOrEmailAndPassword();
    if (userNameOrEmail == '' &&
        userNameOrEmailAndPassword.elementAt(0) != null) {
      userNameOrEmail = userNameOrEmailAndPassword.elementAt(0)!;
    }
    if (password == '' && userNameOrEmailAndPassword.elementAt(1) != null) {
      password = userNameOrEmailAndPassword.elementAt(1)!;
    }
  }

  Future<void> saveAuthenticationInformation({bool savePassword = true}) async {
    if (!savePassword) {
      await authService.saveUserNameOrEmailAndPassword(userNameOrEmail, null);
      return;
    }
    await authService.saveUserNameOrEmailAndPassword(userNameOrEmail, password);
  }

  Future<SignInWithEmailAndPasswordResultStatus>
      signInWithUserNameOrEmailAndPassword() async {
    SignInWithEmailAndPasswordResultStatus resultStatus;
    _updateWith(submitted: true);
    if (!canSubmit) {
      return SignInWithEmailAndPasswordResultStatus.canNotSubmit;
    }
    _updateWith(loadingStatus: SignInViewModelLoadingStatus.trySignIn);
    if (isEmail) {
      resultStatus = await authService.signInWithEmailAndPassword(
          userNameOrEmail, password);
    } else {
      resultStatus = await authService.signInWithUserNameAndPassword(
          userNameOrEmail, password);
    }
    bool userNotExists =
        (resultStatus == SignInWithEmailAndPasswordResultStatus.userNotExists);
    _updateWith(userNotExists: userNotExists);
    bool wrongPassword =
        (resultStatus == SignInWithEmailAndPasswordResultStatus.wrongPassword);
    _updateWith(wrongPassword: wrongPassword);
    if (resultStatus ==
        SignInWithEmailAndPasswordResultStatus.needEmailVerified) {
      signUpViewModel.loadAuthenticationInformation();
      signUpViewModel.sendEmailVerification();
    }
    _updateWith(loadingStatus: SignInViewModelLoadingStatus.noLoading);
    return resultStatus;
  }

  Future<SendPasswordResetEmailResultStatus> sendPasswordResetEmail() async {
    _updateWith(submittedEmail: true);
    if (!isEmail) {
      return SendPasswordResetEmailResultStatus.invalidEmail;
    }
    _updateWith(loadingStatus: SignInViewModelLoadingStatus.sendingResetEmail);
    SendPasswordResetEmailResultStatus resultStatus =
        await authService.sendPasswordResetEmail(userNameOrEmail);
    _updateWith(loadingStatus: SignInViewModelLoadingStatus.noLoading);
    return resultStatus;
  }
}
