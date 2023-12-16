import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sloppy/app/auth/sign_in/sign_in_viewmodel.dart';

import '../../parameters.dart';
import '../local_storage/parameter_handler.dart';
import '../local_storage/secure_storage_service.dart';
import 'string_validator.dart';

const String sloppyDomainName = 'sloppy.net';

ActionCodeSettings actionCodeSettings = ActionCodeSettings(
    url: "https://sloppy.page.link/.well-known/assetlinks.json",
    androidPackageName: "net.sloppy",
    //iOSBundleId: "com.example.app",
    handleCodeInApp: true,
    androidMinimumVersion: "21");

enum SendVerifyEmailResultStatus {
  successful,
  tooManyRequests,
  userNotExist,
  undefined,
}

enum SendPasswordResetEmailResultStatus {
  successful,
  invalidEmail,
  failed,
}

enum SignInWithEmailLinkResultStatus {
  successful,
  userNotFound,
  expiredActionCode,
  invalidEmail,
  invalidActionCode,
  userDisable,
  undefined,
}

enum SignUpResultStatus {
  successful,
  invalidPassword,
  userAlreadyExists,
  tooManyRequests,
  undefined,
}

enum SignInMethods {
  userNameAndPassword,
  emailAndPassword,
  googleAccessToken,
  facebookAccessToken,
  undefined,
}

enum SignInWithEmailAndPasswordResultStatus {
  successful,
  tooManyRequests,
  canNotSubmit,
  needEmailVerified,
  userNotExists,
  userDisable,
  wrongPassword,
  undefined,
}

enum SignInWithFacebookResultStatus {
  successful,
  cancelled,
  failed,
  isLogged,
  undefined,
}

enum SignInWithGoogleResultStatus {
  successful,
  missingAuthToken,
  abortedByUser,
  userNotExists,
  userDisable,
  invalidCredential,
  operationNotAllowed,
  userAlreadyExists,
  undefined,
}

@immutable
class SloppyUser {
  final String uid;
  final String? userEmail;
  final String? displayName;
  final bool emailVerified;

  const SloppyUser({
    required this.uid,
    this.userEmail,
    this.displayName,
    this.emailVerified = false,
  });

  bool get needEmailVerified {
    return !(emailVerified || useUserName);
  }

  bool get useUserName {
    return SloppyEmailRegexValidator().isValid(userEmail ?? '');
  }
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ParameterHandler parameterHandler;
  final FlutterSecureStorageService secureStorageService;
  Timer? emailVerifiedWatcher;

  AuthService(this.parameterHandler, this.secureStorageService,
      {this.emailVerifiedWatcher});

  SloppyUser? _convertFirebaseUserToSloppyUser(User? user) {
    if (user == null) {
      return null;
    }
    return SloppyUser(
      uid: user.uid,
      userEmail: user.email,
      displayName: user.displayName,
      emailVerified: user.emailVerified,
    );
  }

  Stream<SloppyUser?> get authStateChanges {
    Stream<SloppyUser?> stream =
        _firebaseAuth.authStateChanges().map(_convertFirebaseUserToSloppyUser);
    return stream;
  }

  SloppyUser? get currentUser {
    return _convertFirebaseUserToSloppyUser(_firebaseAuth.currentUser);
  }

  Future<bool> isEmailAlreadyExist(String email) async {
    if (email.isEmpty) {
      return false;
    }
    try {
      // メールアドレスが既に登録済みか否かを判定する魔法
      // メールアドレスが空の場合、この方法では正しく判定できない
      List<String> methods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return methods.contains('password');
    } catch (e) {
      // パスワードが不正の場合、正常系でここに到達する
    }
    return false;
  }

  bool isUserExist() {
    return _firebaseAuth.currentUser is User;
  }

  String _convertUserNameToSloppyEmail(String userName) {
    String localPart = '';
    if (userName.isNotEmpty) {
      localPart = userName.replaceAll('.', '#');
      localPart = localPart.replaceAll('-', '\$');
      localPart = localPart.replaceAll('_', '%');
      localPart = localPart.replaceAll('@', '&');
      return [localPart, '@', sloppyDomainName].join();
    }
    return '';
  }

  Future<bool> isUserNameAlreadyExist(String userName) async {
    String userEmail = _convertUserNameToSloppyEmail(userName);
    return isEmailAlreadyExist(userEmail);
  }

  Future<List<String?>> loadUserNameOrEmailAndPassword() async {
    String? userNameOrEmail = await secureStorageService.getUserEmail();
    String? password = await secureStorageService.getPassword();
    return [userNameOrEmail, password];
  }

  Future<void> saveUserNameOrEmailAndPassword(
      String userNameOrEmail, String? password) async {
    await secureStorageService.setUserEmail(userNameOrEmail);
    if (password is String) {
      await secureStorageService.setPassword(password);
    } else {
      assert(password == null);
      await secureStorageService.clearPassword();
    }
  }

  Future<void> clearUserNameOrEmailAndPassword() async {
    await secureStorageService.clearUserEmail();
    await secureStorageService.clearPassword();
  }

  SignUpResultStatus _handlerSighUpException(FirebaseAuthException e) {
    return <String, SignUpResultStatus>{
          'too-many-requests': SignUpResultStatus.tooManyRequests,
          'email-already-exists': SignUpResultStatus.userAlreadyExists,
        }[e.code] ??
        SignUpResultStatus.undefined;
  }

  Future<SignUpResultStatus> createUserWithEmailAndPassword(
      String email, String password) async {
    SignUpResultStatus status =
        await _createUserWithEmailAndPassword(email, password);
    if (status == SignUpResultStatus.successful) {
      parameterHandler.set(ParameterKey.signInMethod,
          LastSignInMethodStatus.userNameAndPassword);
    }
    return status;
  }

  Future<SignUpResultStatus> _createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return SignUpResultStatus.successful;
    } on FirebaseAuthException catch (e) {
      return _handlerSighUpException(e);
    } catch (e) {
      return SignUpResultStatus.undefined;
    }
  }

  Future<SignUpResultStatus> createUserWithUserNameAndPassword(
      String userName, String password) async {
    String userEmail = _convertUserNameToSloppyEmail(userName);
    SignUpResultStatus status =
        await _createUserWithEmailAndPassword(userEmail, password);
    if (status == SignUpResultStatus.successful) {
      parameterHandler.set(ParameterKey.signInMethod,
          LastSignInMethodStatus.userNameAndPassword);
    }
    return status;
  }

  Future<bool> deleteUser() async {
    if (_firebaseAuth.currentUser is! User) {
      return false;
    }
    try {
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
//        print('The user must re-authenticate before this operation can be executed.');
      }
      return false;
    }
    return true;
  }

  SendVerifyEmailResultStatus _handlerSendVerifyEmailException(
      FirebaseAuthException e) {
    return <String, SendVerifyEmailResultStatus>{
          'too-many-requests': SendVerifyEmailResultStatus.tooManyRequests,
        }[e.code] ??
        SendVerifyEmailResultStatus.undefined;
  }

  Future<SendVerifyEmailResultStatus> sendVerifyEmail() async {
    if (_firebaseAuth.currentUser is! User ||
        _firebaseAuth.currentUser!.emailVerified) {
      return SendVerifyEmailResultStatus.userNotExist;
    }
    try {
      await _firebaseAuth.currentUser!.sendEmailVerification();
      return SendVerifyEmailResultStatus.successful;
    } on FirebaseAuthException catch (e) {
      return _handlerSendVerifyEmailException(e);
    } catch (e) {
      return SendVerifyEmailResultStatus.undefined;
    }
  }

  Future<SendPasswordResetEmailResultStatus> sendPasswordResetEmail(
      String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return SendPasswordResetEmailResultStatus.successful;
    } catch (e) {
      return SendPasswordResetEmailResultStatus.failed;
    }
  }

  void startWatchEmailVerified(Function afterEmailVerifiedCallback) {
    if (emailVerifiedWatcher is Timer) {
      return;
    }
    emailVerifiedWatcher =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_firebaseAuth.currentUser == null) {
        return;
      }
      await _firebaseAuth.currentUser!.reload();
      bool emailVerified = _firebaseAuth.currentUser!.emailVerified;
      if (emailVerified == true) {
        timer.cancel();
        stopWatchEmailVerified();
        afterEmailVerifiedCallback();
      }
    });
  }

  void stopWatchEmailVerified() {
    if (emailVerifiedWatcher is Timer) {
      emailVerifiedWatcher!.cancel();
      emailVerifiedWatcher = null;
    }
  }

  SignInWithEmailAndPasswordResultStatus
      _handlerSighInWithEmailAndPasswordException(FirebaseAuthException e) {
    return <String, SignInWithEmailAndPasswordResultStatus>{
          "too-many-requests":
              SignInWithEmailAndPasswordResultStatus.tooManyRequests,
          "user-not-found":
              SignInWithEmailAndPasswordResultStatus.userNotExists,
          "user-disabled": SignInWithEmailAndPasswordResultStatus.userDisable,
          "wrong-password":
              SignInWithEmailAndPasswordResultStatus.wrongPassword,
        }[e.code] ??
        SignInWithEmailAndPasswordResultStatus.undefined;
  }

  Future<SignInWithEmailAndPasswordResultStatus> signInWithEmailAndPassword(
      String email, String password) async {
    SignInWithEmailAndPasswordResultStatus status =
        await _signInWithEmailAndPassword(email, password);
    if (status == SignInWithEmailAndPasswordResultStatus.successful) {
      parameterHandler.set(ParameterKey.signInMethod,
          LastSignInMethodStatus.userEmailAndPassword);
    }
    return status;
  }

  Future<SignInWithEmailAndPasswordResultStatus> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      bool needEmailVerified =
          _convertFirebaseUserToSloppyUser(userCredential.user)
                  ?.needEmailVerified ??
              true;
      if (needEmailVerified) {
        return SignInWithEmailAndPasswordResultStatus.needEmailVerified;
      } else {
        return SignInWithEmailAndPasswordResultStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      return _handlerSighInWithEmailAndPasswordException(e);
    } catch (e) {
      return SignInWithEmailAndPasswordResultStatus.undefined;
    }
  }

  Future<SignInWithEmailAndPasswordResultStatus> signInWithUserNameAndPassword(
      String userName, String password) async {
    String userEmail = _convertUserNameToSloppyEmail(userName);
    SignInWithEmailAndPasswordResultStatus status =
        await _signInWithEmailAndPassword(userEmail, password);
    if (status == SignInWithEmailAndPasswordResultStatus.successful) {
      parameterHandler.set(ParameterKey.signInMethod,
          LastSignInMethodStatus.userNameAndPassword);
    }
    return status;
  }

  SignInWithGoogleResultStatus _handlerSighInWithGoogleException(
      FirebaseAuthException e) {
    return <String, SignInWithGoogleResultStatus>{
          "user-not-found": SignInWithGoogleResultStatus.userNotExists,
          "user-disabled": SignInWithGoogleResultStatus.userDisable,
          "invalid-credential": SignInWithGoogleResultStatus.invalidCredential,
          "operation-not-allowed":
              SignInWithGoogleResultStatus.operationNotAllowed,
          'account-exists-with-different-credential':
              SignInWithGoogleResultStatus.userAlreadyExists,
        }[e.code] ??
        SignInWithGoogleResultStatus.undefined;
  }

  Future<SignInWithGoogleResultStatus> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return SignInWithGoogleResultStatus.abortedByUser;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    if (googleAuth.accessToken is String && googleAuth.idToken is String) {
      try {
        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        //_userFromFirebase(userCredential.user);
        return SignInWithGoogleResultStatus.successful;
      } on FirebaseAuthException catch (e) {
        return _handlerSighInWithGoogleException(e);
      }
    }
    return SignInWithGoogleResultStatus.missingAuthToken;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
