const String leaveRequestCreateGQL = """
  mutation (\$input: LeaveDayRequestInput!) {
    LeaveDayRequestCreate(
      input: \$input
    ) {
        leaveDayRequest {
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
        }
    }
}

""";

const String leaveRequestChangeStateGQL = """
  mutation (\$id: ID!, \$requestState: String!) {
    LeaveDayRequestStateChange(id: \$id, requestState: \$requestState) {
      leaveDayRequest {
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
      }
    }
  }
""";
