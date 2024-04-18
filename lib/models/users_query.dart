class UsersQuery {
  String nameCont;
  String fullNameCont;
  String emailCont;
  String slackCont;
  String stateEq;

  UsersQuery({
    this.nameCont = "",
    this.fullNameCont = "",
    this.emailCont = "",
    this.slackCont = "",
    this.stateEq = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'nameCont': nameCont,
      'fullNameCont': fullNameCont,
      'emailCont': emailCont,
      'slackCont': slackCont,
      'stateEq': stateEq,
    };
  }
}
