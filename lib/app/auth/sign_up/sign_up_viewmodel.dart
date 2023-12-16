import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../const/strings.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/auth/string_validator.dart';
import '../../../services/local_storage/parameter_handler.dart';
import '../../../utils/string_validator.dart';


enum SignUpViewModelLoadingStatus {
  noLoading,
  registeringUser,
  deletingUser,
  sendingEmail,
}

class SignUpViewModel extends ChangeNotifier {
  final AuthService authService;
  final ParameterHandler parameterHandler;
  String email;
  String userName;
  String password;
  String? previousUserEmailName;
  String? previousPassword;
  SignUpViewModelLoadingStatus loadingStatus;
  bool submittedUserName;
  bool submittedEmail;
  bool submitted;
  bool useEmail;
  bool userAlreadyExists;
  bool savePassword;

  final NonEmptyStringValidator nonEmptyStringValidator = NonEmptyStringValidator();

  final NonEmailValidator nonEmailValidator = NonEmailValidator();

  final UsernameLetterValidator userNameLetterValidator = UsernameLetterValidator();
  final MaxLengthStringValidator userNameMaxLengthStringValidator = MaxLengthStringValidator(20);
  final EmailSubmitValidator emailSubmitRegexValidator = EmailSubmitValidator();

  final SloppyEmailRegexValidator sloppyEmailRegexValidator = SloppyEmailRegexValidator();
  final NoSpaceRegexValidator userEmailEditingRegexValidator = NoSpaceRegexValidator();
  final UsernameLetterValidator userNameEditingRegexValidator = UsernameLetterValidator();

  final LessThenOneNumberValidator lessThenOneNumberValidator = LessThenOneNumberValidator();

  final LessThenOneLowerCaseValidator lessThenOneLowerValidator = LessThenOneLowerCaseValidator();
  final LessThenOneUpperCaseValidator lessThenOneUpperCaseValidator =
      LessThenOneUpperCaseValidator();
  final MinLengthStringValidator passwordMinLengthStringValidator = MinLengthStringValidator(8);
  final MaxLengthStringValidator passwordMaxLengthStringValidator = MaxLengthStringValidator(24);

  SignUpViewModel(
    this.authService,
    this.parameterHandler, {
    this.email = '',
    this.userName = '',
    this.password = '',
    this.loadingStatus = SignUpViewModelLoadingStatus.noLoading,
    this.submittedUserName = false,
    this.submittedEmail = false,
    this.submitted = false,
    this.useEmail = true,
    this.userAlreadyExists = false,
    this.savePassword = true,
  });

  void _updateWith({
    String? email,
    String? userName,
    String? password,
    SignUpViewModelLoadingStatus? loadingStatus,
    bool? submittedUserName,
    bool? submittedEmail,
    bool? submitted,
    bool? useEmail,
    bool? userAlreadyExists,
    bool? savePassword,
  }) {
    this.email = email ?? this.email;
    this.userName = userName ?? this.userName;
    this.password = password ?? this.password;
    this.loadingStatus = loadingStatus ?? this.loadingStatus;
    this.submittedUserName = submittedUserName ?? this.submittedUserName;
    this.submittedEmail = submittedEmail ?? this.submittedEmail;
    this.submitted = submitted ?? this.submitted;
    this.useEmail = useEmail ?? this.useEmail;
    this.userAlreadyExists = userAlreadyExists ?? this.userAlreadyExists;
    this.savePassword = savePassword ?? this.savePassword;
    notifyListeners();
  }

  bool get canSubmit {
    return (passwordIsValid && !isLoading);
  }

  String? get emailErrorText {
    if (!submittedEmail) {
      return null;
    }
    if (!nonEmptyStringValidator.isValid(email)) {
      return Strings.emailIsEmpty;
    }
    if (useEmail && userAlreadyExists) {
      return Strings.emailAlreadyExists;
    }
    if (!emailSubmitRegexValidator.isValid(email)) {
      return Strings.emailIsInvalid;
    }
    if (sloppyEmailRegexValidator.isValid(email)) {
      return Strings.emailCannotUse;
    }
    return null;
  }

  bool get emailIsValid {
    return (!userAlreadyExists &&
        nonEmptyStringValidator.isValid(email) &&
        emailSubmitRegexValidator.isValid(email) &&
        !sloppyEmailRegexValidator.isValid(email));
  }

  bool get isLoading {
    return loadingStatus != SignUpViewModelLoadingStatus.noLoading;
  }

  String get loadingMessage {
    return <SignUpViewModelLoadingStatus, String>{
          SignUpViewModelLoadingStatus.registeringUser: 'サーバー問い合わせ中',
          SignUpViewModelLoadingStatus.deletingUser: 'サーバー問い合わせ中',
          SignUpViewModelLoadingStatus.sendingEmail: '確認メール送信中',
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
        !lessThenOneLowerValidator.isValid(password) ||
        !lessThenOneUpperCaseValidator.isValid(password)) {
      return Strings.passwordLessThanOneLetter;
    }
    if (!passwordMinLengthStringValidator.isValid(password)) {
      return Strings.passwordTooShort;
    }
    if (!passwordMaxLengthStringValidator.isValid(password)) {
      return Strings.passwordTooLong;
    }
    return null;
  }

  bool get passwordIsValid {
    return (nonEmptyStringValidator.isValid(password) &&
        lessThenOneNumberValidator.isValid(password) &&
        lessThenOneLowerValidator.isValid(password) &&
        lessThenOneUpperCaseValidator.isValid(password) &&
        passwordMinLengthStringValidator.isValid(password) &&
        passwordMaxLengthStringValidator.isValid(password));
  }

  String? get userNameErrorText {
    if (!submittedUserName) {
      return null;
    }
    if (!nonEmptyStringValidator.isValid(userName)) {
      return Strings.userNameIsEmpty;
    }
    if (!nonEmailValidator.isValid(userName)) {
      return Strings.isEmailFormat;
    }
    if (!useEmail && userAlreadyExists) {
      return Strings.userNameAlreadyExists;
    }
    if (!userNameLetterValidator.isValid(userName)) {
      return Strings.userNameBadLetter;
    }
    if (!userNameMaxLengthStringValidator.isValid(userName)) {
      return Strings.userNameTooLong;
    }
    return null;
  }

  bool get userNameIsValid {
    return (!userAlreadyExists &&
        nonEmptyStringValidator.isValid(userName) &&
        nonEmailValidator.isValid(userName) &&
        userNameLetterValidator.isValid(userName) &&
        userNameMaxLengthStringValidator.isValid(userName));
  }

  Stream<SloppyUser?> authStateChanges() {
    return authService.authStateChanges;
  }

  Future<void> clear() async {
    if (authService.isUserExist()) {
      _updateWith(
        loadingStatus: SignUpViewModelLoadingStatus.deletingUser,
      );
      await authService.deleteUser();
      _updateWith(
        loadingStatus: SignUpViewModelLoadingStatus.noLoading,
      );
    }
    _updateWith(
      email: '',
      userName: '',
      password: '',
      submittedEmail: false,
      submittedUserName: false,
      submitted: false,
      userAlreadyExists: false,
    );
  }

  String getSendEmailErrorMessage(SendVerifyEmailResultStatus status) {
    return <SendVerifyEmailResultStatus, String>{
          SendVerifyEmailResultStatus.tooManyRequests: 'リクエスト回数が多すぎます。しばらく時間を置いて、もう一度試してみてください',
          SendVerifyEmailResultStatus.undefined: '予期しないエラーが発生しました',
        }[status] ??
        '予期しないエラーが発生しました';
  }

  String getSighUpErrorMessage(SignUpResultStatus status) {
    if (status == SignUpResultStatus.userAlreadyExists) {
      if (useEmail) {
        return 'このメールアドレスは既に登録されています';
      }
      return 'このユーザー名は既に登録されています';
    }
    return <SignUpResultStatus, String>{
          SignUpResultStatus.tooManyRequests: 'リクエスト回数が多すぎます。しばらく時間を置いて、もう一度試してみてください',
          SignUpResultStatus.undefined: '予期しないエラーが発生しました',
        }[status] ??
        '予期しないエラーが発生しました';
  }

  Future<void> loadAuthenticationInformation() async {
    List<String?> userEmailAndPassword = await authService.loadUserNameOrEmailAndPassword();
    String? userNameOrEmail = userEmailAndPassword.elementAt(0);
    String password = userEmailAndPassword.elementAt(1) ?? '';
    bool useEmail = !(sloppyEmailRegexValidator.isValid(userNameOrEmail ?? ''));
    if (useEmail) {
      _updateWith(email: userNameOrEmail, password: password, useEmail: useEmail);
    } else {
      _updateWith(userName: userNameOrEmail, password: password, useEmail: useEmail);
    }
  }

  Future<void> updateEmail(String email) async {
    bool alreadyExists = await authService.isEmailAlreadyExist(email);
    _updateWith(
        email: email, useEmail: true, submittedEmail: true, userAlreadyExists: alreadyExists);
  }

  void updatePassword(String password) => _updateWith(password: password, submitted: true);

  void updateSavePassword(bool savePassword) {
    _updateWith(savePassword: savePassword);
  }

  Future<void> updateUserName(String userName) async {
    bool alreadyExists = await authService.isUserNameAlreadyExist(userName);
    _updateWith(
      userName: userName,
      useEmail: false,
      submittedUserName: true,
      userAlreadyExists: alreadyExists,
    );
  }

  Future<void> restoreAuthenticationInformation() async {
    if (previousUserEmailName == null) {
      await authService.clearUserNameOrEmailAndPassword();
      return;
    }
    authService.saveUserNameOrEmailAndPassword(previousUserEmailName!, previousPassword);
    previousUserEmailName = null;
    previousPassword = null;
  }

  Future<void> _saveAuthenticationInformation() async {
    String userNameOrEmail;
    String? userPassword;
    List<String?> userEmailAndPassword = await authService.loadUserNameOrEmailAndPassword();
    previousUserEmailName = userEmailAndPassword.elementAt(0);
    previousPassword = userEmailAndPassword.elementAt(1);
    if (useEmail) {
      userNameOrEmail = email;
    } else {
      userNameOrEmail = userName;
    }
    if (savePassword) {
      userPassword = password;
    } else {
      userPassword = null;
    }
    await authService.saveUserNameOrEmailAndPassword(userNameOrEmail, userPassword);
  }

  Future<SignUpResultStatus> submit() async {
    SignUpResultStatus result;
    _updateWith(submitted: true);
    if (!canSubmit) {
      return SignUpResultStatus.invalidPassword;
    }
    _updateWith(loadingStatus: SignUpViewModelLoadingStatus.registeringUser);
    if (useEmail) {
      result = await authService.createUserWithEmailAndPassword(email, password);
    } else {
      result = await authService.createUserWithUserNameAndPassword(userName, password);
    }
    if (result == SignUpResultStatus.successful) {
      await _saveAuthenticationInformation();
    }
    _updateWith(loadingStatus: SignUpViewModelLoadingStatus.noLoading);
    return result;
  }

  void startWatchEmailVerified(Function afterEmailVerifiedCallback) {
    authService.startWatchEmailVerified(afterEmailVerifiedCallback);
  }

  void stopWatchEmailVerified() {
    authService.stopWatchEmailVerified();
  }

  Future<SendVerifyEmailResultStatus> sendEmailVerification() async {
    _updateWith(loadingStatus: SignUpViewModelLoadingStatus.sendingEmail);
    SendVerifyEmailResultStatus result = await authService.sendVerifyEmail();
    _updateWith(loadingStatus: SignUpViewModelLoadingStatus.noLoading);
    return result;
  }
}
