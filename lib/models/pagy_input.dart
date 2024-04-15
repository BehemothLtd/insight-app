class PagyInput {
  int perPage;
  int page;

  PagyInput({
    required this.perPage,
    required this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'perPage': perPage,
    };
  }
}
