class Validation {
  validateEmail(String text) {
    return text.isEmpty ? 'Please Provide Your Valid Email Address' : null;
  }

  validatePassword(String text) {
    if (text.isEmpty) {
      return 'Please Provide A Valid Password';
    } else {
      String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$';
      RegExp exp = RegExp(pattern);
      if (!exp.hasMatch(text)) {
        return 'Please Provide A Valid Password';
      }
    }
  }
}
