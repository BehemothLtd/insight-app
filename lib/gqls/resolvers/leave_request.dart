const String leaveRequestsListGQL = """
  query (\$input: PagyInput, \$query: LeaveDayRequestsQuery) {
    LeaveDayRequests(input: \$input, query: \$query) {
      collection {
        id
        from
        to
        timeOff
        requestType
        requestState
        reason
        User {
          id
          fullName
          name
          avatarUrl
        }
        Approver {
          id
          fullName
          name
          avatarUrl
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
