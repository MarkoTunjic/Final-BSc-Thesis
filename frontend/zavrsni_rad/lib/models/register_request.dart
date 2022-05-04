class RegisterRequest {
  String username;
  String eMail;
  String password;
  String? profilePicture;

  RegisterRequest({
    required this.username,
    required this.eMail,
    required this.password,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "eMail": eMail,
      "password": password,
      "profilePicture": profilePicture
    };
  }
}
