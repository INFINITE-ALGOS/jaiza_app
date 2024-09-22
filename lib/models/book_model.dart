class Books
{
  String title;
  String fileUrl;
  String cover;

  Books
      ({
    required this.title,
    required this.fileUrl,
    required this.cover,
  });

  factory Books.fromMap(Map<String, dynamic> json) {
    return Books(
      title: json['title'],
      fileUrl: json['fileUrl'],
      cover: json['cover'],
    );
  }
}