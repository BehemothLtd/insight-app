const String signInGQL = """
  mutation (\$email: String!, \$password: String!) {
    SignIn(email: \$email, password: \$password) {
      token
    }
  }
""";
