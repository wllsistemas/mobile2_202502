class UserModel {
  int id = 0;
  String firstName = '';
  String lastName = '';
  String gender = '';
  String image = '';

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    image = json['image'];
  }
}
