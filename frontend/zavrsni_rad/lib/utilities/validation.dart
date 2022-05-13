String? validatePassword(String? pass, String? repeatPass) {
  if (pass == null) return "Password can not be empty!";
  if (pass.length < 8) return "Password must contain atleast 8 characters";
  List<String> specialCharacters = [
    "!",
    ".",
    "#",
    ":",
    ";",
    "-",
    "+",
    "*",
    "/",
    "%",
    "\$",
    "&",
    "(",
    ")",
    "{",
    "}",
    ",",
    "=",
    "?"
  ];
  bool any = specialCharacters.any((element) => pass.contains(element));
  if (!any) return "Password must contain at least 1 special character";
  if (pass.toLowerCase() == pass) {
    return "Password must contain atleas 1 uppercase";
  }
  if (pass != repeatPass) return "Passwords don't match";
  return null;
}

String? validateEmail(String? mail) {
  if (mail == null) return "Email can not be empty!";
  if (!mail.contains("@")) return "Not an email";
  return null;
}

String? validateNotEmpty(String? string) {
  if (string == null) return "Filed can not be empty";
  if (string.isEmpty) return "Filed can not be empty";
  return null;
}

String? validateLength(String? string, int length) {
  if (string == null) return "Field can not be empty";
  if (string.length > length) return "Maximum $length characters";
  return null;
}

String? validateIsNumber(String? string) {
  if (string == null) return "Field can not be empty";
  if (int.tryParse(string) == null) return "Field must be a number";
  return null;
}
