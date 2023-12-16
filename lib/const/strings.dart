// Sign In Page
class Strings {
  // ボタンのラベルテキスト
  static const String signInWithEmailPassword = 'ログイン';
  static const String register = '新規登録';
  static const String goToHomePage = 'ホーム画面へ戻る';
  static const String ok = 'OK';
  static const String next = '次へ';
  static const String cancel = 'キャンセル';

  // 入力フォーム
  static const String userNameOrEmailFormField = 'ユーザー名 または メールアドレス';
  static const String userNameFormField = 'ユーザー名';
  static const String emailFormField = 'メールアドレス';
  static const String passwordFormField = 'パスワード';

  // サインアップ
  static const String pleaseSetEmail = 'メールアドレスを設定してください';
  static const String pleaseSetUserName = 'ユーザー名を設定してください';
  static const String orSignInWithSNSAccount = '外部IDでサインアップ';
  static const String goToSignInPage = 'ログイン画面へ';

  // ユーザー名のエラーメッセージ
  static const String userNameIsEmpty = 'ユーザー名が空です';
  static const String userNameBadLetter = 'ユーザー名には、大小の英字と数字の他に、'
      '\n『_』『-』『.』『@』を使用できます';
  static const String userNameTooLong = '文字数が多いです。(1文字以上、20字以内)';
  static const String userNameAlreadyExists = 'このユーザー名は使用できません';
  static const String isEmailFormat = 'メールアドレスは使用できません';

  // メールアドレスの入力エラー
  static const String emailIsEmpty = 'メールアドレスが空です';
  static const String emailIsInvalid = '正しいメールアドレスを入力してください';
  static const String emailAlreadyExists = 'このメールアドレスは使用できません';
  static const String emailCannotUse = 'このメールアドレスは使用できません';

  // パスワードの入力エラー
  static const String passwordIsEmpty = 'パスワードが空です';
  static const String passwordLessThanOneLetter = 'パスワードには、大文字・小文字の英字と数字を、'
      '\nそれぞれ最低1文字は含める必要があります';
  static const String passwordTooShort = '文字数が足りません。(8文字以上、24文字以内)';
  static const String passwordTooLong = '文字数が多いです。(8文字以上、24文字以内)';

  // サインイン
  static const String or = '外部IDでログイン';
  static const String forgetPassword = 'パスワードをお忘れですか？';
  static const String createNewAccount = '新しいアカウントを作る';

  // ユーザー名またはメールアドレスの入力エラー
  static const String userNameOrEmailIsEmpty = 'ユーザー名 または メールアドレスを入力してください';
  static const String userNotExists = 'ユーザー名 または メールアドレスが間違っています';
  static const String passwordNotMatch = 'パスワードが間違っています';
  static const String asUserNameTooLong = 'ユーザー名としては、文字数が多いです。(1文字以上、20字以内)';

  // パスワード再設定用メールの送信エラー
  static const String failedToSendPasswordResetEmail = 'パスワード再設定用メールの送信に失敗しました';
  static const String completedToSendEmail = 'メール送信完了';
  static const String pleaseOpenResetPasswordLink = 'パスワード再設定用メールを送信しました '
      '\nメール文中のリンクを開いて、パスワードを再設定してください';

}
