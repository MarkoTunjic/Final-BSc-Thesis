const String login = """
  mutation Login(\$identifier: String!,\$password: String!){
    login(identifier: \$identifier, password: \$password){
      token,
      user{
        id,
        username,
        eMail,
        profilePicture,
        role{
          roleName
        }
      }
    }
  }
""";
