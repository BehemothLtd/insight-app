class Metadata {
  String? total;
  int? perPage;
  int? page;
  int? pages;
  int? count;
  int? next;
  int? prev;
  int? from;
  int? to;

  Metadata({
    this.total,
    this.perPage,
    this.page,
    this.pages,
    this.count,
    this.next,
    this.prev,
    this.from,
    this.to,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      total: json['total'],
      perPage: json['perPage'],
      page: json['page'],
      pages: json['pages'],
      count: json['count'],
      next: json['next'],
      prev: json['prev'],
      from: json['from'],
      to: json['to'],
    );
  }
}
