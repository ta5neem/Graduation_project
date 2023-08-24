enum LoginType { signIn, signUp }

extension LoginTypeExt on LoginType {
  String get getTypeName {
    switch (this) {
      case LoginType.signIn:
        return "Login";

      case LoginType.signUp:
        return "Sign up";

      default:
        return "";
    }
  }
}
