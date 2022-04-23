class User {
  int id = 0;
  String name = "";
  String email = "";
  String? photo = "";
  String level = "";
  int point = 0;
  int complete_sub_category = 0;

  int get getId => this.id;
  set setId(int id) => this.id = id;

  get getName => this.name;
  set setName(name) => this.name = name;

  get getEmail => this.email;
  set setEmail(email) => this.email = email;

  get getPhoto => this.photo;
  set setPhoto(photo) => this.photo = photo;

  get getLevel => this.level;
  set setLevel(level) => this.level = level;

  get getPoint => this.point;
  set setPoint(point) => this.point = point;

  get getCompleteSubCategory => this.complete_sub_category;
  set setCompleteSubCategory(complete_sub_category) =>
      this.complete_sub_category = complete_sub_category;

  User() {}

  User.toString(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    email = data['email'];
    photo = data['profile_photo_path'];
  }

  User.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.name = parsedJson['name'];
    this.email = parsedJson['email'];
    this.photo = parsedJson['profile_photo_path'];
  }

  User.allUser(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.name = parsedJson['name'];
    this.email = parsedJson['email'];
    this.photo = parsedJson['profile_photo_path'];
    this.level = parsedJson['level'];
    this.point = parsedJson['point'];
    this.complete_sub_category = parsedJson['complete_sub_category'];
  }
}
