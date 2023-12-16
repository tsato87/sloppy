import 'package:sloppy/utils/string_validator.dart';

import 'auth_service.dart' as auth_service;

class SloppyEmailRegexValidator extends RegexValidator {
  SloppyEmailRegexValidator() : super(regexSource: '^\\S*@${auth_service.sloppyDomainName}\$');
}