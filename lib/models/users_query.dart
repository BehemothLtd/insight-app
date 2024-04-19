class UsersQuery {
  String nameCont;
  String fullNameCont;
  String emailCont;
  String slackIdLike;
  String stateEq;

  UsersQuery({
    this.nameCont = "",
    this.fullNameCont = "",
    this.emailCont = "",
    this.slackIdLike = "",
    this.stateEq = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'nameCont': nameCont,
      'fullNameCont': fullNameCont,
      'emailCont': emailCont,
      'slackIdLike': slackIdLike,
      'stateEq': stateEq,
    };
  }
}
