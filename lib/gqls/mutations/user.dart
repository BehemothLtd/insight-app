const String selfUpdateProfileGQL = """
mutation (\$input: SelfUpdateProfileInput!) {
  SelfUpdateProfile(input: \$input) {
    user {
      id
      email
      fullName
      name
      about
      avatarUrl
      address
      birthday
      gender
      phone
      slackId
    }
  }
}
""";
