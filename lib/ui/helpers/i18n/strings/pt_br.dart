import 'translations.dart';

class PtBr implements Translations {
  String get msgEmailInUse => 'O email já esta em uso.';
  String get msgInvalidCredentials => 'Credenciais inválidas.';
  String get msgRequiredField => 'Campo obrigatório.';
  String get msgInvalidField => 'Campo inválido.';
  String get msgUnexpectedError =>
      'Algo de errado aconteceu. Tente novamente em breve.';

  String get loading => 'Aguarde...';
  String get reloading => 'Recarregar';
  String get news => 'Novidades';
}
