const String signInMutation = """
  mutation (\$email: String!, \$password: String!) {
    SignIn(email: \$email, password: \$password) {
      token
    }
  }
""";
