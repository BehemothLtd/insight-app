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
