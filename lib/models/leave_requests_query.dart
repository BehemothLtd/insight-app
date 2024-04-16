class LeaveRequestsQuery {
  String requestTypeEq;
  String requestStateEq;
  int? userIdEq;

  LeaveRequestsQuery({
    this.requestTypeEq = "",
    this.requestStateEq = "",
    this.userIdEq,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestTypeEq': requestTypeEq,
      'requestStateEq': requestStateEq,
      'userIdEq': userIdEq,
    };
  }
}
