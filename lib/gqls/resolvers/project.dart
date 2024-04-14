const String projectsListGQL = """
  query (\$input: PagyInput, \$query: ProjectsQuery) {
    Projects(input: \$input, query: \$query) {
      collection {
        id
        name
        code
        description
        projectType
        state
        lockVersion
        logoUrl
        projectAssignees {
          user {
            id
            name
            avatarUrl
          }
        }
      }
      metadata {
        total
        perPage
        page
        pages
        count
        next
        prev
        from
        to
      }
    }
  }
""";
