const String leaveRequestsListGQL = """
  query (\$input: PagyInput, \$query: LeaveDayRequestsQuery) {
    LeaveDayRequests(input: \$input, query: \$query) {
      collection {
        id
        userId
        approverId
        from
        to
        timeOff
        requestType
        requestState
        reason
        createdAt
        updatedAt
        lockVersion
        User {
          id
          email
          fullName
          name
          about
          avatarUrl
          createdAt
          companyLevelId
          state
          address
          birthday
          gender
          phone
          timingActiveAt
          timingDeactiveAt
          slackId
        }
        Approver {
          id
          email
          fullName
          name
          about
          avatarUrl
          createdAt
          companyLevelId
          state
          address
          birthday
          gender
          phone
          timingActiveAt
          timingDeactiveAt
          slackId
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
