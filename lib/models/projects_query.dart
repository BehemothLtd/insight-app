class ProjectsQuery {
  String nameCont;
  String descriptionCont;
  String projectTypeEq;
  String stateEq;

  ProjectsQuery({
    this.nameCont = "",
    this.descriptionCont = "",
    this.projectTypeEq = "",
    this.stateEq = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'nameCont': nameCont,
      'descriptionCont': descriptionCont,
      'projectTypeEq': projectTypeEq,
      'stateEq': stateEq,
    };
  }
}
