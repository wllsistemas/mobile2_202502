class PostModel {
  int userId = 0;
  int id = 0;
  String title = '';
  String body = '';

  PostModel();

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    body = json['body'];
  }
}
