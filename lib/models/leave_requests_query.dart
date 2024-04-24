class LeaveRequestsQuery {
  String requestTypeEq;
  String requestStateEq;
  int? userIdEq;
  String toLtEq;
  String fromGtEq;

  LeaveRequestsQuery({
    this.requestTypeEq = "",
    this.requestStateEq = "",
    this.userIdEq,
    this.toLtEq = "",
    this.fromGtEq = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'requestTypeEq': requestTypeEq,
      'requestStateEq': requestStateEq,
      'userIdEq': userIdEq,
      'toLtEq': toLtEq,
      'fromGtEq': fromGtEq,
    };
  }
}
