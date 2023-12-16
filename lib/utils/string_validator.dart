import 'package:email_validator/email_validator.dart';

abstract class StringValidator {
  bool isValid(String value) {
    return true;
  }
}

class EmailSubmitValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return EmailValidator.validate(value);
  }
}

class IncludeRegexValidator extends StringValidator {
  final String regexSource;

  IncludeRegexValidator({required this.regexSource});

  @override
  bool isValid(String value) {
    try {
      final RegExp regex = RegExp(regexSource);
      return regex.hasMatch(value);
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class MaxLengthStringValidator extends StringValidator {
  final int max;

  MaxLengthStringValidator(this.max);

  @override
  bool isValid(String value) {
    return (max >= value.length);
  }
}

class MinLengthStringValidator extends StringValidator {
  final int min;

  MinLengthStringValidator(this.min);

  @override
  bool isValid(String value) {
    return (value.length >= min);
  }
}

class NonEmailValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return !EmailSubmitValidator().isValid(value);
  }
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class LessThenOneLowerCaseValidator extends IncludeRegexValidator {
  LessThenOneLowerCaseValidator() : super(regexSource: r'[a-z]');
}

class LessThenOneNumberValidator extends IncludeRegexValidator {
  LessThenOneNumberValidator() : super(regexSource: r'[0-9]');
}

class LessThenOneUpperCaseValidator extends IncludeRegexValidator {
  LessThenOneUpperCaseValidator() : super(regexSource: r'[A-Z]');
}

class RegexValidator implements StringValidator {
  final String regexSource;

  RegexValidator({required this.regexSource});

  @override
  bool isValid(String value) {
    try {
      final RegExp regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class NoSpaceRegexValidator extends RegexValidator {
  NoSpaceRegexValidator() : super(regexSource: r'^\S*$');
}

class UsernameLetterValidator extends RegexValidator {
  UsernameLetterValidator() : super(regexSource: r'^[a-zA-Z0-9_\-.@]*$');
}
