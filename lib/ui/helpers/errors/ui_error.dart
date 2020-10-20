import '../helpers.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
}

extension DomainErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return R.translations.msgRequiredField;
        break;
      case UIError.invalidField:
        return R.translations.msgInvalidField;
        break;
      case UIError.invalidCredentials:
        return R.translations.msgInvalidCredentials;
        break;
      case UIError.emailInUse:
        return R.translations.msgEmailInUse;
        break;
      default:
        return R.translations.msgUnexpectedError;
        break;
    }
  }
}
